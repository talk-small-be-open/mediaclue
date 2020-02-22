Class {
	#name : #WEBMaStringWriter,
	#superclass : #MAStringWriter,
	#category : #'Webbase-Magritte'
}

{ #category : #'visiting-description' }
WEBMaStringWriter >> visitDateDescription: aDescription [
	self stream nextPutAll: self object germanString
]
