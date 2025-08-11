Class {
	#name : #MEDGalleriesComponent,
	#superclass : #MEDGalleriesComponentBase,
	#category : #'Mediaclue-View'
}

{ #category : #initialization }
MEDGalleriesComponent >> initialize [
	super initialize.

	title := 'Bildergalerien'.

	mediaSets ifNil: [ mediaSets := self db findGalleries sortedReversedBy: [ :each |
		each createdAt ifNil: [ Date today ] ]
	].

]
