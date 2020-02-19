Class {
	#name : #MEDSearchResult,
	#superclass : #MEDObject,
	#instVars : [
		'query',
		'medias',
		'mediaSets'
	],
	#category : #'Mediaclue-Misc'
}

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
	^ query hasLimit
		ifFalse: [ mediaSets ]
		ifTrue: [ mediaSets firstAtMost: query limit ]
]

{ #category : #accessing }
MEDSearchResult >> mediaSets: anObject [
	mediaSets := anObject
]

{ #category : #'as yet unclassified' }
MEDSearchResult >> mediaSetsCount [
	mediaSets ifBlank: [ ^0 ].
	^ mediaSets size
]

{ #category : #enumerating }
MEDSearchResult >> mediaSetsDo: aBlock [
	self mediaSets do: aBlock
]

{ #category : #accessing }
MEDSearchResult >> medias [
	^ query hasLimit
		ifFalse: [ medias ]
		ifTrue: [ medias firstAtMost: query limit ]
]

{ #category : #accessing }
MEDSearchResult >> medias: anObject [
	medias := anObject
]

{ #category : #'as yet unclassified' }
MEDSearchResult >> mediasCount [
	medias ifBlank: [ ^0 ].
	^ medias size
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
	^ self selectMedias: aBlock sets: aBlock
]

{ #category : #enumerating }
MEDSearchResult >> selectMediaSets: aBlock [
	^ self selectMedias: nil sets: aBlock
]

{ #category : #enumerating }
MEDSearchResult >> selectMedias: aBlock [
	^ self selectMedias: aBlock sets: nil
]

{ #category : #enumerating }
MEDSearchResult >> selectMedias: aBlockOne sets: aBlockTwo [
	| copy |
	copy := self copy.
	aBlockOne ifNotNil: [
		copy medias: (self medias select: aBlockOne)].
	aBlockTwo ifNotNil: [
		copy mediaSets: (self mediaSets select: aBlockTwo)].

	^ copy
]
