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
		attrs: #(member)
		wantAttrsOnly: false.
	
	result := request result at: 1 ifAbsent: [^nil].
	result isReference ifTrue: [ ^nil ].
	
	^result
]

{ #category : #'as yet unclassified' }
MEDLdapUserGroupSyncer >> searchUserByDn: aDnString [
	^ self db identityProvider searchUserByLdapDn: aDnString autoCreate: true
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
				#('member' 'member;range=0-1499' 'member;range=1500-2999') do: [ :eachAttr |
"				#('member') do: [ :eachAttr |"
					(result attrsAt: eachAttr) ifNotBlank: [ :collection | collection do: [ :eachMemberDn |
						| user |
						user := self searchUserByDn: eachMemberDn.
						users addIfNotNil: user
					]].
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
