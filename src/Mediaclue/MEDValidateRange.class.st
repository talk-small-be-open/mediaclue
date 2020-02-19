Class {
	#name : #MEDValidateRange,
	#superclass : #MEDAttributeValidationRule,
	#instVars : [
		'minimum',
		'maximum'
	],
	#category : #'Mediaclue-Validation'
}

{ #category : #initialization }
MEDValidateRange >> initialize [
	super initialize.
]

{ #category : #testing }
MEDValidateRange >> isTooBig [
	^self maximumValue notNil and: [self attributeValue > (self maximumValue)]
]

{ #category : #testing }
MEDValidateRange >> isTooSmall [
	^self minimumValue notNil and: [self attributeValue < (self minimumValue)]
]

{ #category : #'as yet unclassified' }
MEDValidateRange >> isValid [
	self ifNilAndAllowed: [^true] notAllowed: [^false].
	
	self isTooSmall ifTrue: [^false].
	self isTooBig ifTrue: [^false].

	^true
]

{ #category : #accessing }
MEDValidateRange >> maximum [
	^ maximum
]

{ #category : #accessing }
MEDValidateRange >> maximum: anObject [
	maximum := anObject
]

{ #category : #accessing }
MEDValidateRange >> maximumValue [
	^ maximum value
]

{ #category : #accessing }
MEDValidateRange >> minimum [
	^ minimum
]

{ #category : #accessing }
MEDValidateRange >> minimum: anObject [
	minimum := anObject
]

{ #category : #accessing }
MEDValidateRange >> minimumValue [
	^ minimum value
]

{ #category : #'as yet unclassified' }
MEDValidateRange >> renderErrorMessageOn: html [
	html text: 'Attribut nicht in zulässigem Bereich: '.
	html text: self attributeName.

]
