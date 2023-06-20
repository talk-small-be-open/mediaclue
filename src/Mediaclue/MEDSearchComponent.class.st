Class {
	#name : #MEDSearchComponent,
	#superclass : #MEDComponent,
	#instVars : [
		'searchResult',
		'searchQuery',
		'topTags',
		'myTopTags',
		'subjectTags',
		'mediaRenderer',
		'myMediaSetsOnly',
		'myMediaSets',
		'suggestedTags',
		'clipboardViewer',
		'allTags',
		'minorSelectedTags'
	],
	#category : #'Mediaclue-View'
}

{ #category : #'as yet unclassified' }
MEDSearchComponent class >> executeQuery: aQuery [
	^(self searchQuery: aQuery)
	search;
	yourself
]

{ #category : #'as yet unclassified' }
MEDSearchComponent class >> searchQuery: aQuery [
	^self basicNew
		setSearchQuery: aQuery;
		initialize;
		yourself
]

{ #category : #initializing }
MEDSearchComponent >> addTag: aTag [
	searchQuery addTag: aTag.

]

{ #category : #initializing }
MEDSearchComponent >> addTags: aCollection [
	aCollection do: [ :each | self addTag: each ]
]

{ #category : #'as yet unclassified' }
MEDSearchComponent >> calculateMinorSelectedTags [
	minorSelectedTags := self selectedTags copyWithoutAll: self majorTags
]

{ #category : #initializing }
MEDSearchComponent >> calculateSuggestedTags [
	| bag |
"	searchQuery tags inspect."
	
	bag := searchResult medias flatCollect: [ :each | each tags copyWithoutAll: self selectedTags ] as: Bag.
	
	suggestedTags := (bag sortedCounts collect: [ :each | each value ]) firstAtMost: 3
]

{ #category : #initializing }
MEDSearchComponent >> clickTag: aTag [
	(searchQuery tags includes: aTag)
		ifTrue: [ searchQuery removeTag: aTag ]
		ifFalse: [ searchQuery addTag: aTag ].

	self search
]

{ #category : #actions }
MEDSearchComponent >> clipboardClear [
	self currentPortfolio clipboard clear; save.
]

{ #category : #actions }
MEDSearchComponent >> clipboardSaveAsNew [
	| mediaSet |
	mediaSet := self currentPortfolio clipboard createNewMediaSet.
	mediaSet owner: self currentUser.

	self show: (MEDMediaSetEditor mediaSet: mediaSet) onAnswer: [:answer |
		answer ifNotNil: [
			mediaSet save.
			self session announceDataChange]]
]

{ #category : #rendering }
MEDSearchComponent >> copySelectedToClipboard [
	self currentPortfolio clipboard addAll: self selectedMediaForViewer
]

{ #category : #rendering }
MEDSearchComponent >> downloadArchiveZip [
	self offloadDownloadWork: [
		WEBZipGenerator generateFromMedias: self selectedOrAll named: 'Suchresultat.zip'.
	]
]

{ #category : #rendering }
MEDSearchComponent >> downloadImagesPdf [
	self offloadDownloadWork: [
		self pi defaultPdfGeneratorClass generateImagesForPrint: self selectedOrAll named: 'Suchresultat Bilder'
	]
]

{ #category : #testing }
MEDSearchComponent >> hasSearchResult [
	^ searchResult notNil
]

{ #category : #testing }
MEDSearchComponent >> hasSearchResults [
	^ searchResult notNil and: [ searchResult isEmpty not ]
]

{ #category : #initialization }
MEDSearchComponent >> initialize [
	| me |
	
	super initialize.
	
	self beWithSideMenu.
	
	me := self currentUser.

	mediaRenderer := (MEDMediaRenderer component: self).
	clipboardViewer := MEDClipboardViewer new.
	
	topTags := self session topTags.
	myTopTags := self session myTopTags.

	subjectTags := self session schoolSubjectTags.

	allTags := self db tags sortedBySortKey.
	
	myMediaSets := self currentPortfolio mediaSets.
	
	self initializeSearch
]

{ #category : #initialization }
MEDSearchComponent >> initializeSearch [
	searchQuery ifNil: [
		searchQuery := self currentPortfolio lastSearchQuery.
	].

"	searchQuery ifNil: [
		searchQuery := MEDSearchQuery new ]."

	searchResult := nil.
	suggestedTags := OrderedCollection new.
	minorSelectedTags := OrderedCollection new.
	myMediaSetsOnly := false.
	mediaRenderer clearSelection.
]

{ #category : #testing }
MEDSearchComponent >> isEmptySearchResult [
	^ searchResult notNil and: [ searchResult isEmpty ]
]

{ #category : #testing }
MEDSearchComponent >> isSelectedTag: aTag [
	^ self selectedTags includes: aTag
]

{ #category : #initialization }
MEDSearchComponent >> majorTags [
	^ topTags, myTopTags, subjectTags

]

{ #category : #accessing }
MEDSearchComponent >> myMediaSetsOnly [
	^ myMediaSetsOnly
]

{ #category : #accessing }
MEDSearchComponent >> myMediaSetsOnly: anObject [
	myMediaSetsOnly := anObject
]

{ #category : #initializing }
MEDSearchComponent >> removeTag: aTag [
	searchQuery removeTag: aTag
]

{ #category : #rendering }
MEDSearchComponent >> renderAllTagsOn: html [
	| options |
	
	html div class: 'tagsArea'; with: [
		html span class: 'title'; with: 'Weitere Schlagworte: '.
		html space.
		html span: [
			minorSelectedTags do: [ :each |
				html anchor
					class: 'tag';
					class: 'selected';
					callback: [ self clickTag: each ];
					with: each title
			] separatedBy: [ html span: ', ' ]
		].

		options := {
#plugins -> #('remove_button').
#delimiter->','.
#closeAfterSelect->true.
} asD.

		html multiSelect
			submitOnChange;
			script: (html jQuery this call: 'selectize' with: options);
			list: allTags;
			labels: [ :each | each title ];
			callback: [ :tags | self addTags: tags ]
	
	]	
	

]

{ #category : #rendering }
MEDSearchComponent >> renderContentOn: html [
	self hasSearchResult ifTrue: [ self renderMenuOn: html ].

	html pageHeader: 'Suchen'.
	html pageBody: [ 
		html form: [ 
			self renderSearchBarOn: html.

			html div class: 'searchTags'; with: [
				html div class: 'smartSuggestedTags'; with: [
					self renderTags: suggestedTags title: 'Häufigste Sub-Schlagworte:' on: html ].

				self renderTags: subjectTags title: 'Fach-Schlagworte:' on: html.
			
				self renderTags: topTags title: 'Top-Schlagworte:' on: html.

				self renderTags: myTopTags title: 'Meine Top-Schlagworte:' on: html.
				
				self renderAllTagsOn: html
			].
		
			self renderOptionsOn: html.
		].

	self renderSearchResultsOn: html
	].

]

{ #category : #rendering }
MEDSearchComponent >> renderMenuOn: html [
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
MEDSearchComponent >> renderOptionsOn: html [
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

" Suchanfrage speichern als:"
		].
]

{ #category : #rendering }
MEDSearchComponent >> renderSearchBarOn: html [
	html grid class: 'searchBar'; with: [
		html gridUnitFraction: 1/2 with: [
			html textInput
"				placeholder: 'Suchtext'"
				class: 'searchText';
				on: #text of: searchQuery].
		html gridUnitFraction: 1/2 with: [
			html buttonGroup: [
				html submitButtonPrimary
					class: 'searchButton';
					callback: [ self search ];
					with: [
						html iconSearch.
						html span class: 'pure-hidden-sm'; with: ' Suchen'].
				html anchorButton
					callback: [ self reset ];
					with: [
						html iconReset.
						html span class: 'pure-hidden-sm'; with: 'Zurücksetzen'] ]
		]
	].

	self isEmptySearchResult ifTrue: [ html alertWarning: 'Keine Treffer' ].
	self hasSearchResults ifTrue: [
		html alertSuccess: [
			html text: (searchResult hitsCount asString, ' Treffer').
			html span class: 'pure-visible-sm'; with: ' (siehe unten)'] ].

]

{ #category : #rendering }
MEDSearchComponent >> renderSearchResultsOn: html [
	searchResult ifNotNil: [
		html pageSubheader: 'Resultate'.
		html div class: 'searchResults'; with: [
			searchResult isEmpty
				ifTrue: [ html paragraph: 'Keine Treffer' ]
				ifFalse: [
					html div class: 'mediaSets'; with: [
						searchResult mediaSetsDo: [ :each |
							html div: [
								html iconMediaSet; space.
								html anchor
									callback: [ self showMediaSet: each ];
									with: each displayName]]
					].
					html grid class: 'medias'; with: [
						searchResult mediasDo: [ :each |
							html gridUnit: [
								mediaRenderer renderBigCard: each on: html]
						]
					]
		]]]
]

{ #category : #rendering }
MEDSearchComponent >> renderTags: aCollection title: aString on: html [
	aCollection ifEmpty: [ ^self ].
	
	html div class: 'tagsArea'; with: [
		html span class: 'title'; with: aString.
		html space.
		html span: [
			aCollection do: [ :each |
				html anchor
					class: 'tag';
					class: 'selected' if: (self isSelectedTag: each);
					callback: [ self clickTag: each ];
					with: each title
			] separatedBy: [ html span: ', ' ]
		] ]
]

{ #category : #initialization }
MEDSearchComponent >> reset [
	self initializeSearch.
	searchQuery clearSearch.

]

{ #category : #actions }
MEDSearchComponent >> saveAsNewMediaSet [
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
MEDSearchComponent >> saveAsSearchQuery [
	| title |
	title := self request: 'Name der Suchabfrage?'.
	title ifBlank: [ ^ self ].

	"Etwas dirty, hier title zu setzen"
	searchQuery title: title.
	
	self currentPortfolio addSearchQuery: searchQuery.

	self flashMessage: 'Gespeichert'
]

{ #category : #initializing }
MEDSearchComponent >> search [
	searchResult := self db findMediaForUser: self currentUser query: searchQuery.
	
	myMediaSetsOnly ifTrue: [ 
		searchResult := searchResult
			selectMedias: [ :each | myMediaSets anySatisfy: [ :ms | ms includes: each ] ]
			sets: [ :each | myMediaSets includes: each ]
	].

	self calculateSuggestedTags.
	self calculateMinorSelectedTags.
]

{ #category : #initializing }
MEDSearchComponent >> searchAndAddTag: aTag [
	searchQuery addTag: aTag.
	self search
]

{ #category : #rendering }
MEDSearchComponent >> selectedMedia [
	^ mediaRenderer selectedMedia
]

{ #category : #rendering }
MEDSearchComponent >> selectedOrAll [
	^ self selectedMedia ifEmpty: [ searchResult medias ]
]

{ #category : #testing }
MEDSearchComponent >> selectedTags [
	^ searchQuery tags
]

{ #category : #initialization }
MEDSearchComponent >> setSearchQuery: aQuery [
	searchQuery := aQuery
]

{ #category : #rendering }
MEDSearchComponent >> showLighttable [
	self showWithBack: (MEDLighttableSlideshowComponent medias: self selectedOrAll)
]

{ #category : #rendering }
MEDSearchComponent >> showStandardSlideshow [
	self showWithBack: (MEDStandardSlideshowComponent medias: self selectedOrAll)
]
