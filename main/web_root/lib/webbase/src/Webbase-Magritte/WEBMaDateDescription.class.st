Class {
	#name : #WEBMaDateDescription,
	#superclass : #MADateDescription,
	#traits : 'TWEBMagritteDescription',
	#classTraits : 'TWEBMagritteDescription classTrait',
	#category : #'Webbase-Magritte'
}

{ #category : #'as yet unclassified' }
WEBMaDateDescription class >> defaultComponentClasses [
	^ Array with: WEBMaDateComponent
]

{ #category : #'accessing-defaults' }
WEBMaDateDescription class >> defaultDisplayProperty [
	^ [ :aDateOrNil | 
				aDateOrNil
					ifNotNil: [ aDateOrNil germanString ]
					ifNil: [ '' ] ]
]
