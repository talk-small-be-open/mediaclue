Class {
	#name : #MEDPreviewPdf,
	#superclass : #MEDPreviewBase,
	#category : #'Mediaclue-Models'
}

{ #category : #accessing }
MEDPreviewPdf >> url [
	^ self globalConfiguration previewsUrlBasePath, fileReference urlPath
]
