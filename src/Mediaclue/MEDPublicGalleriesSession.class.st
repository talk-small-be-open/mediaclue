Class {
	#name : #MEDPublicGalleriesSession,
	#superclass : #WEBFrontendSession,
	#instVars : [
		'requestedGalleryUuid'
	],
	#category : #'Mediaclue-View'
}

{ #category : #accessing }
MEDPublicGalleriesSession >> requestedGalleryUuid [
	^ requestedGalleryUuid
]

{ #category : #accessing }
MEDPublicGalleriesSession >> requestedGalleryUuid: anObject [
	requestedGalleryUuid := anObject
]
