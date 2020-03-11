Class {
	#name : #WEBLdapIdentityProvider,
	#superclass : #WEBIdentityProviderBase,
	#instVars : [
		'isPrimaryUserSource',
		'ldapConnection'
	],
	#category : #'Webbase-Ldap'
}

{ #category : #'as yet unclassified' }
WEBLdapIdentityProvider >> authenticateAt: aHost as: aBindDn credentials: aPassword [
	| valid |
	aBindDn ifBlank: [ ^ false ].
	aPassword ifBlank: [ ^ false ].

	valid := self withConnectionTo: aHost do: [ :connection |	
		| result passwordUtf8 authOk |
		
		passwordUtf8 := WEBHelper toUtf8: aPassword.
		
"		result := (LDAPBindRequest new initializeWith: worker username: aUsernameDn credentials: passwordUtf8 method: nil) result."

		result := (connection bindAs: aBindDn credentials: passwordUtf8 method: nil) result.
		
		authOk := result notNil and: [ result resultCode = 0 ].
		
		authOk ifFalse: [ 
			self logDebug: 'Authentication failed at LDAP host: ', aHost, ' DN: ', aBindDn.
		].
		
		authOk
	].

	^ valid = true
]

{ #category : #'as yet unclassified' }
WEBLdapIdentityProvider >> authenticateUser: aUser password: aPassword [
	"Checks if the aPassword is correct"
	| valid bindDn |
	
	valid := false.

	"Fallback, if no LDAP auth. We authenticate with local password"
	aUser isAuthenticateAtLdap ifFalse: [ ^ (aUser isValidPassword: aPassword) ].

	aUser ldapUid ifBlank: [
		self logWarning: ('Trying to login, but having no LDAP-UID for user ', aUser displayName, ' with username ', aUser username asString).
		^ false
	].

	"Der User kann prinzipiell irgendwo im LDAP sein. Die DN ist individuell.
	Wir suchen sie jedesmal via ldapUid"
	bindDn := self searchLdapDnForUser: aUser.
	
	bindDn ifBlank: [
		self logWarning: ('Trying to login, but LDAP DN not found for user ', aUser displayName, ' with username ', aUser username asString).
		^ false
	].
	
	valid := self globalConfiguration ldapServersList anySatisfy: [:eachHost |
		self authenticateAt: eachHost as: bindDn credentials: aPassword ].
	
	^ valid = true
]

{ #category : #testing }
WEBLdapIdentityProvider >> bePrimaryUserSource [
	isPrimaryUserSource := true
]

{ #category : #'as yet unclassified' }
WEBLdapIdentityProvider >> createNewUserFromLdapResult: result [
	"subclasses"
	^ self createNewUser
]

{ #category : #initialization }
WEBLdapIdentityProvider >> initialize [
	super initialize.
	isPrimaryUserSource := false
]

{ #category : #testing }
WEBLdapIdentityProvider >> isPrimaryUserSource [
	^ isPrimaryUserSource
]

{ #category : #'as yet unclassified' }
WEBLdapIdentityProvider >> searchLdapDnForUser: aUser [

	"Prevent LDAP search when no UID is known"
	aUser ldapUid ifBlank: [ ^nil ].
	
	^ self withConnectionDo: [ :connection |

		| request result |

		request := connection
			newSearch: (self globalConfiguration ldapBaseDn)
			scope: (LDAPConnection wholeSubtree)
			deref: (LDAPConnection derefNever)
			filter: (LDAPFilter andOf: {
				LDAPFilter with: self globalConfiguration ldapUidField equalTo: aUser ldapUid.
				LDAPFilter with: 'objectClass' equalTo: 'person'.
			})
			attrs: #(dn)
			wantAttrsOnly: false.
		
		result := request result at: 1 ifAbsent: [nil].
		(result notNil and: [ result isReference not ]) ifTrue: [
			result dn ]
	]
]

{ #category : #'as yet unclassified' }
WEBLdapIdentityProvider >> searchUserByLdapDn: aString [
	^ self searchUserByLdapDn: aString autoCreate: false

]

{ #category : #'as yet unclassified' }
WEBLdapIdentityProvider >> searchUserByLdapDn: aString autoCreate: aBoolean [

	| ldapUid user result |

	ldapUid := self withConnectionDo: [ :connection |

		| request |

		request := connection
			newSearch: aString
			scope: (LDAPConnection baseObject)
			deref: (LDAPConnection derefNever)
			filter: (LDAPFilter with: 'objectClass' equalTo: 'person')
			attrs: { self globalConfiguration ldapUidField. 'givenName'. 'sn'. 'mail' }
			wantAttrsOnly: false.
		
		result := request result at: 1 ifAbsent: [nil].
		(result notNil and: [ result isReference not ]) ifTrue: [
			result attrAt: self globalConfiguration ldapUidField ].
	].

	user := self db findUserByLdapUid: ldapUid.
	
	"Autocreate"
	((user isNil and: [ldapUid notBlank]) and: [aBoolean]) ifTrue: [
		user := self createNewUserFromLdapResult: result.
	].
	
	^ user
]

{ #category : #enumerating }
WEBLdapIdentityProvider >> withConnectionDo: aBlock [
	^ self withConnectionTo: self globalConfiguration ldapMainServer do: aBlock
]

{ #category : #enumerating }
WEBLdapIdentityProvider >> withConnectionTo: aHost do: aBlock [
	| result createdConnection |

	createdConnection := false.
	
	(ldapConnection isNil or: [ ldapConnection isValid not ]) ifTrue: [
		ldapConnection := LDAPConnection to: aHost.
		createdConnection := true].

	[
		self globalConfiguration ldapUser ifNotBlank: [ :user |
			ldapConnection bindAs: user credentials: self globalConfiguration ldapPassword].
		result := aBlock value: ldapConnection
	]
	ensure: [
		createdConnection ifTrue: [
			ldapConnection disconnect.
			ldapConnection := nil
		] ].

	^result
]
