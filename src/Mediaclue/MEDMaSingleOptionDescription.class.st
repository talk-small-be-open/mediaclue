Class {
	#name : #MEDMaSingleOptionDescription,
	#superclass : #MASingleOptionDescription,
	#traits : 'TWEBMagritteDescription + TWEBMagritteOptionDescription',
	#classTraits : 'TWEBMagritteDescription classTrait + TWEBMagritteOptionDescription classTrait',
	#category : #'Mediaclue-Magritte'
}

{ #category : #'as yet unclassified' }
MEDMaSingleOptionDescription class >> defaultComponentClasses [
	^ Array with: MEDMaSelectListComponent
]
