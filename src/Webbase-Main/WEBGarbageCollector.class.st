Class {
	#name : #WEBGarbageCollector,
	#superclass : #WEBObject,
	#category : #'Webbase-Main-Database'
}

{ #category : #'as yet unclassified' }
WEBGarbageCollector >> gcAll [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WEBGarbageCollector >> trash: anObject [
	"In Papierkorb"
	self db addToTrash: anObject
]
