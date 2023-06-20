Class {
	#name : #MEDMediaSetSorter,
	#superclass : #MEDMediaSetComponentBase,
	#category : #'Mediaclue-View'
}

{ #category : #rendering }
MEDMediaSetSorter >> renderContentOn: html [
	html pageHeader: 'Sortierung'.
	html pageBody: [
		html paragraph: 'Ziehen und sortieren'.
		self renderToolbarOn: html.
		html grid
			script: ((html jQuery this sortable)
				forcePlaceholderSize: true;
				placeholder: 'gridUnit pure-u-1-5 mediaPlaceholder';
				onUpdate: (html jQuery ajax
					callback: [:values | self resortMediasLike: values]
					passengers: (html jQuery this children: 'div.gridUnit.media')));
			with: [ 
				model medias do: [ :each |
					(html gridUnitFraction: 1/5)
						class: 'media';
						passenger: each;
						with: [
							html div class: 'mediaSummary'; with: [
								html span: each title.
								html break.
								html thumbnail: each ].
						]]].

		html buttonToolbar: [
			html anchorButton
				callback: [ self close ];
				with: 'Schliessen' ]
	
	]
]

{ #category : #rendering }
MEDMediaSetSorter >> renderToolbarOn: html [
	html buttonToolbar: [
		html buttonGroup: [
			html anchorButtonPrimary
				callback: [ self close ];
				with: 'Schliessen'.
			html anchorButton
				callback: [ self sortAlphaTitle ];
				with: [
					html iconSort.
					html text: 'Alphabetisch'].
			html anchorButton
				callback: [ self sortOriginDate ];
				with: [
					html iconSort.
					html text: 'Aufnahmedatum'].
			html anchorButton
				callback: [ self sortUploadedDate ];
				with: [
					html iconSort.
					html text: 'Hochladedatum'].
			html anchorButton
				callback: [ self sortMediaType ];
				with: [
					html iconSort.
					html text: 'Medientyp'].
			html anchorButton
				callback: [ self sortFileSize ];
				with: [
					html iconSort.
					html text: 'Dateigrösse'].
			html anchorButton
				callback: [ self sortReverse ];
				with: [
					html iconArrowUpDown.
					html text: 'Umkehren'].

		].			
	]

]

{ #category : #rendering }
MEDMediaSetSorter >> resortMediasLike: aCollection [
	self sortBy: [ :each | aCollection indexOf: each ]
]

{ #category : #sorting }
MEDMediaSetSorter >> sortAlphaTitle [
	self sortBy: [ :each | each title ifBlank: [ 'aaaaaaaaaa' ] ]
]

{ #category : #rendering }
MEDMediaSetSorter >> sortBy: aBlock [
	model sortMediasBy: aBlock
]

{ #category : #sorting }
MEDMediaSetSorter >> sortFileSize [
	self sortBy: [ :each | each byteSize ]
]

{ #category : #sorting }
MEDMediaSetSorter >> sortMediaType [
	self sortBy: [ :each | each class displayName ]
]

{ #category : #sorting }
MEDMediaSetSorter >> sortOriginDate [
	self sortBy: [ :each | each originDate ifNil: [ Date year: 0 month: 1 day: 1 ] ]
]

{ #category : #sorting }
MEDMediaSetSorter >> sortReverse [
	| newCollection |
	newCollection := model medias copy reversed.
	
	self resortMediasLike: newCollection
]

{ #category : #sorting }
MEDMediaSetSorter >> sortUploadedDate [
	self sortBy: [ :each | each uploadedDate ifNil: [ Date year: 0 month: 1 day: 1 ] ]
]
