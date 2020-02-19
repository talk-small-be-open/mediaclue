Class {
	#name : #MEDSlideshowComponentBase,
	#superclass : #MEDComponent,
	#instVars : [
		'medias',
		'title',
		'mediaRenderer'
	],
	#category : #'Mediaclue-View'
}

{ #category : #accessing }
MEDSlideshowComponentBase class >> imagesFromMediaSet: aMediaSet viewer: aUser [
	^ self medias: (aMediaSet imagesForUserAsViewer: aUser)
]

{ #category : #accessing }
MEDSlideshowComponentBase class >> mediaSet: aMediaSet [
	^ self medias: aMediaSet medias
]

{ #category : #accessing }
MEDSlideshowComponentBase class >> medias: aCollection [
	^self basicNew
		setMedias: aCollection asMediaCollection;
		initialize;
		yourself
]

{ #category : #'as yet unclassified' }
MEDSlideshowComponentBase >> filterToViewPermissions [
	medias := medias mediasForUserAsViewer: self currentUser
]

{ #category : #initialization }
MEDSlideshowComponentBase >> initialize [
	super initialize.
	
	self filterToViewPermissions.
	
	mediaRenderer := MEDMediaRenderer component: self.
	mediaRenderer
		beNoSelect;
		beNoClick
]

{ #category : #enumerating }
MEDSlideshowComponentBase >> mediasDo: aBlock [
	medias do: aBlock
]

{ #category : #initialization }
MEDSlideshowComponentBase >> setMedias: aCollection [
	medias := aCollection
]
