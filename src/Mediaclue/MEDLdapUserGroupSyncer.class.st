Class {
	#name : #MEDLdapUserGroupSyncer,
	#superclass : #MEDObject,
	#instVars : [
		'ldapConnection'
	],
	#category : #'Mediaclue-Misc'
}

{ #category : #'as yet unclassified' }
MEDLdapUserGroupSyncer >> ldapSearchUserGroup: aUserGroup [
	| result |

	"- Probieren mit direkt angegebenem uid (typischerweise = Username)"
	aUserGroup uid ifNotBlank: [ :uid |
		result := self searchByCn: uid.
		result ifNotNil: [ ^ result ] ].

	^nil
]

{ #category : #'as yet unclassified' }
MEDLdapUserGroupSyncer >> searchByCn: aString [
	| request result |

	request := ldapConnection
		newSearch: (self globalConfiguration ldapBaseDn)
		scope: (LDAPConnection wholeSubtree)
		deref: (LDAPConnection derefNever)
		filter: (LDAPFilter andOf: {
			LDAPFilter with: 'cn' equalTo: aString.
			LDAPFilter with: 'objectClass' equalTo: 'group'.
		})
		attrs: #(dn)
		wantAttrsOnly: false.
	
	result := request result at: 1 ifAbsent: [^nil].
	result isReference ifTrue: [ ^nil ].
	
	^ result
]

{ #category : #'as yet unclassified' }
MEDLdapUserGroupSyncer >> searchUserByDn: aDnString [
	| user |
	user := self db identityProvider searchUserByLdapDn: aDnString autoCreate: true.
	
	user ifNil: [ ^ nil ].
	
	user isEmpty ifTrue: [ ^ nil ].
	
	^ user
]

{ #category : #'as yet unclassified' }
MEDLdapUserGroupSyncer >> smartWithMembersOfGroupDn: aDnString do: aBlock [

	| request result requestedMemberAttribute hasMore start end counter memberAttributes |

	requestedMemberAttribute := 'member'.
	hasMore := true.
	counter := 1. "for endless loop safety..."

	[ hasMore and: [ counter < 10 "just something inside sanity" ] ] whileTrue: [
	
		counter := counter + 1.
	
"		request := ldapConnection
			newSearch: (self globalConfiguration ldapBaseDn)
			scope: (LDAPConnection wholeSubtree)
			deref: (LDAPConnection derefNever)
			filter: (LDAPFilter andOf: {
				LDAPFilter with: 'dn' equalTo: aDnString.
				LDAPFilter with: 'objectClass' equalTo: 'group'.
			})
			attrs: { requestedMemberAttribute }
			wantAttrsOnly: false."
		
		request := ldapConnection
			newSearch: aDnString
			scope: (LDAPConnection baseObject)
			deref: (LDAPConnection derefNever)
			filter: (LDAPFilter with: 'objectClass' equalTo: 'group')
			attrs: { requestedMemberAttribute }
			wantAttrsOnly: false.		
		
		result := request result at: 1 ifAbsent: [ ^ self ].
"		result isReference ifTrue: [ ^nil ]."
		result isReference ifTrue: [ self error: 'LDAP reference received. Should not happen?'].
		
		"Get the current attribute name, and check if it is ranged. Bloody shitty Microsoft AD bullshit hack!"
		memberAttributes := (result attrs keys select: [ :each | each beginsWith: 'member' ]) sorted. "will be 2 on the first call, if ranged"

		memberAttributes do: [ :realMemberAttribute |
			
			(realMemberAttribute includesSubstring: 'range') ifFalse: [ hasMore := false ]
				ifTrue: [
					realMemberAttribute readStreamDo: [ :s |
						s upTo: $;.
"						s next."
						start := (s upTo: $-) asInteger.
"						s next."
						end := s upToEnd.
						
						end = '*' ifTrue: [ hasMore := false ] ifFalse: [ hasMore := true. end := end asInteger ].
					]
				].
			
			(result attrsAt: realMemberAttribute) do: aBlock.
		].
	
		hasMore ifTrue: [
			"Get the next 500, giving a range attribute extension. Fuck MS"
			requestedMemberAttribute := 'member;range=', (end + 1) asString, '-', (end + 500) asString.
		].
	]
]

{ #category : #public }
MEDLdapUserGroupSyncer >> sync [
	| userGroups |

	self db identityProvider withConnectionDo: [ :connection |	

		"Hm, kind of ugly, but we want 1 single connection being reused,
		because of performance"
		ldapConnection := connection.
		
		userGroups := self db userGroups select: [ :each | each uid notBlank ].

		userGroups do: [ :eachGroup |
			| result |
			
			result := self ldapSearchUserGroup: eachGroup.
			
			result ifNotNil: [
				| users |
				users := OrderedCollection new.
				"Microsoft active directory macht hier eine komische 1500er Limite und trennt die Attribute bei grossen Gruppen. Shitty MS."
"				#('member' 'member;range=0-1499' 'member;range=1500-2999') do: [ :eachAttr |"
				self smartWithMembersOfGroupDn: result dn do: [ :eachMemberDn |
					| user |
					user := self searchUserByDn: eachMemberDn.
					users addIfNotNil: user
				].
				
				users := users copyWithoutNils.
				eachGroup users: users.
				eachGroup save.
			].
		].

		ldapConnection := nil.
	].
	
	^ userGroups
]
