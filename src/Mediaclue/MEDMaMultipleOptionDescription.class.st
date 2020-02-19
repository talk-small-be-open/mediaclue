Class {
	#name : #MEDMaMultipleOptionDescription,
	#superclass : #MAMultipleOptionDescription,
	#traits : 'TWEBMagritteDescription + TWEBMagritteOptionDescription',
	#classTraits : 'TWEBMagritteDescription classTrait + TWEBMagritteOptionDescription classTrait',
	#category : #'Mediaclue-Magritte'
}

{ #category : #'as yet unclassified' }
MEDMaMultipleOptionDescription class >> defaultCssClasses [
	^ #(selectized)
]
