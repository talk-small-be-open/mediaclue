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

{ #category : #query }
MEDSearchResult >> allObjects [
	^ mediaSets, medias
]

{ #category : #'as yet unclassified' }
MEDSearchResult >> hasMediaSets [
	^ self mediaSetsCount > 0
]

{ #category : #'as yet unclassified' }
MEDSearchResult >> hasMedias [
	^ self mediasCount > 0
]

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

{ #category : #initialization }
MEDSearchResult >> initialize [
	super initialize.

	"Robustness"
	medias := #().
	mediaSets := #().
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

{ #category : #deprecated }
MEDSearchResult >> select: aBlock [
	self shouldNotImplement.
	
"	^ self selectMedias: aBlock sets: aBlock"
]
