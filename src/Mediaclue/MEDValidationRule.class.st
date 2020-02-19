Class {
	#name : #MEDValidationRule,
	#superclass : #MEDObject,
	#instVars : [
		'errorMessage',
		'validator',
		'ifBlock'
	],
	#category : #'Mediaclue-Validation'
}

{ #category : #accessing }
MEDValidationRule >> errorMessage [
	^ errorMessage
]

{ #category : #accessing }
MEDValidationRule >> errorMessage: anObject [
	errorMessage := anObject
]

{ #category : #'as yet unclassified' }
MEDValidationRule >> if: aBlock [
	ifBlock := aBlock
]

{ #category : #'initialize-release' }
MEDValidationRule >> initialize [
	super initialize.
]

{ #category : #testing }
MEDValidationRule >> isActive [
	^ifBlock isNil or: [(ifBlock value: self object) = true]
]

{ #category : #testing }
MEDValidationRule >> isNotPassing [
	^self isPassing not
]

{ #category : #testing }
MEDValidationRule >> isPassing [
	"Answers true, when
	  - the rule needs to be checked AND is valid
	  - the rule needs not to be checked"
	^self isActive not or: [self isValid]
]

{ #category : #testing }
MEDValidationRule >> isValid [
	"subclassResponsibility!"
	^false
]

{ #category : #accessing }
MEDValidationRule >> object [
	^self validator object
]

{ #category : #'as yet unclassified' }
MEDValidationRule >> renderErrorMessageOn: html [
	html text: errorMessage

]

{ #category : #accessing }
MEDValidationRule >> validator [
	^ validator
]

{ #category : #accessing }
MEDValidationRule >> validator: anObject [
	validator := anObject
]
