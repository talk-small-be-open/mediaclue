Class {
	#name : #MEDLdapIdentityProvider,
	#superclass : #WEBLdapIdentityProvider,
	#category : #'Mediaclue-Misc'
}

{ #category : #'as yet unclassified' }
MEDLdapIdentityProvider >> createNewUserFromLdapResult: aResult [
	| user |
	user := MEDUser new.
	user
		ldapUid: (aResult attrAt: self globalConfiguration ldapUidField);
		firstName: (aResult attrAt: 'givenName') asString;
		lastName: (aResult attrAt: 'sn') asString;
		email: (aResult attrAt: 'mail').

	user save.

	^ user
]

{ #category : #initialization }
MEDLdapIdentityProvider >> initialize [
	super initialize.
	self bePrimaryUserSource
]
