Class {
	#name : #MEDMediaViewer,
	#superclass : #MEDMediaComponentBase,
	#category : #'Mediaclue-View'
}

{ #category : #private }
MEDMediaViewer class >> classForMedia: aMedia [
	^aMedia viewerClass
]

{ #category : #actions }
MEDMediaViewer >> createPreviews [
	model createPreviewsOffloaded
]

{ #category : #actions }
MEDMediaViewer >> delete [
	(self confirm: 'Dieses Medium löschen? Es wird ebenfalls in allen enthaltenen Kollektionen entfernt.' title: 'Löschen?'  buttonText: 'Ja, jetzt löschen' cancelText: 'Abbrechen') ifTrue: [ 
		model delete.
		self close.
	 ]
]

{ #category : #actions }
MEDMediaViewer >> downloadOriginal [
	self offerDownloadFile: model fileReference
]

{ #category : #actions }
MEDMediaViewer >> edit [
	self show: (MEDMediaEditor for: model) onAnswer: [ self refresh ]
]

{ #category : #actions }
MEDMediaViewer >> forgetMetaData [
	model clearMetaData.
	model save.
]

{ #category : #initialization }
MEDMediaViewer >> initialize [ 
	super initialize.
	self beWithSideMenu
]

{ #category : #rendering }
MEDMediaViewer >> renderMediaSetsOn: html [
	model includingMediaSets do: [ :each |
		html anchor
			callback: [self showMediaSet: each];
			with: each displayName]
		separatedBy: [ html break ]
]

{ #category : #rendering }
MEDMediaViewer >> renderMenuOn: html [
	html sideMenu: [
		html menuHeading with: model classDisplayName.

		"Class: pure-menu-selected"
		html menuList: [
			self ifCanEdit: [
				html menuEntry: [ self edit ] with: [ html iconEdit; text: 'Bearbeiten'].
				html menuEntry: [ self createPreviews ] with: [html iconPreview; text: 'Vorschau neu generieren'].
				html menuEntry: [ self delete ] with: [ html iconDelete; text: 'Löschen' ]]
			else: [
				html menuEntry: [ self reportMisuse ] with: [html iconDelete; text: 'Löschung beantragen'].
			].
			html menuEntry: [ self downloadOriginal ] with: [ html iconDownload; text: 'Herunterladen'].
			self ifCanEdit: [
				html menuEntry: [ self rereadMetaData ] with: 'Meta-Daten erneut einlesen'.
				html menuEntry: [ self forgetMetaData ] with: 'Meta-Daten verwerfen'].
"			html menuDivider.
			html menuEntry: [ self edit ] with: 'etc'."
			
		self renderSpecialMenuEntriesOn: html
	]]
]

{ #category : #rendering }
MEDMediaViewer >> renderMetaDataOn: html [
	model hasMetaData ifTrue: [
		html pageSubheader: 'Meta-Daten'. 
		html table class: 'metaData'; with: [ 
			model metaData keys sorted do: [ :key |
				html tableRow: [ 
					html tableData class: 'key'; with: [ html label: key ].
					html tableData class: 'value'; with: [ html text: (model metaDataAt: key) ].
				] ] ] ]
]

{ #category : #rendering }
MEDMediaViewer >> renderModelOn: html [
	self renderMenuOn: html.
	html pageHeader: model title.
	html pageBody: [
		self renderPreviewOn: html.

		html pageSubheader: 'Beschreibung'.
"		html paragraph: [ html textOrNa: model description ]."
		html paragraph: model description.

		self renderPropertiesOn: html.
		self renderMetaDataOn: html.
	]
]

{ #category : #rendering }
MEDMediaViewer >> renderPreviewOn: html [
	self subclassResponsibility
]

{ #category : #rendering }
MEDMediaViewer >> renderPropertiesOn: html [
	html table class: 'properties'; with: [
		html maRow: #tagsCommaSeparated.
		html maRow: #owner.
		html maRow: #source.
		html maRow: #permissionType.
		(html maIs: #permissionType equal: #groups) ifTrue: [
			html maRow: #readPermittedAuthorities].
"		html maRowIfNotBlank: #readPermittedAuthorities."
		html maRowIfNotBlank: #writePermittedAuthorities.

		html maRow: #originalFilename.
	"Abmessung, Format, Grösse"
	"	html maGrid: #comment."
		html maRow: #originDate.
		html maRow: #uploadedDate.
"		html maRow: #description."
	"	html maGrid: #metaData."
		self ifDevelopment: [ 
			html maRow: #uuidString ].

		model hasGeoInformation ifTrue: [
			html tableRow: [
				html tableHeading: [ html label: 'Geo-Informationen' ].
				html tableData: [
					html strong: 'Länge: '. html textOrNa: model longitude.
					html strong: ' Breite: '. html textOrNa: model latitude.
					html strong: ' Höhe: '. html textOrNa: model altitude.
					html break.
					html anchor
						target: '_blank';
						url: model urlToGoogleMaps;
						with: 'Google Maps ...'.
					html break.
					html anchor
						target: '_blank';
						url: model urlToWikimapia;
						with: 'Wikimapia ...'.
					html break.
					html anchor
						target: '_blank';
						url: model urlToOpenstreetmap;
						with: 'OpenStreetMap ...'.
				]
			]
		].

		html tableRow: [ 
			html tableHeading: [ html label: 'Enthalten in Kollektionen:' ].
			html tableData: [ self renderMediaSetsOn: html ].
		].

	]

]

{ #category : #rendering }
MEDMediaViewer >> renderSpecialMenuEntriesOn: html [
	"nothing"
]

{ #category : #actions }
MEDMediaViewer >> reportMisuse [
	self show: (MEDReportMisuseComponent media: model)
]

{ #category : #actions }
MEDMediaViewer >> rereadMetaData [
	model rereadMetaData.
	model save.
]
