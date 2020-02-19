Class {
	#name : #MEDMaContainer,
	#superclass : #MAContainer,
	#category : #'Mediaclue-Magritte'
}

{ #category : #'as yet unclassified' }
MEDMaContainer class >> defaultComponentClasses [
	^ Array with: MEDMaContainerComponent
]

{ #category : #accessing }
MEDMaContainer >> atAccessor: anAccessorLike [
	| realAccessor |
	realAccessor := anAccessorLike asAccessor.
	^ self detect: [ :each | each accessor = realAccessor ] ifNone: [ nil ]
]
