Class {
	#name : #WEBFileReference,
	#superclass : #WEBObject,
	#instVars : [
		'title',
		'comment',
		'contentType',
		'byteSize'
	],
	#category : #'Webbase-Main-Misc'
}

{ #category : #accessing }
WEBFileReference >> byteSize [
	(byteSize isNil or: [byteSize = 0]) ifTrue: [self readFileSize].
	^ byteSize
]

{ #category : #accessing }
WEBFileReference >> byteSize: anObject [
	byteSize := anObject
]

{ #category : #accessing }
WEBFileReference >> comment [
	^ comment
]

{ #category : #accessing }
WEBFileReference >> comment: anObject [
	comment := anObject
]

{ #category : #accessing }
WEBFileReference >> contentType [
	contentType ifNil: [self readContentType].
	^contentType
]

{ #category : #accessing }
WEBFileReference >> contentType: anObject [
	contentType := anObject
]

{ #category : #'as yet unclassified' }
WEBFileReference >> displayName [
	^title
]

{ #category : #'as yet unclassified' }
WEBFileReference >> initialize [
	super initialize.
	byteSize := 0
]

{ #category : #'as yet unclassified' }
WEBFileReference >> readContentType [
	"subclasses"
]

{ #category : #'as yet unclassified' }
WEBFileReference >> readFileSize [
	"subclasses"
]

{ #category : #accessing }
WEBFileReference >> setContentType: anObject [
	contentType := anObject
]

{ #category : #accessing }
WEBFileReference >> title [
	^title
]

{ #category : #accessing }
WEBFileReference >> title: anObject [
	title := anObject
]

{ #category : #'as yet unclassified' }
WEBFileReference >> url [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WEBFileReference >> urlDirectory [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WEBFileReference >> urlPath [
	self subclassResponsibility
]
