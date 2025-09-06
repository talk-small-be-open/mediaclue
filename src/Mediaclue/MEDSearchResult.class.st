Class {
	#name : #MEDSearchResult,
	#superclass : #MEDObject,
	#instVars : [
		'query',
		'medias',
		'mediaSets',
		'mediaSetsCount',
		'mediasCount'
	],
	#category : #'Mediaclue-Misc'
}

{ #category : #testing }
MEDSearchResult >> hasMoreMediaSets [
	^ self mediaSetsCount > mediaSets size
]

{ #category : #testing }
MEDSearchResult >> hasMoreMedias [
	^ self mediasCount > medias size
]

{ #category : #'as yet unclassified' }
MEDSearchResult >> hitsCount [
	^ self mediaSetsCount + self mediasCount
]

{ #category : #testing }
MEDSearchResult >> isEmpty [
	^ medias isBlank and: [ mediaSets isBlank ]
]

{ #category : #accessing }
MEDSearchResult >> mediaSets [
	^ mediaSets
]

{ #category : #accessing }
MEDSearchResult >> mediaSets: anObject [
	mediaSets := anObject
]

{ #category : #'as yet unclassified' }
MEDSearchResult >> mediaSetsCount [
	^ mediaSetsCount ifNil: [ 0 ]
]

{ #category : #accessing }
MEDSearchResult >> mediaSetsCount: anObject [
	mediaSetsCount := anObject
]

{ #category : #enumerating }
MEDSearchResult >> mediaSetsDo: aBlock [
	self mediaSets do: aBlock
]

{ #category : #accessing }
MEDSearchResult >> medias [
	^ medias
]

{ #category : #accessing }
MEDSearchResult >> medias: anObject [
	medias := anObject
]

{ #category : #'as yet unclassified' }
MEDSearchResult >> mediasCount [
	^ mediasCount ifNil: [ 0 ]
]

{ #category : #accessing }
MEDSearchResult >> mediasCount: anObject [
	mediasCount := anObject
]

{ #category : #enumerating }
MEDSearchResult >> mediasDo: aBlock [
	self medias do: aBlock
]

{ #category : #accessing }
MEDSearchResult >> query [
	^ query
]

{ #category : #accessing }
MEDSearchResult >> query: anObject [
	query := anObject
]

{ #category : #enumerating }
MEDSearchResult >> select: aBlock [
	self shouldNotImplement.
	
	^ self selectMedias: aBlock sets: aBlock
]

{ #category : #enumerating }
MEDSearchResult >> selectMedias: aBlockOne sets: aBlockTwo [
	| copy |
	copy := self copy.
	aBlockOne ifNotNil: [
		copy medias: (medias select: aBlockOne)].
	aBlockTwo ifNotNil: [
		copy mediaSets: (mediaSets select: aBlockTwo)].

	^ copy
]
