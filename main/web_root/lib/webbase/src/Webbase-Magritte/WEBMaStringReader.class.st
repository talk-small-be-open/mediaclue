Class {
	#name : #WEBMaStringReader,
	#superclass : #MAStringReader,
	#category : #'Webbase-Magritte'
}

{ #category : #'visiting-description' }
WEBMaStringReader >> visitDateAndTimeDescription: aDescription [
	self object: ([ WEBHelper parseGermanDateAndTime: self contents ]
		on: Error do: [ :err | MAReadError signal: err messageText ])
]

{ #category : #'visiting-description' }
WEBMaStringReader >> visitDateDescription: aDescription [
	self object: ([ WEBHelper parseGermanDate: self contents ]
		on: Error do: [ :err | MAReadError signal: err messageText ])
]
