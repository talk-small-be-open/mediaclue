Class {
	#name : #WEBLocalIdentityProvider,
	#superclass : #WEBIdentityProviderBase,
	#category : #'Webbase-Main-Database'
}

{ #category : #'as yet unclassified' }
WEBLocalIdentityProvider >> authenticateUser: aUser password: aPassword [
	"Checks if the aPassword is correct"

	^ (aUser isValidPassword: aPassword)
]
