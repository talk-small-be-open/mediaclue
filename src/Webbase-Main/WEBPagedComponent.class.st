"
A simple but effective component which has several views, called ""pages"". For cases where it would be overkill to define multiple components for each page
"
Class {
	#name : #WEBPagedComponent,
	#superclass : #WEBComponent,
	#instVars : [
		'pageName',
		'lastPageName'
	],
	#category : #'Webbase-Main-View'
}

{ #category : #testing }
WEBPagedComponent >> canGoBack [
	^lastPageName notBlank
]

{ #category : #'page-navigation' }
WEBPagedComponent >> gotoBack [
	self gotoPage: lastPageName
]

{ #category : #'page-navigation' }
WEBPagedComponent >> gotoPage: aPageName [
	lastPageName := pageName.
	pageName := aPageName asSymbol
]

{ #category : #'page-navigation' }
WEBPagedComponent >> gotoStart [
	pageName := self pages first
]

{ #category : #initialization }
WEBPagedComponent >> initialize [
	super initialize.
	self gotoStart
]

{ #category : #accessing }
WEBPagedComponent >> pages [
	^#(blank)
]

{ #category : #rendering }
WEBPagedComponent >> renderContentOn: html [
	"default"
	self renderDispatchOn: html
]

{ #category : #rendering }
WEBPagedComponent >> renderDispatchOn: html [
	| rendererSelector |
	
"	self renderGotoBackOn: html."
	
	rendererSelector := ('renderPage', (pageName capitalized), 'On:') asSymbol.
	self perform: rendererSelector with: html
]

{ #category : #rendering }
WEBPagedComponent >> renderGotoBackOn: html [
	self canGoBack ifTrue: [
		html div class: 'noPrint'; with: [
			html anchor
				useBaseUrl;
				callback: [self gotoBack];
				with: [
					html iconArrowLeft.
					html space.
					html text: 'Zurück']]]
]

{ #category : #rendering }
WEBPagedComponent >> renderGotoBackTo: aPageName on: html [
	html div class: 'noPrint'; with: [
		html anchorButton
"			useBaseUrl;"
			callback: [self gotoPage: aPageName];
			with: [
				html iconArrowLeft.
				html space.
				html text: 'Zurück']]
]

{ #category : #rendering }
WEBPagedComponent >> renderPageBlankOn: html [
	"dummy"
]

{ #category : #rendering }
WEBPagedComponent >> renderPagesMenuOn: html [
	html div class: 'adminMenu bottomBuffer'; with: [
		self pages do: [ :each |
			html anchor
				class: 'active' if: pageName = each;
				callback: [ self gotoPage: each ];
				with: [ html text: (self titleOfPage: each) ].
			html space.
		]]
]

{ #category : #'as yet unclassified' }
WEBPagedComponent >> restoreScrollPositionId [
	^super restoreScrollPositionId, '_', pageName
]

{ #category : #'as yet unclassified' }
WEBPagedComponent >> states [
	^Array with: self
]

{ #category : #'as yet unclassified' }
WEBPagedComponent >> titleOfPage: aPageName [
	"subclasses do better"
	^ aPageName capitalized
]
