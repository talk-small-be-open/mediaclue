Class {
	#name : #WEBSharedQueue,
	#superclass : #SharedQueue,
	#category : #'Webbase-Main-Misc'
}

{ #category : #'as yet unclassified' }
WEBSharedQueue >> items [
	^items copy
]

{ #category : #'as yet unclassified' }
WEBSharedQueue >> remove: anObject [
	"Remove from the queue anObject"
	monitor critical: [
		items remove: anObject ifAbsent: []]
]
