Class {
	#name : #MEDValidationResult,
	#superclass : #MEDObject,
	#instVars : [
		'object',
		'validator',
		'failedRules'
	],
	#category : #'Mediaclue-Validation'
}

{ #category : #adding }
MEDValidationResult >> addFailedRule: aValidationRule [
	failedRules add: aValidationRule
]

{ #category : #'as yet unclassified' }
MEDValidationResult >> failedRules [
	^failedRules
]

{ #category : #'initialize-release' }
MEDValidationResult >> initialize [
	super initialize.
	
	failedRules := OrderedCollection new.

]

{ #category : #testing }
MEDValidationResult >> isValid [
	^failedRules isEmpty
]

{ #category : #rendering }
MEDValidationResult >> renderOn: html [
	self isValid ifFalse: [
		html div
			class: 'validationResults';
			with: [
				html div class: 'title'; with: 'Validation'.
"				html div with: 'Dieses Objekt hat Fehler'."
				html unorderedList
					with: [
						self failedRules do: [:eachRule |
							html listItem: [
								eachRule
									renderErrorMessageOn: html].
				]]]]
]

{ #category : #'as yet unclassified' }
MEDValidationResult >> signalIfInvalid [
	self isValid ifFalse: [
		(MEDValidationError validationResult: self) signal]
]

{ #category : #accessing }
MEDValidationResult >> validator [
	^ validator
]

{ #category : #accessing }
MEDValidationResult >> validator: anObject [
	validator := anObject
]
