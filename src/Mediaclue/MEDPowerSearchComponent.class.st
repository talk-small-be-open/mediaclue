Class {
	#name : #MEDPowerSearchComponent,
	#superclass : #MEDSearchComponentBase,
	#instVars : [
		'permissionTypeLabels'
	],
	#category : #'Mediaclue-View'
}

{ #category : #initialization }
MEDPowerSearchComponent >> initializeMyself [
	super initializeMyself.

	permissionTypeLabels := MEDHelper permissionTypeMap.
	
	"Wording"
	permissionTypeLabels at: #groups put: 'Spezifische Gruppen und Benutzer'
]

{ #category : #initialization }
MEDPowerSearchComponent >> initializeSearch [

	super initializeSearch.

	searchQuery ifNil: [
		searchQuery := MEDSearchQuery new.
		searchQuery allowedUser: self currentUser.

		"searching is fast but the deserializing with BSON ist very slow, so we
		HAVE to limit hard, so that a normal user will get fast results.
		TODO: Make a pagination"
		searchQuery limit: 50. 
		
	].

	searchResult := nil.
	suggestedTags := OrderedCollection new.
	minorSelectedTags := OrderedCollection new.

]

{ #category : #rendering }
MEDPowerSearchComponent >> renderContentOn: html [
"	self hasSearchResult ifTrue: [ self renderMenuOn: html ]."

	html pageHeader: 'Expertensuche'.
	html pageBody: [ 
		html form: [ 
			self renderSearchBarOn: html.

			html div class: 'searchTags'; with: [
				html div class: 'smartSuggestedTags'; with: [
					self renderTags: suggestedTags title: 'Häufigste Sub-Schlagworte:' on: html ].

				self renderTags: subjectTags title: 'Haupt-Schlagworte:' on: html.
			
				self renderTags: topTags title: 'Top-Schlagworte:' on: html.

"				self renderTags: myTopTags title: 'Meine Top-Schlagworte:' on: html."
				
				self renderAllTagsOn: html
			].
		
			self renderOptionsOn: html.
			
			self renderButtonBarOn: html.
		].

	self renderSearchResultsOn: html
	].

]

{ #category : #rendering }
MEDPowerSearchComponent >> renderOptionsOn: html [
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
"		html label with: [
			html checkbox on: #myMediaSetsOnly of: self.
			html text: ' Nur in eigenen Kollektionen suchen' ]."
		html label with: [
			html checkbox
				onTrue: [ searchQuery isGallery: true ] onFalse: [ searchQuery isGallery: nil ];
				value: (searchQuery isGallery = true).
			html text: ' Nur Galerien' ].	
	
		html label with: [
			html span: 'Sichtbarkeit: '.
			html select
				list: MEDHelper permissionTypeCodes;
				labels: [ :each | permissionTypeLabels at: each ];
				"			optionalLabel: 'Alle';"
				beOptional;
				on: #permissionType of: searchQuery ].

		html label with: [
			html span: 'Limite: '.
			html select
				list: #(10 25 50 100 500);
				optionalLabel: 'Alle';
				beOptional;
				on: #limit of: searchQuery ].

	]

]

{ #category : #rendering }
MEDPowerSearchComponent >> renderSearchResultsOn: html [
	searchResult ifNotNil: [
		html pageSubheader: 'Resultate'.
		html div class: 'searchResults'; with: [
			searchResult isEmpty
				ifTrue: [ html paragraph: 'Keine Treffer' ]
				ifFalse: [
					html table: [
						html tableRow: [ 
							html tableHeading: 'Icon'.
							html tableHeading: 'Titel'.
							html tableHeading: 'Besitzer' ].
						
						searchResult mediaSets do: [ :each |
							html tableRow: [
								html tableData: [ html iconMediaSet ].
								html tableData: [
									html anchor
										callback: [ self showMediaSet: each ];
										with: each displayName ].
								html tableData: each owner displayName
							]
						].
						searchResult hasMoreMediaSets ifTrue: [ html tableRow: [ html tableData colSpan: 3; with: '... und weitere Kollektionen' ] ].
						
						
						searchResult hasMedias ifTrue: [
							searchResult medias do: [ :each |
								html tableRow: [
									html tableData: [ html thumbnail: each ].
									html tableData: [
										html anchor
											callback: [ self showMedia: each ];
											with: each title ].
									html tableData: each owner displayName
								]
							].
							searchResult hasMoreMedias ifTrue: [ html tableRow: [ html tableData colSpan: 3; with: '... und weitere Medien' ] ].
						]
					]
				].
		]]
]
