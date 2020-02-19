Class {
	#name : #MEDValidateAbsence,
	#superclass : #MEDAttributeValidationRule,
	#category : #'Mediaclue-Validation'
}

{ #category : #'initialize-release' }
MEDValidateAbsence >> initialize [
	super initialize.
	
	allowEmpty := true.
]

{ #category : #validation }
MEDValidateAbsence >> isValid [
	| value |
	value := self attributeValue.
	
	value ifNil: [^true].

	self ifEmptyAndAllowed: [^true].

	^false
]

{ #category : #'as yet unclassified' }
MEDValidateAbsence >> renderErrorMessageOn: html [
	html text: 'Attribut darf nicht vorhanden sein: '.
	html text: self attributeName.

]
