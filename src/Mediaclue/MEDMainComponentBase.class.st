Class {
	#name : #MEDMainComponentBase,
	#superclass : #MEDComponent,
	#instVars : [
		'coreComponent'
	],
	#category : #'Mediaclue-View'
}

{ #category : #hooks }
MEDMainComponentBase >> children [
	^Array with: coreComponent
]

{ #category : #'as yet unclassified' }
MEDMainComponentBase >> gotoGalleries [
	| galleries |
	galleries := self db findPublicMediaSets sortedReversedBy: [ :each | each createdAt ifNil: [ Date today ] ].
	coreComponent := (MEDGalleriesComponent mediaSets: galleries)
]

{ #category : #'as yet unclassified' }
MEDMainComponentBase >> gotoHome [
	"subclasses"
]

{ #category : #initialization }
MEDMainComponentBase >> initialize [
	super initialize.
	self gotoHome
]

{ #category : #rendering }
MEDMainComponentBase >> renderBottomOn: html [
]

{ #category : #rendering }
MEDMainComponentBase >> renderContentOn: html [

	html div id: 'layout'; with: [
		html div id: 'topBar'; with: 'MEDIACLUE'.
		
		html anchor url: '#mainMenu'; id: 'mainMenuLink'; with: [
			html iconMenu.
		].

		self renderMenuOn: html.

		html div id: 'main'; with: coreComponent.

		self renderBottomOn: html.
	].


]

{ #category : #rendering }
MEDMainComponentBase >> renderFooterOn: html [
	html div class: 'footer'; with: [
		html text: 'Entwickelt von '.
		html anchor
			targetBlank;
			url: 'https://www.kshp.ch';
			with: 'Gymnasium Hohe Promenade'.
		html text: ' & '.
		html anchor
			targetBlank;
			url: 'https://www.mindclue.ch';
			with: 'mindclue gmbh'.

		html break; break.
		html text: 'Version 2.0' ]
]

{ #category : #rendering }
MEDMainComponentBase >> renderMenuOn: html [

]
