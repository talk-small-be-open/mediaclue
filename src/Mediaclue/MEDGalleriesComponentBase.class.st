Class {
	#name : #MEDGalleriesComponentBase,
	#superclass : #MEDComponent,
	#instVars : [
		'mediaSets',
		'slideshowComponent',
		'selectedMediaSet',
		'title'
	],
	#category : #'Mediaclue-View'
}

{ #category : #accessing }
MEDGalleriesComponentBase class >> mediaSets: aCollection [
	^ self basicNew
		setMediaSets: aCollection;
		initialize;
		yourself
]

{ #category : #hooks }
MEDGalleriesComponentBase >> children [ 
	^ Array with: slideshowComponent
]

{ #category : #initialization }
MEDGalleriesComponentBase >> initialize [
	super initialize.
	title := 'Öffentliche Bildergalerien'.
	mediaSets ifNil: [ mediaSets := self db findPublicMediaSets ]
]

{ #category : #testing }
MEDGalleriesComponentBase >> isShowing [
	^selectedMediaSet notNil
]

{ #category : #rendering }
MEDGalleriesComponentBase >> renderContentOn: html [
	title ifNotBlank: [
		html pageHeader: [
			html grid: [ 
				html gridUnitSmall: 1/1 medium: 1/2 large: 2/3 with: [
					html text: title ].
				html gridUnitSmall: 0 medium: 1/2 large: 1/3 with: [
					html imageLogo
						class: 'float-right' ]].
		] ].
	html pageBody: [
		self isShowing
			ifTrue: [
				html backButtonAnchor
					callback: [ self showList ];
					with: [
						html iconBack.
						html text: 'Liste'].
				html h3: [
					html text: selectedMediaSet title.
				].
				selectedMediaSet publicUrl ifNotBlank: [ :url |
					html paragraph: [
						html small: [
							html text: 'Öffentlicher Link zu dieser Galerie:'; break.
							html span
								selectOnClick;
								with: url
							]]
				]
			]
			ifFalse: [
				self renderGalleriesOn: html].
		self renderToolbarOn: html.
		self renderGalleryOn: html.
	]
]

{ #category : #rendering }
MEDGalleriesComponentBase >> renderGalleriesOn: html [
	html table class: 'galleries'; with: [
		html tableHead: [
			html tableRow: [ 
				html tableHeading: 'Name'.
				html tableHeading: 'Grösse'.
				html tableHeading: 'Info'.
				html tableHeading: 'Datum'.
			]
		].
		html tableBody: [
			mediaSets do: [ :each |
				html tableRow
					class: 'highlight' if: (selectedMediaSet = each);
					with: [ 
						html tableData: [
							html anchor
								callback: [ self selectMediaSet: each ];
								extraPath: (each uuidString, '.html');
								with: each displayName ].
						html tableData class: 'noWrap'; with: [
							html text: each imagesCount asString.
							html text: ' Bilder'.
						].
						html tableData: each description.
						html tableData class: 'noWrap'; with: each createdAt asDate germanString.
					]]]]
]

{ #category : #rendering }
MEDGalleriesComponentBase >> renderGalleryOn: html [
	self isShowing ifTrue: [
		html div class: 'galleryContainer'; with: slideshowComponent
	]
]

{ #category : #rendering }
MEDGalleriesComponentBase >> renderToolbarOn: html [
	html buttonToolbar: [ 
		html buttonGroup: [
			self isShowing
				ifFalse: [
				]
				ifTrue: [
					html anchorButton
						class: 'pure-button-active' if: (slideshowComponent isKindOf: MEDLighttableSlideshowComponent);
						callback: [ self showAsLighttable ];
						with: 'Bilderübersicht'.
					html anchorButton
						class: 'pure-button-active' if: (slideshowComponent isKindOf: MEDStandardSlideshowComponent);
						callback: [ self showAsSlideshow ];
						with: 'Diashow'.
				]]]
]

{ #category : #'as yet unclassified' }
MEDGalleriesComponentBase >> selectMediaSet: aMediaSet [
	selectedMediaSet := aMediaSet.
	self showAsLighttable
]

{ #category : #initialization }
MEDGalleriesComponentBase >> setMediaSets: aCollection [
	mediaSets := aCollection
]

{ #category : #actions }
MEDGalleriesComponentBase >> showAsLighttable [
	slideshowComponent := (MEDLighttableSlideshowComponent imagesFromMediaSet: selectedMediaSet viewer: self currentUser)
		beShowTools;
		yourself
]

{ #category : #actions }
MEDGalleriesComponentBase >> showAsSlideshow [
	slideshowComponent := (MEDStandardSlideshowComponent imagesFromMediaSet: selectedMediaSet viewer: self currentUser)
]

{ #category : #actions }
MEDGalleriesComponentBase >> showList [
	selectedMediaSet := nil.
	slideshowComponent := nil
]

{ #category : #accessing }
MEDGalleriesComponentBase >> title: anObject [
	title := anObject
]
