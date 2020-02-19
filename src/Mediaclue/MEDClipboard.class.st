Class {
	#name : #MEDClipboard,
	#superclass : #MEDMediaCollection,
	#category : #'Mediaclue-Models'
}

{ #category : #accessing }
MEDClipboard >> clear [
	self removeAll
]

{ #category : #'as yet unclassified' }
MEDClipboard >> createNewMediaSet [
	^ (MEDMediaSet medias: self medias)
		title: 'Unbenannt - von Zwischenablage';
		yourself
]

{ #category : #accessing }
MEDClipboard >> owner [
	^nil
]

{ #category : #accessing }
MEDClipboard >> permissionType [
	^ #dontcheck
]

{ #category : #accessing }
MEDClipboard >> title [
	^ 'Zwischenablage'
]
