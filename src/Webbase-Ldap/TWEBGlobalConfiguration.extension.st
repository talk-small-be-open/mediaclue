Extension { #name : #TWEBGlobalConfiguration }

{ #category : #'*Webbase-Ldap' }
TWEBGlobalConfiguration >> ldapBaseDn [
	^self at: #ldapBaseDn
]

{ #category : #'*Webbase-Ldap' }
TWEBGlobalConfiguration >> ldapBaseDn: aString [
	self at: #ldapBaseDn put: aString
]

{ #category : #'*Webbase-Ldap' }
TWEBGlobalConfiguration >> ldapCustomUidField [
	^self at: #ldapCustomUidField
]

{ #category : #'*Webbase-Ldap' }
TWEBGlobalConfiguration >> ldapCustomUidField: aString [
	self at: #ldapCustomUidField put: aString
]

{ #category : #'*Webbase-Ldap' }
TWEBGlobalConfiguration >> ldapMainServer [
	^self ldapServersList first
]

{ #category : #'*Webbase-Ldap' }
TWEBGlobalConfiguration >> ldapPassword [
	^self at: #ldapPassword
]

{ #category : #'*Webbase-Ldap' }
TWEBGlobalConfiguration >> ldapPassword: aString [
	self at: #ldapPassword put: aString
]

{ #category : #'*Webbase-Ldap' }
TWEBGlobalConfiguration >> ldapServers [
	^self at: #ldapServers
]

{ #category : #'*Webbase-Ldap' }
TWEBGlobalConfiguration >> ldapServers: aString [
	self at: #ldapServers put: aString
]

{ #category : #'*Webbase-Ldap' }
TWEBGlobalConfiguration >> ldapServersList [
	^self ldapServers findTokens: ', '

]

{ #category : #'*Webbase-Ldap' }
TWEBGlobalConfiguration >> ldapUidField [
	^self at: #ldapUidField
]

{ #category : #'*Webbase-Ldap' }
TWEBGlobalConfiguration >> ldapUidField: aString [
	self at: #ldapUidField put: aString
]

{ #category : #'*Webbase-Ldap' }
TWEBGlobalConfiguration >> ldapUser [
	^self at: #ldapUser
]

{ #category : #'*Webbase-Ldap' }
TWEBGlobalConfiguration >> ldapUser: aString [
	self at: #ldapUser put: aString
]
