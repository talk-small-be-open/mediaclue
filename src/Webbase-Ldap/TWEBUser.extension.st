Extension { #name : #TWEBUser }

{ #category : #'*Webbase-Ldap' }
TWEBUser >> isAuthenticateAtLdap [
	^true
]

{ #category : #'*Webbase-Ldap' }
TWEBUser >> ldapCustomUid [
	"subclasses"
	^ nil
]

{ #category : #'*Webbase-Ldap' }
TWEBUser >> ldapCustomUid: aValue [
	"subclasses"
]

{ #category : #'*Webbase-Ldap' }
TWEBUser >> ldapUid [
	"default"
	^ self username
]

{ #category : #'*Webbase-Ldap' }
TWEBUser >> ldapUid: aValue [
	"default"
	self username: aValue
]
