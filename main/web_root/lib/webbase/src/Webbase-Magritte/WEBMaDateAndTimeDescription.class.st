Class {
	#name : #WEBMaDateAndTimeDescription,
	#superclass : #MADateAndTimeDescription,
	#traits : 'TWEBMagritteDescription',
	#classTraits : 'TWEBMagritteDescription classTrait',
	#category : #'Webbase-Magritte'
}

{ #category : #'as yet unclassified' }
WEBMaDateAndTimeDescription class >> defaultComponentClasses [
	^ Array with: WEBMaDateAndTimeComponent
]

{ #category : #'accessing-defaults' }
WEBMaDateAndTimeDescription class >> defaultDisplayProperty [
	^ [ :aDateOrNil | 
				aDateOrNil
					ifNotNil: [ aDateOrNil germanString ]
					ifNil: [ '' ] ]
]
