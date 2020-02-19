Class {
	#name : #MEDAttributeValidationRule,
	#superclass : #MEDValidationRule,
	#instVars : [
		'of',
		'allowNil',
		'allowEmpty',
		'attributeName'
	],
	#category : #'Mediaclue-Validation'
}

{ #category : #accessing }
MEDAttributeValidationRule >> allowEmpty [
	^ allowEmpty
]

{ #category : #accessing }
MEDAttributeValidationRule >> allowEmpty: anObject [
	allowEmpty := anObject
]

{ #category : #accessing }
MEDAttributeValidationRule >> allowNil [
	^ allowNil
]

{ #category : #accessing }
MEDAttributeValidationRule >> allowNil: anObject [
	allowNil := anObject
]

{ #category : #validation }
MEDAttributeValidationRule >> attributeName [
	^attributeName ifNil: [of]
]

{ #category : #validation }
MEDAttributeValidationRule >> attributeValue [
	^($: split: of asString)
		inject: validator object into: [:object :method |
			object perform: method asSymbol]
]

{ #category : #'as yet unclassified' }
MEDAttributeValidationRule >> beBlankAllowed [
	self beEmptyAllowed.
	self beNilAllowed.
]

{ #category : #'as yet unclassified' }
MEDAttributeValidationRule >> beEmptyAllowed [
	allowEmpty := true
]

{ #category : #'as yet unclassified' }
MEDAttributeValidationRule >> beNilAllowed [
	allowNil := true
]

{ #category : #'as yet unclassified' }
MEDAttributeValidationRule >> ifBlankAndAllowed: aBlock [
	self ifNilAndAllowed: aBlock.
	self ifEmptyAndAllowed: aBlock.
]

{ #category : #'as yet unclassified' }
MEDAttributeValidationRule >> ifEmptyAndAllowed: aBlock [
	self ifEmptyAndAllowed: aBlock notAllowed: []
]

{ #category : #'as yet unclassified' }
MEDAttributeValidationRule >> ifEmptyAndAllowed: aBlock notAllowed: anElseBlock [
	| value |

	value := self attributeValue.

	"If the value understands the isEmpty message, then we rely on that. Otherwise we can not do anything."
	((value respondsTo: #isEmpty) and: [value isEmpty]) ifTrue: [
		allowEmpty
			ifTrue: aBlock
			ifFalse: anElseBlock]
]

{ #category : #'as yet unclassified' }
MEDAttributeValidationRule >> ifEmptyAndNotAllowed: aBlock [
	self ifEmptyAndAllowed: [] notAllowed: aBlock
]

{ #category : #'as yet unclassified' }
MEDAttributeValidationRule >> ifNilAndAllowed: aBlock [
	self ifNilAndAllowed: aBlock notAllowed: []
]

{ #category : #'as yet unclassified' }
MEDAttributeValidationRule >> ifNilAndAllowed: aBlock notAllowed: anElseBlock [
	self attributeValue isNil ifTrue: [
		allowNil
			ifTrue: aBlock
			ifFalse: anElseBlock]
]

{ #category : #'as yet unclassified' }
MEDAttributeValidationRule >> ifNilAndNotAllowed: aBlock [
	self ifNilAndAllowed: [] notAllowed: aBlock
]

{ #category : #initialization }
MEDAttributeValidationRule >> initialize [
	super initialize.
	allowNil := false.
	allowEmpty := false.
]

{ #category : #'as yet unclassified' }
MEDAttributeValidationRule >> named: aSymbol [
	attributeName := aSymbol
]

{ #category : #accessing }
MEDAttributeValidationRule >> of [
	^ of
]

{ #category : #accessing }
MEDAttributeValidationRule >> of: anObject [
	of := anObject
]

{ #category : #accessing }
MEDAttributeValidationRule >> of: anObject named: aString [
	"Convenience"
	^self
		of: anObject;
		named: aString;
		yourself
]

{ #category : #'as yet unclassified' }
MEDAttributeValidationRule >> renderErrorMessageOn: html [
	"Standard implementation with a basic meaningful error message"
	html text: 'Attribut ungültig: '.
	html text: self attributeName.

]
