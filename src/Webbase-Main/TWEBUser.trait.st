Trait {
	#name : #TWEBUser,
	#category : #'Webbase-Main-Traits'
}

{ #category : #'as yet unclassified' }
TWEBUser classSide >> generatePasswordHash: aPlaintextPassword [
	^WEBHelper generatePasswordHash: aPlaintextPassword
]

{ #category : #attributes }
TWEBUser >> disabled [
	"subclasses"
	^false
]

{ #category : #attributes }
TWEBUser >> disabled: aBoolean [
	"subclasses"
]

{ #category : #testing }
TWEBUser >> hasPassword [
	^ self hashedPassword notBlank
]

{ #category : #'as yet unclassified' }
TWEBUser >> hashedPassword [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
TWEBUser >> hashedPassword: aValue [
	self subclassResponsibility
]

{ #category : #attributes }
TWEBUser >> isDisabled [
	^ self disabled = true
]

{ #category : #attributes }
TWEBUser >> isEnabled [
	^ self isDisabled not
]

{ #category : #testing }
TWEBUser >> isValidPassword: aPassword [
	"Checks if the aPassword is correct"
	| valid |
	
	"Leeres Passwort ist nie OK"
	aPassword ifBlank: [^false].

	"Passwort aus Leerzeichen nie OK"
	aPassword trimBoth ifEmpty: [ ^false ].
	
	valid := false.

	valid := self isValidPasswordHash: (self class generatePasswordHash: aPassword).
		
	^valid = true
]

{ #category : #testing }
TWEBUser >> isValidPasswordHash: aPasswordHash [
	aPasswordHash ifBlank: [ ^ false ].
	self hashedPassword ifBlank: [ ^ false ].

	^ self hashedPassword asArray = aPasswordHash asArray
]

{ #category : #accessing }
TWEBUser >> password: aPasswordString [
	aPasswordString isEmptyOrNil ifFalse: [
		| hash |
		hash := self class generatePasswordHash: aPasswordString.

		(self hashedPassword ~= hash) ifTrue: [
			self hashedPassword: hash].
	].

]

{ #category : #accessing }
TWEBUser >> username [
	self subclassResponsibility
]

{ #category : #accessing }
TWEBUser >> username: aString [
	self subclassResponsibility
]
