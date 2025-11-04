Class {
	#name : #MEDStandardSearchComponent,
	#superclass : #MEDSearchComponentBase,
	#instVars : [
		'mediaRenderer',
		'clipboardViewer'
	],
	#category : #'Mediaclue-View'
}

{ #category : #actions }
MEDStandardSearchComponent >> clipboardSaveAsNew [
	| mediaSet |
	mediaSet := self currentPortfolio clipboard createNewMediaSet.
	mediaSet owner: self currentUser.

	self show: (MEDMediaSetEditor mediaSet: mediaSet) onAnswer: [:answer |
		answer ifNotNil: [
			mediaSet save.
			self session announceDataChange]]
]

{ #category : #rendering }
MEDStandardSearchComponent >> copySelectedToClipboard [
	self currentPortfolio clipboard addAll: self selectedMedia
]

{ #category : #rendering }
MEDStandardSearchComponent >> downloadArchiveZip [
	self offloadDownloadWork: [
		WEBZipGenerator generateFromMedias: self selectedOrAll named: 'Suchresultat.zip'.
	]
]

{ #category : #rendering }
MEDStandardSearchComponent >> downloadImagesPdf [
	self offloadDownloadWork: [
		self pi defaultPdfGeneratorClass generateImagesForPrint: self selectedOrAll named: 'Suchresultat Bilder'
	]
]

{ #category : #initialization }
MEDStandardSearchComponent >> initializeMyself [
	
	super initializeMyself.
	
	self beWithSideMenu.
	
	mediaRenderer := (MEDMediaRenderer component: self).
	clipboardViewer := MEDClipboardViewer new.
]

{ #category : #initialization }
MEDStandardSearchComponent >> initializeSearch [

	super initializeSearch.

	searchQuery ifNil: [
		searchQuery := self currentPortfolio lastSearchQuery.

		"searching is fast but the deserializing with BSON ist very slow, so we
		HAVE to limit hard, so that a normal user will get fast results.
		TODO: Make a pagination"
		searchQuery limit: 50. 
		
		"Just to ensure, double proof"
		searchQuery allowedUser: self currentUser.
	].

"	searchQuery ifNil: [
		searchQuery := MEDSearchQuery new ]."

	searchResult := nil.
	suggestedTags := OrderedCollection new.
	minorSelectedTags := OrderedCollection new.
	mediaRenderer clearSelection.
	
"	self myMediaSetsOnly: false."

]

{ #category : #rendering }
MEDStandardSearchComponent >> renderContentOn: html [
	self hasSearchResult ifTrue: [ self renderMenuOn: html ].

	html pageHeader: 'Suchen'.
	html pageBody: [ 
		html form: [ 
			self renderSearchBarOn: html.

			html div class: 'searchTags'; with: [
				html div class: 'smartSuggestedTags'; with: [
					self renderTags: suggestedTags title: 'Häufigste Sub-Schlagworte:' on: html ].

				self renderTags: subjectTags title: 'Haupt-Schlagworte:' on: html.
			
				self renderTags: topTags title: 'Top-Schlagworte:' on: html.

				self renderTags: myTopTags title: 'Meine Top-Schlagworte:' on: html.
				
				self renderAllTagsOn: html
			].
		
			self renderOptionsOn: html.
			
			self renderButtonBarOn: html.
		].

	self renderSearchResultsOn: html
	].

]

{ #category : #rendering }
MEDStandardSearchComponent >> renderMenuOn: html [
	html sideMenu: [
		html menuHeading with: 'Suchresultat'.

		"Class: pure-menu-selected"
		html menuList: [
			html menuEntry: [ self saveAsSearchQuery ] with: [ html iconSearch; text: 'Als Suchabfrage speichern'].
			self hasSearchResults ifTrue: [
				html menuEntry: [ self saveAsNewMediaSet ] with: [ html iconMediaSet; text: 'Als Kollektion speichern'].
				html menuEntry: [ self downloadArchiveZip ] with: [ html iconDownload; text: 'ZIP Download'].
				html menuEntry: [ self downloadImagesPdf ] with: [ html iconDownload; text: 'Bilder-PDF Download'].
				html menuDivider.
				html menuEntry: [ self showLighttable ] with: [ html iconPreview; text: 'Leuchtpult-Ansicht'].
				html menuEntry: [ self showStandardSlideshow ] with: [ html iconPreview; text: 'Diashow-Ansicht'].
				html menuEntry: [ self copySelectedToClipboard ] with: [ html iconCopy; text: 'In Zwischenablage kopieren']].
			html menuTitle: 'Zwischenablage ...'.
			html div: clipboardViewer.
			clipboardViewer isEmpty ifFalse: [
				html menuEntry: [ self clipboardSaveAsNew ] with: '... als neue Kollektion speichern'.
				html menuEntry: [ self clipboardClear ] with: '... leeren' ].
	]]
]

{ #category : #rendering }
MEDStandardSearchComponent >> renderOptionsOn: html [
"	html pureControlGroup: ["
	html fieldSet class: 'searchOptions'; with: [
		html legend: 'Optionen'.
		html label with: [
			html checkbox on: #includeImage of: searchQuery.
			html text: ' Bilder' ].
		html label with: [
			html checkbox on: #includeAudio of: searchQuery.
			html text: ' Audio' ].
		html label with: [
			html checkbox on: #includeVideo of: searchQuery.
			html text: ' Video' ].
		html label with: [
			html checkbox on: #includeDocument of: searchQuery.
			html text: ' Dokumente' ].
		html label with: [
			html checkbox on: #myMediaSetsOnly of: self.
			html text: ' Nur in eigenen Kollektionen suchen'].
	
		html span: 'Limite: '.
		html select
			list: #(10 25 50 100 500);
			optionalLabel: 'Alle';
			beOptional;
			on: #limit of: searchQuery
	]
]

{ #category : #rendering }
MEDStandardSearchComponent >> renderSearchResultsOn: html [
	searchResult ifNotNil: [
		html pageSubheader: 'Resultate'.
		html div class: 'searchResults'; with: [
			searchResult isEmpty
				ifTrue: [ html paragraph: 'Keine Treffer' ]
				ifFalse: [
					html div class: 'mediaSets'; with: [
						searchResult mediaSets do: [ :each |
							html div: [
								html iconMediaSet; space.
								html anchor
									callback: [ self showMediaSet: each ];
									with: each displayName ] ].
						searchResult hasMoreMediaSets ifTrue: [ html div: '... und weitere Kollektionen' ].
					].
					html grid class: 'medias'; with: [
						searchResult medias do: [ :each |
							html gridUnit: [
								mediaRenderer renderBigCard: each on: html]
						].
					].
					searchResult hasMoreMedias ifTrue: [ html div: '... und weitere Medien' ].
		]]]
]

{ #category : #actions }
MEDStandardSearchComponent >> saveAsNewMediaSet [
	| mediaSet |
	mediaSet := (MEDMediaSet medias: self selectedOrAll)
		owner: self currentUser;
		title: 'Unbenannt';
		yourself.

	self show: (MEDMediaSetEditor mediaSet: mediaSet) onAnswer: [:answer |
		answer ifNotNil: [
			mediaSet save ]]
]

{ #category : #actions }
MEDStandardSearchComponent >> saveAsSearchQuery [
	| title |
	title := self request: 'Name der Suchabfrage?'.
	title ifBlank: [ ^ self ].

	"Etwas dirty, hier title zu setzen"
	searchQuery title: title.
	
	self currentPortfolio addSearchQuery: searchQuery.

	self flashMessage: 'Gespeichert'
]

{ #category : #rendering }
MEDStandardSearchComponent >> selectedMedia [
	^ mediaRenderer selectedMedia
]

{ #category : #rendering }
MEDStandardSearchComponent >> selectedOrAll [
	^ self selectedMedia ifEmpty: [ searchResult medias ]
]

{ #category : #rendering }
MEDStandardSearchComponent >> showLighttable [
	self showWithBack: (MEDLighttableSlideshowComponent medias: self selectedOrAll)
]

{ #category : #rendering }
MEDStandardSearchComponent >> showStandardSlideshow [
	self showWithBack: (MEDStandardSlideshowComponent medias: self selectedOrAll)
]
