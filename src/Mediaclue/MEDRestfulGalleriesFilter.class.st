Class {
	#name : #MEDRestfulGalleriesFilter,
	#superclass : #WARestfulFilter,
	#traits : 'TWEBGlobalHelpers',
	#classTraits : 'TWEBGlobalHelpers classTrait',
	#category : #'Mediaclue-View'
}

{ #category : #'as yet unclassified' }
MEDRestfulGalleriesFilter >> getGalleryHtml: aGalleryCode [
	<get>
	<path: '/{aGalleryCode}.html'>
	<produces: 'text/html'>
	
"	| gallery component |
	gallery := self db findPublicMediaSetByUuid: aGalleryCode."
"	gallery := self db findPublicMediaSets anyOne."

	self requestContext properties at: #requestedGalleryUuid put: aGalleryCode.
	self gotoApp.
	
"	component := (MEDStandardSlideshowComponent imagesFromMediaSet: gallery)
		addDecoration: self pi defaultMainDecorationClass new;
		yourself."

"	self startSessionWithRoot: component"

"	gallery
		ifNil: [self session requestedGalleryUuid: aGalleryCode]
		ifNotNil: [ self session requestedGalleryUuid: aGalleryCode ]"
]

{ #category : #'as yet unclassified' }
MEDRestfulGalleriesFilter >> gotoApp [
	"Weiterleiten an die Applikation. Wir tun so, als ob dies kein Rest-Befehl war"
	"OPTIMIZE: Das ist etwas dirty"
	^ self noRouteFound: self requestContext
]
