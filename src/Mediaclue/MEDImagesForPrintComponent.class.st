Class {
	#name : #MEDImagesForPrintComponent,
	#superclass : #MEDComponent,
	#instVars : [
		'images',
		'title'
	],
	#category : #'Mediaclue-View'
}

{ #category : #accessing }
MEDImagesForPrintComponent class >> images: aCollection [
	^ self new
		images: aCollection;
		yourself
]

{ #category : #accessing }
MEDImagesForPrintComponent >> images [
	^ images
]

{ #category : #accessing }
MEDImagesForPrintComponent >> images: anObject [
	images := anObject
]

{ #category : #initialization }
MEDImagesForPrintComponent >> initialize [
	super initialize.
	title := ''
]

{ #category : #rendering }
MEDImagesForPrintComponent >> renderContentOn: html [
	html div class: 'imageGalleryForPrint'; with: [
		self renderIndexOn: html.
		self renderOverviewOn: html.
		self renderPagesOn: html ]
]

{ #category : #rendering }
MEDImagesForPrintComponent >> renderIndexOn: html [
	html div class: 'imageIndex'; with: [
		title ifNotBlank: [html h1: title].
		html h2: 'Liste der Bilder'.
		html table class: 'imageIndexTable'; with: [
			html tableHead: [
				html tableHeading: 'Nr.'.
				html tableHeading: 'Name'.
				html tableHeading: 'Dateiname'.
				html tableHeading: 'Beschreibung'.
				html tableHeading: 'Schlagworte'.
			].
			html tableBody: [
				images withIndexDo: [ :each :index |
					html tableRow: [
						html tableData: index asString.
						html tableData: [
							html anchor
								class: 'jumpToImage';
								url: '#image', index asString;
								with: each title].
						html tableData: each originalFilename.
						html tableData: (each description ifNotBlank: [:d | d truncateWithElipsisTo: 100]).
						html tableData: each tagsCommaSeparated.
					].
			]]]]
]

{ #category : #rendering }
MEDImagesForPrintComponent >> renderOverviewOn: html [
	html div class: 'imagesOverview alwaysPageBreak'; with: [
		html h2: 'Vorschau der Bilder'.
		images withIndexDo: [ :each :index |

	"		html preview: #large media: each lazy: false."
			html div class: 'imagePreview'; with: [
				html anchor
					url: '#image', index asString;
					with: [
						html image
							resourceUrl: (each previewImageUrl: #small)]
			]
		]
	]
]

{ #category : #rendering }
MEDImagesForPrintComponent >> renderPagesOn: html [
	images withIndexDo: [ :each :index |
		html div
			class: 'imagePage alwaysPageBreak';
			id: 'image', index asString;
			with: [
				html image
					resourceUrl: (each previewImageUrl: #pdfslideshow)]
	]
]

{ #category : #accessing }
MEDImagesForPrintComponent >> title [
	^ title
]

{ #category : #accessing }
MEDImagesForPrintComponent >> title: anObject [
	title := anObject
]
