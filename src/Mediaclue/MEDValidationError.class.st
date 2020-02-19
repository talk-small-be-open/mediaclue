Class {
	#name : #MEDValidationError,
	#superclass : #MEDError,
	#instVars : [
		'validationResult'
	],
	#category : #'Mediaclue-Misc'
}

{ #category : #'as yet unclassified' }
MEDValidationError class >> validationResult: aVR [
	^self new
		setValidationResult: aVR;
		yourself
]

{ #category : #initialization }
MEDValidationError >> setValidationResult: aVR [
	validationResult := aVR
]
