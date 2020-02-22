Class {
	#name : #WEBIdentityProviderBase,
	#superclass : #WEBObject,
	#category : #'Webbase-Main-Database'
}

{ #category : #'as yet unclassified' }
WEBIdentityProviderBase >> authenticateUser: aUser password: aPassword [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WEBIdentityProviderBase >> createNewUser [
	^ self pi defaultUserClass new
]

{ #category : #'as yet unclassified' }
WEBIdentityProviderBase >> ensurePasswordNonStupid: aPassword [
	| bad |
	bad := [ WEBAuthenticationError signal ].
	
	"Leeres Passwort ist nie OK"
	aPassword ifBlank: bad.

	"Passwort aus Leerzeichen nie OK"
	aPassword trimBoth ifEmpty: bad.
	

]

{ #category : #testing }
WEBIdentityProviderBase >> isPrimaryUserSource [
	"Gibt an, ob dieser Identity Provider die Hoheit über die Menge der
	User hat, oder ob er nur nachgelagert ist"
	^ false
]

{ #category : #'as yet unclassified' }
WEBIdentityProviderBase >> isUser: aUser validPassword: aPassword [
	[
	
	self ensurePasswordNonStupid: aPassword.
	(self authenticateUser: aUser password: aPassword) ifTrue: [ ^ true ].
	
	] on: Error do: [:error |
		self logDebug: 'Authentication failed with Exception: ', error description.
		self ifDevelopment: [ error pass ].
		^ false ].

	self logDebug: 'Authentication failed of: ', aUser displayName.

	^ false
]

{ #category : #'as yet unclassified' }
WEBIdentityProviderBase >> syncToLocalUsers [
]
