Class {
	#name : #MEDValidateTrue,
	#superclass : #MEDValidationRule,
	#instVars : [
		'block'
	],
	#category : #'Mediaclue-Validation'
}

{ #category : #accessing }
MEDValidateTrue >> block [
	^ block
]

{ #category : #accessing }
MEDValidateTrue >> block: anObject [
	block := anObject
]

{ #category : #testing }
MEDValidateTrue >> isValid [
	^block value = true
]
