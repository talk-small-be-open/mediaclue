Class {
	#name : #MEDValidateValidity,
	#superclass : #MEDAttributeValidationRule,
	#instVars : [
		'otherValidator',
		'validationResult'
	],
	#category : #'Mediaclue-Validation'
}

{ #category : #'as yet unclassified' }
MEDValidateValidity >> clearValidationResult [
	validationResult := nil
]

{ #category : #'as yet unclassified' }
MEDValidateValidity >> isValid [
	self clearValidationResult.
	^self validationResult isValid
]

{ #category : #accessing }
MEDValidateValidity >> otherValidator [
	^ otherValidator
]

{ #category : #accessing }
MEDValidateValidity >> otherValidator: anObject [
	otherValidator := anObject
]

{ #category : #'as yet unclassified' }
MEDValidateValidity >> validationResult [
	validationResult ifNil: [
		otherValidator object: self attributeValue.
		validationResult := otherValidator validationResult].
		
	^validationResult
]
