Class {
	#name : #MEDPreviewBase,
	#superclass : #MEDModelObject,
	#instVars : [
		'fileReference'
	],
	#category : #'Mediaclue-Models'
}

{ #category : #testing }
MEDPreviewBase class >> isVoyageRoot [
	^false
]

{ #category : #'submorphs-add/remove' }
MEDPreviewBase >> delete [
	fileReference deleteFile
]

{ #category : #accessing }
MEDPreviewBase >> fileReference [
	^ fileReference
]

{ #category : #accessing }
MEDPreviewBase >> fileReference: anObject [
	fileReference := anObject
]
