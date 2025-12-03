Class {
	#name : #MEDLighttableSlideshowComponent,
	#superclass : #MEDSlideshowComponentBase,
	#instVars : [
		'size',
		'showReportMisuse',
		'showDownload'
	],
	#category : #'Mediaclue-View'
}

{ #category : #actions }
MEDLighttableSlideshowComponent >> beLarge [
	size := #large
]

{ #category : #actions }
MEDLighttableSlideshowComponent >> beMedium [
	size := #medium
]

{ #category : #'as yet unclassified' }
MEDLighttableSlideshowComponent >> beShowDownload [
	showDownload := true
]

{ #category : #'as yet unclassified' }
MEDLighttableSlideshowComponent >> beShowReportMisuse [
	showReportMisuse := true
]

{ #category : #actions }
MEDLighttableSlideshowComponent >> beSmall [
	size := #small
]

{ #category : #actions }
MEDLighttableSlideshowComponent >> downloadImage: aMedia [
	self offerDownloadFile: aMedia fileReference
]

{ #category : #'as yet unclassified' }
MEDLighttableSlideshowComponent >> gridFraction [
	self isLarge ifTrue: [ ^ 1 ].
	self isMedium ifTrue: [ ^ 1/2 ].
	self isSmall ifTrue: [ ^ 1/4 ].

	^ 1
]

{ #category : #rendering }
MEDLighttableSlideshowComponent >> initialize [ 
	super initialize.
	self beSmall.
	showReportMisuse := false.
	showDownload := false.
]

{ #category : #testing }
MEDLighttableSlideshowComponent >> isLarge [
	^ size = #large
]

{ #category : #testing }
MEDLighttableSlideshowComponent >> isMedium [
	^ size = #medium
]

{ #category : #testing }
MEDLighttableSlideshowComponent >> isSmall [
	^ size = #small
]

{ #category : #rendering }
MEDLighttableSlideshowComponent >> renderContentOn: html [
	self renderToolbarOn: html.
	html div
		class: 'lighttable';
		with: [
			html grid: [
				self mediasDo: [ :each |
					self renderImage: each on: html ]]]
]

{ #category : #rendering }
MEDLighttableSlideshowComponent >> renderImage: aMedia on: html [
	(html gridUnitFraction: self gridFraction) class: 'lighttableImage'; with: [
		mediaRenderer renderSimplePreview: aMedia size: size zoomSize: #large on: html.
		self renderToolsFor: aMedia on: html.
	]
]

{ #category : #rendering }
MEDLighttableSlideshowComponent >> renderToolbarOn: html [
	html buttonToolbar: [
		html buttonGroup: [
			html anchorButton
				class: 'pure-button-active' if: self isSmall;
				callback: [ self beSmall ];
				with: 'Klein'.
			html anchorButton
				class: 'pure-button-active' if: self isMedium;
				callback: [ self beMedium ];
				with: 'Mittel'.
			html anchorButton
				class: 'pure-button-active' if: self isLarge;
				callback: [ self beLarge ];
				with: 'Gross' ]]
]

{ #category : #rendering }
MEDLighttableSlideshowComponent >> renderToolsFor: aMedia on: html [
	(showReportMisuse or: [ showDownload ]) ifTrue: [
		html div class: 'imageTools'; with: [ 
			showDownload ifTrue: [
				html anchor
					callback: [ self downloadImage: aMedia ];
					with: 'Herunterladen' ].
			showReportMisuse ifTrue: [
				html space; space.
				html anchor
					callback: [ self reportMisuse: aMedia ];
					with: 'Löschung' ].
		]
	]
]

{ #category : #actions }
MEDLighttableSlideshowComponent >> reportMisuse: aMedia [
	self show: (MEDReportMisuseComponent media: aMedia)
]

{ #category : #accessing }
MEDLighttableSlideshowComponent >> showDownload [
	^ showDownload
]

{ #category : #accessing }
MEDLighttableSlideshowComponent >> showDownload: anObject [
	showDownload := anObject
]
