Class {
	#name : #MEDMediaRenderer,
	#superclass : #MEDComponent,
	#instVars : [
		'component',
		'selectedMedia',
		'clickMediaAction',
		'canSelect',
		'canEdit'
	],
	#category : #'Mediaclue-View'
}

{ #category : #accessing }
MEDMediaRenderer class >> component: aComponent [
	^ self basicNew
		setComponent: aComponent;
		initialize;
		yourself
]

{ #category : #rendering }
MEDMediaRenderer >> ajaxCheckbox: aValueString media: aMedia [
	aValueString = 'true'
		ifTrue: [ self selectMedia: aMedia ]
		ifFalse: [ self unselectMedia: aMedia ]
]

{ #category : #rendering }
MEDMediaRenderer >> ajaxSelectAll [
	self selectAll
]

{ #category : #rendering }
MEDMediaRenderer >> ajaxSelectAll: aCollection [
	self selectMedias: aCollection
]

{ #category : #'as yet unclassified' }
MEDMediaRenderer >> beNoClick [
	clickMediaAction := nil
]

{ #category : #'as yet unclassified' }
MEDMediaRenderer >> beNoSelect [
	canSelect := false
]

{ #category : #actions }
MEDMediaRenderer >> clearSelection [
	selectedMedia := OrderedCollection new
]

{ #category : #actions }
MEDMediaRenderer >> clickMedia: aMedia [
	clickMediaAction value: aMedia
]

{ #category : #testing }
MEDMediaRenderer >> hasSelection [
	^ selectedMedia notBlank
]

{ #category : #testing }
MEDMediaRenderer >> ifCanSelect: aBlock [
	^ canSelect ifTrue: aBlock
]

{ #category : #testing }
MEDMediaRenderer >> ifCantView: aMedia do: aBlock [
	^ (aMedia canView: self currentUser) ifFalse: aBlock
]

{ #category : #initialization }
MEDMediaRenderer >> initialize [
	super initialize.
	self clearSelection.
	canSelect := true.
	canEdit := false.
	clickMediaAction := [ :each | component showMedia: each ]
]

{ #category : #testing }
MEDMediaRenderer >> isSelected: aMedia [
	^selectedMedia includes: aMedia 
]

{ #category : #'as yet unclassified' }
MEDMediaRenderer >> onClickMedia: aBlock [
	clickMediaAction := aBlock
]

{ #category : #'rendering-views' }
MEDMediaRenderer >> renderBigCard: aMedia on: html [
	| mainLinkId |
	
	html div
		class: 'mediaContainer bigCard';
		with: [
			self renderCantView: aMedia on: html or: [
				html grid: [
					html gridUnitFraction: 1/3 with: [
						mainLinkId := self renderClick: aMedia on: html with: [ html thumbnail: aMedia ] ].
					(html gridUnitFraction: 2/3) class: 'mediaInfo'; with: [
						html div
							class: 'mediaTitle';
							onClick: (((html jQuery id: mainLinkId) at: 0) triggerClick);
							style: 'cursor: pointer;';
							with: [
								html span: aMedia title ].
						self renderSelect: aMedia on: html.


						] ] ] ]
]

{ #category : #testing }
MEDMediaRenderer >> renderCantView: aMedia on: html or: aBlock [
	(aMedia canView: self currentUser) ifTrue: aBlock ifFalse: [
		html div class: 'noAccess'; with: [
			html iconNoAccess; space.
			html text: 'Kein Zugriff'.
			].
	]
]

{ #category : #rendering }
MEDMediaRenderer >> renderClick: aMedia on: html with: aBlock [
	| id |
	id := nil.
	
	clickMediaAction
		ifNil: aBlock
		ifNotNil: [
			id := html nextId.
			html anchor
				id: id;
				callback: [ self clickMedia: aMedia ];
				with: aBlock ].
	^id
]

{ #category : #'rendering-views' }
MEDMediaRenderer >> renderDefault: aMedia on: html [
	self renderBigCard: aMedia on: html
]

{ #category : #'rendering-views' }
MEDMediaRenderer >> renderOneliner: aMedia on: html [
	html span class: 'mediaContainer oneliner'; with: [
		self renderSelect: aMedia on: html.
		html space.
		"Icon?"
		html thumbnail: aMedia.
		html span: aMedia title ].
]

{ #category : #rendering }
MEDMediaRenderer >> renderSelect: aMedia on: html [
	self ifCanSelect: [
		html checkbox
			class: 'selectMedia';
			id: (html nextId);
			script: ((html jQuery this closest: 'div.mediaContainer')
				onClick: (('onClickFireCheckboxes(event, "#', html lastId,'")') asFunction: #(event))
			);
			onClick: (html jQuery this trigger: 'fire');
			script: (html jQuery this on: 'fire' do: (html jQuery ajax
				callback: [ :value | self ajaxCheckbox: value media: aMedia ]
				value: (html jQuery this propertyAt: 'checked')));
			value: (self isSelected: aMedia).
	]
]

{ #category : #rendering }
MEDMediaRenderer >> renderSelectionToolsOn: html [
	self ifCanSelect: [
		html anchor
			onClick: ((html jQuery ajax
				callback: [ self ajaxSelectAll ])
				onSuccess: ((html jQuery find: 'input.selectMedia:checkbox') propertyAt: 'checked' put: true ));
			with: 'Alle wählen' ]
]

{ #category : #'rendering-views' }
MEDMediaRenderer >> renderSimplePreview: aMedia size: aPreviewSizeName on: html [
	^self renderSimplePreview: aMedia size: aPreviewSizeName zoomSize: nil on: html

]

{ #category : #'rendering-views' }
MEDMediaRenderer >> renderSimplePreview: aMedia size: aPreviewSizeName zoomSize: aZoomSizeName on: html [
	| tag |
	tag := html div
		class: 'mediaContainer simplePreview';
		class: 'size', aPreviewSizeName capitalized;
		yourself.
		
	aZoomSizeName ifNotBlank: [
		tag
			style: 'cursor: zoom-in';
			onClick: 'showZoomedImage("', (aMedia previewImageUrl: aZoomSizeName), '")'
	].

	tag with: [
		html preview: aPreviewSizeName media: aMedia.
		self renderSelect: aMedia on: html.
	].

]

{ #category : #actions }
MEDMediaRenderer >> selectMedia: aMedia [
	selectedMedia addIfNotPresent: aMedia
]

{ #category : #actions }
MEDMediaRenderer >> selectMedias: aMediaCollection [
	selectedMedia addAllIfNotPresent: aMediaCollection
]

{ #category : #accessing }
MEDMediaRenderer >> selectedMedia [
	^ selectedMedia
]

{ #category : #accessing }
MEDMediaRenderer >> selectedMedia: anObject [
	selectedMedia := anObject copy
]

{ #category : #initialization }
MEDMediaRenderer >> setComponent: aComponent [
	component := aComponent
]

{ #category : #actions }
MEDMediaRenderer >> unselectMedia: aMedia [
	selectedMedia removeIfPresent: aMedia
]
