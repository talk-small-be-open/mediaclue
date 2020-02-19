Class {
	#name : #MEDValidateEquality,
	#superclass : #MEDAttributeValidationRule,
	#instVars : [
		'equalValue'
	],
	#category : #'Mediaclue-Validation'
}

{ #category : #'as yet unclassified' }
MEDValidateEquality >> isValid [
	| value |
	
	self ifBlankAndAllowed: [^true].

	^self attributeValue = equalValue
]

{ #category : #'as yet unclassified' }
MEDValidateEquality >> renderErrorMessageOn: html [
	html text: 'Attribut nicht identisch: '.
	html text: self attributeName.

]

{ #category : #'as yet unclassified' }
MEDValidateEquality >> to: aValue [
	equalValue := aValue
]
