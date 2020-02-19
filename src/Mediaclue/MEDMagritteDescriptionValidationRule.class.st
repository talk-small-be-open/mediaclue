Class {
	#name : #MEDMagritteDescriptionValidationRule,
	#superclass : #MEDValidationRule,
	#instVars : [
		'description'
	],
	#category : #'Mediaclue-Validation'
}

{ #category : #accessing }
MEDMagritteDescriptionValidationRule >> errorMessage [
	^'Objekt enthält Fehler. Bitte Formular laden und erneut speichern. Details: ', errorMessage
]

{ #category : #testing }
MEDMagritteDescriptionValidationRule >> isValid [
	| memento |
	memento := self object mementoClass
			model: self object.

	[memento validate] on: MAValidationError do: [:error | self errorMessage: error printString. ^false ].
	
	^true
]
