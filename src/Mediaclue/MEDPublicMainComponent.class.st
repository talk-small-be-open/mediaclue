Class {
	#name : #MEDPublicMainComponent,
	#superclass : #MEDMainComponentBase,
	#category : #'Mediaclue-View'
}

{ #category : #rendering }
MEDPublicMainComponent >> gotoDirectLogin [
	coreComponent := WEBPluggableComponent content: [ :html |
		self db users sortedBySortKey do: [ :each |
		html anchor
			callback: [ self login: each ];
			with: each displayName.
		html break].
	]
]

{ #category : #'as yet unclassified' }
MEDPublicMainComponent >> gotoHome [
	coreComponent := MEDPublicHomeComponent new.
	coreComponent onAnswer: [ self close ]
]

{ #category : #initialization }
MEDPublicMainComponent >> gotoLogin [
	self gotoHome
]

{ #category : #initialization }
MEDPublicMainComponent >> initialize [
	super initialize
]

{ #category : #'private protocol' }
MEDPublicMainComponent >> login [
	| user |

"	self db users ifEmpty: [ MEDUser new firstName: 'Testy'; lastName: 'Tester'; password: 'test123'; save ]."

	user := self db users first.

	self session login: user.

	self close
]

{ #category : #'private protocol' }
MEDPublicMainComponent >> login: aUser [

	self session login: aUser.

	self close
]

{ #category : #rendering }
MEDPublicMainComponent >> renderMenuOn: html [
	html div id: 'mainMenu'; with: [
		html menu: [
			html menuHeadingAnchor
				callback: [ self gotoHome ];
				with: [
					html image class: 'logo'; url: '/img/logo_m_icon.png'.
					html text: 'Mediaclue'].

			"Class: pure-menu-selected"
			html menuList: [
				html menuEntry: [ self gotoLogin ] with: [html iconHome; text: 'Anmelden'].
"Im Moment auf dem Demo nicht. SPäter NUR Dev:"		self isDemo ifFalse: [
					html menuEntry: [ self gotoDirectLogin ] with: [html iconHome; text: 'Direkt anmelden'].
				].
				html menuEntry: [ self gotoGalleries ] with: [html iconGallery; text: 'Galerien'].
			].
		].
		self renderFooterOn: html.
	].
]
