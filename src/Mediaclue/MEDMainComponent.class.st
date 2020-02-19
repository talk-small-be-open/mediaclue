Class {
	#name : #MEDMainComponent,
	#superclass : #MEDMainComponentBase,
	#category : #'Mediaclue-View'
}

{ #category : #actions }
MEDMainComponent >> gotoAccount [
	coreComponent := MEDMyAccountComponent new
]

{ #category : #actions }
MEDMainComponent >> gotoAdminCockpit [
	coreComponent := MEDAdminComponent new
]

{ #category : #'as yet unclassified' }
MEDMainComponent >> gotoHome [
	self gotoOverview
]

{ #category : #actions }
MEDMainComponent >> gotoOverview [
	coreComponent := MEDMyOverviewComponent new

]

{ #category : #actions }
MEDMainComponent >> gotoSearch [
	coreComponent := MEDSearchComponent new

]

{ #category : #actions }
MEDMainComponent >> gotoUpload [
	coreComponent := (MEDUploadCockpitComponent into: self currentPortfolio uploading)
		onAnswer: [ self gotoOverview ];
		yourself


]

{ #category : #initialization }
MEDMainComponent >> initialize [
	super initialize.
	self gotoOverview.

]

{ #category : #protocol }
MEDMainComponent >> logout [
	self session logout.
	self close
]

{ #category : #rendering }
MEDMainComponent >> renderMenuOn: html [
	html div id: 'mainMenu'; with: [
		html menu: [
			html menuHeadingAnchor
				callback: [ self gotoHome ];
				with: [
					html image class: 'logo'; url: '/img/logo_m_icon.png'.
					html text: 'Mediaclue'].

			"Class: pure-menu-selected"
			html menuList: [
				html menuEntry: [ self gotoOverview ] with: [html iconHome; text: 'Übersicht'].
				html menuEntry: [ self gotoSearch ] with: [html iconSearch; text: 'Suchen'].
				self session canUpload ifTrue: [
					html menuEntry: [ self gotoUpload ] with: [html iconUpload; text: 'Hochladen']].
				html menuEntry: [ self gotoGalleries ] with: [html iconGallery; text: 'Galerien'].
				html menuDivider.
				html menuEntry: [ self gotoAccount ] with: [html iconAccount; text: self currentUser displayName].
				html menuEntry: [ self logout ] with: [html iconLogout; text: 'Abmelden'].
				
				self currentUser ifAdmin: [
					html menuDivider.
					html menuEntry: [ self gotoAdminCockpit ] with: [html iconAdmin; text: 'Admin'].
				]
			].
		].
	self renderFooterOn: html
	].
]
