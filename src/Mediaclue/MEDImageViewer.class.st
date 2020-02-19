Class {
	#name : #MEDImageViewer,
	#superclass : #MEDMediaViewer,
	#category : #'Mediaclue-View'
}

{ #category : #rendering }
MEDImageViewer >> renderPreviewOn: html [
	html pureImage url: (model previewImageUrl: #large)
]

{ #category : #rendering }
MEDImageViewer >> renderSpecialMenuEntriesOn: html [
	html menuEntry: [ self rotateLeft ] with: [ html iconRotateLeft; text: '-90° drehen'].
	html menuEntry: [ self rotateRight ] with: [ html iconRotateRight; text: '+90° drehen'].

]

{ #category : #'as yet unclassified' }
MEDImageViewer >> rotateLeft [
	model rotateLeft.
	self inform: 'Bild wird gedreht. Es kann ein paar Sekunden dauern, bis alle Bildvorschauen neu erstellt wurden.'
]

{ #category : #'as yet unclassified' }
MEDImageViewer >> rotateRight [
	model rotateRight.
	self inform: 'Bild wird gedreht. Es kann ein paar Sekunden dauern, bis alle Bildvorschauen neu erstellt wurden.'
]
