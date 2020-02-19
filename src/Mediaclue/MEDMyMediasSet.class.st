Class {
	#name : #MEDMyMediasSet,
	#superclass : #MEDMediaCollection,
	#instVars : [
		'user'
	],
	#category : #'Mediaclue-Models'
}

{ #category : #accessing }
MEDMyMediasSet >> medias [
	self refreshIfNeeded.
	^ super medias
]

{ #category : #'as yet unclassified' }
MEDMyMediasSet >> owner [
	^ user
]

{ #category : #accessing }
MEDMyMediasSet >> refresh [
	medias := self db findMediasByOwner: user
]

{ #category : #accessing }
MEDMyMediasSet >> refreshIfNeeded [
	medias ifBlank: [ self refresh ].
]

{ #category : #accessing }
MEDMyMediasSet >> title [
	^ 'Meine Medien'
]

{ #category : #accessing }
MEDMyMediasSet >> user [
	^ user
]

{ #category : #accessing }
MEDMyMediasSet >> user: anObject [
	user := anObject
]
