Class {
	#name : #MEDValidatePresence,
	#superclass : #MEDAttributeValidationRule,
	#category : #'Mediaclue-Validation'
}

{ #category : #'initialize-release' }
MEDValidatePresence >> initialize [
	super initialize.
	
	allowEmpty := false.
]

{ #category : #validation }
MEDValidatePresence >> isValid [
	| value |
	value := self attributeValue.
	
	value ifNil: [^false].

	self ifEmptyAndNotAllowed: [^false].

	^true
]

{ #category : #'as yet unclassified' }
MEDValidatePresence >> renderErrorMessageOn: html [
	html text: 'Attribut muss angegeben werden: '.
	html text: self attributeName.

]
