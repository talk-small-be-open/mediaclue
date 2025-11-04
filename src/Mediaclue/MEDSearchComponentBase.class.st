Class {
	#name : #MEDSearchComponentBase,
	#superclass : #MEDComponent,
	#instVars : [
		'searchResult',
		'searchQuery',
		'topTags',
		'myTopTags',
		'subjectTags',
		'suggestedTags',
		'allTags',
		'minorSelectedTags'
	],
	#category : #'Mediaclue-View'
}

{ #category : #'as yet unclassified' }
MEDSearchComponentBase class >> executeQuery: aQuery [
	^(self searchQuery: aQuery)
	search;
	yourself
]

{ #category : #'as yet unclassified' }
MEDSearchComponentBase class >> searchQuery: aQuery [
	^self basicNew
		setSearchQuery: aQuery;
		initialize;
		yourself
]

{ #category : #initializing }
MEDSearchComponentBase >> addTag: aTag [
	searchQuery addTag: aTag.

]

{ #category : #initializing }
MEDSearchComponentBase >> addTags: aCollection [
	aCollection do: [ :each | self addTag: each ]
]

{ #category : #'as yet unclassified' }
MEDSearchComponentBase >> calculateMinorSelectedTags [
	minorSelectedTags := self selectedTags copyWithoutAll: self majorTags
]

{ #category : #initializing }
MEDSearchComponentBase >> calculateSuggestedTags [
	| bag |

"(searchResult medias collect: [ :each | { each tags. each tags copyWithoutAll: self selectedTags } ]) inspect."
	
	bag := searchResult medias flatCollect: [ :each | each tags copyWithoutAll: self selectedTags ] as: Bag.
	

	suggestedTags := (bag sortedCounts collect: [ :each | each value ]) firstAtMost: 3.
	
	"Strange, sometimes it contains them to. Double check. Maybe because of non-orderedcollections in the above logic?
	problem was: Voyage proxies!"
"	suggestedTags := suggestedTags copyWithoutAll: self selectedTags"
]

{ #category : #initializing }
MEDSearchComponentBase >> clickTag: aTag [
	(searchQuery tags includes: aTag)
		ifTrue: [ searchQuery removeTag: aTag ]
		ifFalse: [ searchQuery addTag: aTag ].

	self search
]

{ #category : #actions }
MEDSearchComponentBase >> clipboardClear [
	self currentPortfolio clipboard clear; save.
]

{ #category : #testing }
MEDSearchComponentBase >> hasSearchResult [
	^ searchResult notNil
]

{ #category : #testing }
MEDSearchComponentBase >> hasSearchResults [
	^ searchResult notNil and: [ searchResult isEmpty not ]
]

{ #category : #initialization }
MEDSearchComponentBase >> initialize [
	
	super initialize.
	
	self initializeMyself.	
	self initializeSearch.
]

{ #category : #initialization }
MEDSearchComponentBase >> initializeMyself [
	| me |
	
	me := self currentUser.

	topTags := self session topTags.
	myTopTags := self session myTopTags.

	subjectTags := self session schoolSubjectTags.

	allTags := self db tags sortedBySortKey.
	
"	myMediaSets := self currentPortfolio mediaSets."

]

{ #category : #initialization }
MEDSearchComponentBase >> initializeSearch [
	"self subclassResponsibility" 
]

{ #category : #testing }
MEDSearchComponentBase >> isEmptySearchResult [
	^ searchResult notNil and: [ searchResult isEmpty ]
]

{ #category : #testing }
MEDSearchComponentBase >> isSelectedTag: aTag [
	^ self selectedTags includes: aTag
]

{ #category : #initialization }
MEDSearchComponentBase >> majorTags [
	^ topTags, myTopTags, subjectTags

]

{ #category : #accessing }
MEDSearchComponentBase >> myMediaSetsOnly [
	^ searchQuery myMediaOnly
]

{ #category : #accessing }
MEDSearchComponentBase >> myMediaSetsOnly: anObject [

	searchQuery myMediaOnly: anObject.

"	myMediaSetsOnly := anObject"
]

{ #category : #initializing }
MEDSearchComponentBase >> removeTag: aTag [
	searchQuery removeTag: aTag
]

{ #category : #rendering }
MEDSearchComponentBase >> renderAllTagsOn: html [
	| options |
	
	html div class: 'tagsArea'; with: [
		html span class: 'title'; with: 'Alle Schlagworte: '.
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
MEDSearchComponentBase >> renderButtonBarOn: html [
	html buttonToolbar: [
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
					html span class: 'pure-hidden-sm'; with: 'Zurücksetzen'] ] ]

]

{ #category : #rendering }
MEDSearchComponentBase >> renderSearchBarOn: html [
	html grid class: 'searchBar'; with: [
		html gridUnitFraction: 1/2 with: [
			html textInput
"				placeholder: 'Suchtext'"
				class: 'searchText';
				on: #text of: searchQuery].
		html gridUnitFraction: 1/2 with: [
			html buttonGroup: [
				html submitButton
					class: 'searchButton';
					callback: [ self search ];
					with: [
						html iconSearch.
"						html span class: 'pure-hidden-sm'; with: ' Suchen'"].
"				html anchorButton
					callback: [ self reset ];
					with: [
						html iconReset.
						html span class: 'pure-hidden-sm'; with: 'Zurücksetzen']" ]
		]
	].

	self isEmptySearchResult ifTrue: [ html alertWarning: 'Keine Treffer' ].
	self hasSearchResults ifTrue: [
		html alertSuccess: [
			html text: (searchResult hitsCount asString, ' Treffer').
			html span class: 'pure-visible-sm'; with: ' (siehe unten)'] ].

]

{ #category : #rendering }
MEDSearchComponentBase >> renderTags: aCollection title: aString on: html [
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
MEDSearchComponentBase >> reset [
	self initializeSearch.
	searchQuery clearFilter.
]

{ #category : #initializing }
MEDSearchComponentBase >> search [
	searchQuery sanitizeQuery.
	
	searchResult := self db findMediaByQuery: searchQuery.
	
"Not anymore. PERFORMANCE optimized in the mongo query.
	myMediaSetsOnly ifTrue: [ 
		searchResult := searchResult
			selectMedias: [ :each | myMediaSets anySatisfy: [ :ms | ms includes: each ] ]
			sets: [ :each | myMediaSets includes: each ]
	]."

	self calculateSuggestedTags.
	self calculateMinorSelectedTags.
]

{ #category : #initializing }
MEDSearchComponentBase >> searchAndAddTag: aTag [
	searchQuery addTag: aTag.
	self search
]

{ #category : #testing }
MEDSearchComponentBase >> selectedTags [
	^ searchQuery tags
]

{ #category : #initialization }
MEDSearchComponentBase >> setSearchQuery: aQuery [
	searchQuery := aQuery
]
