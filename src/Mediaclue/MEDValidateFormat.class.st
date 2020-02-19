Class {
	#name : #MEDValidateFormat,
	#superclass : #MEDAttributeValidationRule,
	#instVars : [
		'regularExpression'
	],
	#category : #'Mediaclue-Validation'
}

{ #category : #'as yet unclassified' }
MEDValidateFormat >> isValid [
	| value |
	
	self ifBlankAndAllowed: [^true].
	
	value := self attributeValue.
	^value isEmptyOrNil
		ifTrue: [false]
		ifFalse: [value matchesRegexIgnoringCase: regularExpression]
]

{ #category : #'as yet unclassified' }
MEDValidateFormat >> renderErrorMessageOn: html [
	html text: 'Attribut hat falsches Format: '.
	html text: self attributeName.

]

{ #category : #'as yet unclassified' }
MEDValidateFormat >> withRegexp: aRegularExpressionString [
	regularExpression := aRegularExpressionString
]
