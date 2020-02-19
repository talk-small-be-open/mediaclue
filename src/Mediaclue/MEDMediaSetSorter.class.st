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
							html thumbnail: each]]].

		self renderToolbarOn: html ]
]

{ #category : #rendering }
MEDMediaSetSorter >> renderToolbarOn: html [
	html buttonToolbar: [
		html anchorButton
			callback: [ self close ];
			with: 'Schliessen' ]

]

{ #category : #rendering }
MEDMediaSetSorter >> resortMediasLike: aCollection [
	model sortMediasBy: [ :each | aCollection indexOf: each ]
]
