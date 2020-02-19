Class {
	#name : #MEDPreviewImage,
	#superclass : #MEDPreviewBase,
	#instVars : [
		'sizeName',
		'sizePx'
	],
	#category : #'Mediaclue-Models'
}

{ #category : #accessing }
MEDPreviewImage >> sizeName [
	^ sizeName
]

{ #category : #accessing }
MEDPreviewImage >> sizeName: anObject [
	sizeName := anObject
]

{ #category : #accessing }
MEDPreviewImage >> sizePx [
	^ sizePx
]

{ #category : #accessing }
MEDPreviewImage >> sizePx: anObject [
	sizePx := anObject
]

{ #category : #accessing }
MEDPreviewImage >> url [
	^ self globalConfiguration previewsUrlBasePath, fileReference urlPath
]
