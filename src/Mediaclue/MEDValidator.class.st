Class {
	#name : #MEDValidator,
	#superclass : #MEDObject,
	#instVars : [
		'object',
		'currentRulesContainer',
		'ruleGroups'
	],
	#category : #'Mediaclue-Validation'
}

{ #category : #'instance creation' }
MEDValidator class >> default [
	^self new
		default;
		yourself
]

{ #category : #'instance creation' }
MEDValidator class >> object: anObject [
	^self new
		object: anObject;
		default;
		yourself
]

{ #category : #'as yet unclassified' }
MEDValidator >> addRule: aValidationRule [
	^currentRulesContainer add: aValidationRule
]

{ #category : #'rules creation' }
MEDValidator >> default [
	self subclassResponsibility
]

{ #category : #'initialize-release' }
MEDValidator >> initializeDefaultValues [
	super initializeDefaultValues.
	
	ruleGroups ifNil: [ruleGroups := OrderedCollection new].
	currentRulesContainer := ruleGroups
	
]

{ #category : #testing }
MEDValidator >> isEmpty [
	^ruleGroups isEmpty
]

{ #category : #accessing }
MEDValidator >> object [
	^ object
]

{ #category : #accessing }
MEDValidator >> object: anObject [
	object := anObject
]

{ #category : #'as yet unclassified' }
MEDValidator >> signalIfInvalid [
	self validationResult signalIfInvalid
]

{ #category : #'rules creation' }
MEDValidator >> validateAbsence [
	^self addRule: (MEDValidateAbsence new
		validator: self;
		yourself)
]

{ #category : #'rules creation' }
MEDValidator >> validateEmailFormat [
	^self addRule: (MEDValidateFormat new
		validator: self;
		withRegexp: self db emailRegexp;
		yourself)
]

{ #category : #'rules creation' }
MEDValidator >> validateEquality [
	^self addRule: (MEDValidateEquality new
		validator: self;
		yourself)
]

{ #category : #'rules creation' }
MEDValidator >> validateFormat [
	^self addRule: (MEDValidateFormat new
		validator: self;
		yourself)
]

{ #category : #'rules creation' }
MEDValidator >> validateLength [
	^self addRule: (MEDValidateLength new
		validator: self;
		yourself)
]

{ #category : #'as yet unclassified' }
MEDValidator >> validateMagritte [
	^self addRule: (MEDMagritteDescriptionValidationRule new
		validator: self;
		yourself)
]

{ #category : #'rules creation' }
MEDValidator >> validatePresence [
	^self addRule: (MEDValidatePresence new
		validator: self;
		yourself)
]

{ #category : #'rules creation' }
MEDValidator >> validateRange [
	^self addRule: (MEDValidateRange new
		validator: self;
		yourself)
]

{ #category : #'rules creation' }
MEDValidator >> validateTrue: aBlock [
	^self addRule: (MEDValidateTrue new
		block: aBlock;
		validator: self;
		yourself)
]

{ #category : #'rules creation' }
MEDValidator >> validateUrlFormat [
	^self addRule: (MEDValidateFormat new
		validator: self;
		withRegexp: self db urlRegexp;
		yourself)
]

{ #category : #'rules creation' }
MEDValidator >> validateValidityWith: anotherValidator [
	^self addRule: (MEDValidateValidity new
		validator: self;
		otherValidator: anotherValidator;
		yourself)
]

{ #category : #'as yet unclassified' }
MEDValidator >> validationGroup: aBlock [
	"Install a new collection for a rules group and use that while executing the rules in the block"
	currentRulesContainer := OrderedCollection new.
	ruleGroups add: currentRulesContainer.
	aBlock value.
	currentRulesContainer := ruleGroups
]

{ #category : #validation }
MEDValidator >> validationResult [
	| result |
	result := MEDValidationResult new.
	result validator: self.

	ruleGroups do: [:each |
		| failedRule |
		each isCollection
			ifTrue: [failedRule := each detect: [:r | r isNotPassing] ifNone: nil]
			ifFalse: [each isNotPassing ifTrue: [failedRule := each]].

		failedRule ifNotNil: [result addFailedRule: failedRule]].
	
	^result
]
