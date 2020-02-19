Class {
	#name : #MEDMyOverviewComponent,
	#superclass : #MEDComponent,
	#instVars : [
		'mediaSetsGroupedByTag',
		'mediaSetsToplevel',
		'mediaSetsOrderManual',
		'mediaSetsSystem',
		'empty'
	],
	#category : #'Mediaclue-View'
}

{ #category : #actions }
MEDMyOverviewComponent >> deleteSearchQuery: aQuery [
	self confirmYesNo: 'Suchabfrage löschen?' ifYes: [
		self currentPortfolio
			removeSearchQuery: aQuery;
			save.

		self flashMessage: 'Gelöscht'
	]
]

{ #category : #actions }
MEDMyOverviewComponent >> downloadArchiveZip: aMediaSet [
	| user |
	user := self currentUser.
	self offloadDownloadWork: [
		WEBZipGenerator generateFromMedias: (aMediaSet mediasForUserAsViewer: user) named: 'Medien.zip'.
	]
]

{ #category : #actions }
MEDMyOverviewComponent >> downloadImagesPdf: aMediaSet [
	| user |
	user := self currentUser.
	self offloadDownloadWork: [
		self pi defaultPdfGeneratorClass
			generateImagesForPrint: (aMediaSet imagesForUserAsViewer: user)
			title: aMediaSet title
			fileNamed: ('Bilder ', (MEDHelper filenameFor: aMediaSet title), '.pdf')
	]
]

{ #category : #actions }
MEDMyOverviewComponent >> executeSearchQuery: aQuery [
	self showWithBack: (MEDSearchComponent executeQuery: aQuery copy)
]

{ #category : #initialization }
MEDMyOverviewComponent >> initialize [
	super initialize.
	self refresh
]

{ #category : #accessing }
MEDMyOverviewComponent >> refresh [
	| my cp |
	cp := self currentPortfolio.
	my := self session myMediaSets.
	empty := my isEmpty.
	
	mediaSetsToplevel := (my reject: [ :each | each hasSortPath ]) sortedBySortKey.
	mediaSetsOrderManual := (my copyWithoutAll: mediaSetsToplevel) groupedBy: [ :each |
		each sortPath ] sortedBy: [ :each | each ].
	
	mediaSetsSystem := { cp allMyMedias. cp clipboard. cp uploading }.
	
	mediaSetsGroupedByTag := my groupedByMany: [ :each | each tags ]
		sortedBy: [ :each | each displayName ]
		subSortedBy: [ :each | each displayName ]
]

{ #category : #rendering }
MEDMyOverviewComponent >> renderContentOn: html [
	html pageHeader: [
		html grid: [ 
			html gridUnitSmall: 1/1 medium: 1/2 large: 2/3 with: [
				html text: 'Meine Übersicht' ].
			html gridUnitSmall: 0 medium: 1/2 large: 1/3 with: [
				html imageLogo
					class: 'float-right' ] ] ].

	html pageBody: [
		html grid: [
			html gridUnitSmall: 1 medium: 1 large: 1/2 with: [
				html pageSubheader: 'Meine Kollektionen'.
				empty ifTrue: [ html paragraph: 'Sie haben keine eigenen Kollektionen' ].
				mediaSetsOrderManual ifNotEmpty: [
					html small class: 'annotation'; with: 'Oberste Kollektionen:'.
				].
				self renderMediaSets: mediaSetsToplevel on: html.
				mediaSetsOrderManual ifNotEmpty: [ 
					html small class: 'annotation'; with: 'Weitere Kollektionen mit persönlicher Einsortierung:'.
					mediaSetsOrderManual keysAndValuesDo: [ :sortPath :mediaSets |
						self renderMediaSets: mediaSets inGroup: sortPath on: html
					]
				].

				mediaSetsGroupedByTag ifNotEmpty: [
					html pageSubheader: 'Nach Schlagworten'.
	"				html small: 'Automatisch gruppiert nach Schlagworten'."
					mediaSetsGroupedByTag keysAndValuesDo: [ :tag :mediaSets |
						self renderMediaSets: mediaSets inGroup: tag displayName on: html
					] ]
			].
			html gridUnitSmall: 1 medium: 1 large: 1/2 with: [
				
				html pageSubheader: 'Depot'.
				self renderMediaSets: mediaSetsSystem on: html.

"				html pageSubheader: 'Noch unvollständig definierte Kollektionen'.
				html paragraph: '(Diesen fehlen noch notwendige Informationen wie Copyright, Schlagworte etc. Bitte ergänzen!)'."
				self renderSearchQueriesOn: html.
	]]]
]

{ #category : #rendering }
MEDMyOverviewComponent >> renderMediaSets: aCollection inGroup: aString on: html [
	html div
		class: 'mediaSetsGroup';
		with: [ 
			html div
				class: 'actionClick';
				onClick: (html jQuery this next toggle);
				with: [
					html icon: 'layer-group'.
					html text: aString ].
			self renderMediaSets: aCollection on: html ]
]

{ #category : #rendering }
MEDMyOverviewComponent >> renderMediaSets: aCollection on: html [
	html div class: 'mediaSetsList'; with: [ 
		aCollection do: [ :each |
			html div class: 'mediaSetRow'; with: [
				html anchor
					callback: [ self showMediaSet: each onAnswer: [self refresh] ];
					with: each displayName.
				html space.
				html span class: 'muted'; with: [
					html text: '('.
					html text: (each mediasCount asString).
					html text: ' Medien)'.
				].
				html span class: 'pure-hidden-sm float-right'; with: [ 
					html anchor
						callback: [ self downloadArchiveZip: each ];
						with: [
							html icon: 'file-archive'.
							html text: 'ZIP'].
					html space.
					html anchor
						callback: [ self downloadImagesPdf: each ];
						with: [
							html icon: 'file-pdf'.
							html text: 'PDF'].
						 ]
		] ] ]
]

{ #category : #rendering }
MEDMyOverviewComponent >> renderSearchQueriesOn: html [
	html pageSubheader: 'Gespeicherte Suchanfragen'.
		html div class: 'searchQueriesList'; with: [ 
			self currentPortfolio searchQueries ifBlank: [ html paragraph: 'Keine' ].
			self currentPortfolio searchQueries do: [ :each |
				html div class: 'searchQueryRow'; with: [
					html anchor
						callback: [ self executeSearchQuery: each ];
						with: each displayName.
					html span class: 'pure-hidden-sm float-right'; with: [
"						each notificationsEnabled
							ifTrue: [ html iconYes style: 'color:green' ]
							ifFalse: [ html iconNo ]. 
						html anchor
							callback: [ each toggleNotifications ];
							with: 'Auto-Email'.
						html space; space."
						html anchor
							callback: [ self deleteSearchQuery: each ];
							with: [html iconDelete].
					]
				]]]
]
