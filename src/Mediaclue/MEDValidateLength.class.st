Class {
	#name : #MEDValidateLength,
	#superclass : #MEDAttributeValidationRule,
	#instVars : [
		'minimum',
		'maximum'
	],
	#category : #'Mediaclue-Validation'
}

{ #category : #testing }
MEDValidateLength >> isTooLong [
	^maximum notNil and: [self attributeValue size > maximum]
]

{ #category : #testing }
MEDValidateLength >> isTooShort [
	^minimum notNil and: [self attributeValue size < minimum]
]

{ #category : #'as yet unclassified' }
MEDValidateLength >> isValid [
	self isTooShort ifTrue: [^false].
	self isTooLong ifTrue: [^false].

	^true
]

{ #category : #accessing }
MEDValidateLength >> maximum [
	^ maximum
]

{ #category : #accessing }
MEDValidateLength >> maximum: anObject [
	maximum := anObject
]

{ #category : #accessing }
MEDValidateLength >> minimum [
	^ minimum
]

{ #category : #accessing }
MEDValidateLength >> minimum: anObject [
	minimum := anObject
]

{ #category : #'as yet unclassified' }
MEDValidateLength >> renderErrorMessageOn: html [
	html text: 'Attribut hat falsche Länge: '.
	html text: self attributeName.

]
