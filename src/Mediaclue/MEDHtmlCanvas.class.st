Class {
	#name : #MEDHtmlCanvas,
	#superclass : #WEBHtmlCanvas,
	#category : #'Mediaclue-View'
}

{ #category : #elements }
MEDHtmlCanvas >> alertDanger [
	^ self div class: 'alertDanger'; yourself
]

{ #category : #elements }
MEDHtmlCanvas >> alertSuccess [
	^ self div class: 'alertSuccess'; yourself
]

{ #category : #elements }
MEDHtmlCanvas >> alertWarning [
	^ self div class: 'alertWarning'; yourself
]

{ #category : #'as yet unclassified' }
MEDHtmlCanvas >> anchorButton [
	^self anchor
		class: 'pure-button';
		yourself
]

{ #category : #'as yet unclassified' }
MEDHtmlCanvas >> anchorButtonPrimary [
	^self anchorButton
		class: 'pure-button-primary';
		yourself
]

{ #category : #'as yet unclassified' }
MEDHtmlCanvas >> backButtonAnchor [
	^ self anchor
		class: 'backButtonAnchor';
		yourself
]

{ #category : #elements }
MEDHtmlCanvas >> buttonGroup [
	^ self div
		class: 'pure-button-group';
		yourself
]

{ #category : #'user interface' }
MEDHtmlCanvas >> f: aFraction [
	^aFraction numerator asString, '-', aFraction denominator asString
]

{ #category : #icons }
MEDHtmlCanvas >> fas: aString [
	^ (self tag: 'i')
		class: ('icon fas fa-', aString);
		yourself
]

{ #category : #form }
MEDHtmlCanvas >> form [
	^ super form
		class: 'pure-form pure-form-aligned';
		yourself
]

{ #category : #'user interface' }
MEDHtmlCanvas >> grid [
	^self div class: 'grid pure-g'; yourself
]

{ #category : #'user interface' }
MEDHtmlCanvas >> grid: aBlock [
	self grid with: aBlock
]

{ #category : #'user interface' }
MEDHtmlCanvas >> gridUnit [
	^self gridUnitSmall: 1 medium: 1/2 large: 1/3 xlarge: 1/4
]

{ #category : #'user interface' }
MEDHtmlCanvas >> gridUnit: aBlock [
	self gridUnit with: aBlock
]

{ #category : #'user interface' }
MEDHtmlCanvas >> gridUnitFraction: aFraction [
	^self div
		class: 'gridUnit';
		class: 'pure-u-', (self f: aFraction);
		yourself
]

{ #category : #'user interface' }
MEDHtmlCanvas >> gridUnitFraction: aFraction with: aBlock [
	(self gridUnitFraction: aFraction) with: aBlock
]

{ #category : #'user interface' }
MEDHtmlCanvas >> gridUnitSmall: aFractionSm medium: aFractionMd large: aFractionLg [
	^self div
		class: 'gridUnit';
		class: 'pure-u-', (self f: aFractionSm);
		class: 'pure-u-md-', (self f: aFractionMd);
		class: 'pure-u-lg-', (self f: aFractionLg);
		yourself
]

{ #category : #'user interface' }
MEDHtmlCanvas >> gridUnitSmall: aFractionSm medium: aFractionMd large: aFractionLg with: aBlock [
	(self gridUnitSmall: aFractionSm medium: aFractionMd large: aFractionLg)
		with: aBlock
]

{ #category : #'user interface' }
MEDHtmlCanvas >> gridUnitSmall: aFractionSm medium: aFractionMd large: aFractionLg xlarge: aFractionXl [
	^self div
		class: 'gridUnit';
		class: 'pure-u-', (self f: aFractionSm);
		class: 'pure-u-md-', (self f: aFractionMd);
		class: 'pure-u-lg-', (self f: aFractionLg);
		class: 'pure-u-xl-', (self f: aFractionXl);
		yourself
]

{ #category : #icons }
MEDHtmlCanvas >> icon: aString [
	^ self fas: aString
]

{ #category : #icons }
MEDHtmlCanvas >> iconAccount [
	self fas: 'user-circle'
]

{ #category : #icons }
MEDHtmlCanvas >> iconAdd [
	self fas: 'plus'
]

{ #category : #icons }
MEDHtmlCanvas >> iconAdmin [
	self fas: 'user-cog'
]

{ #category : #icons }
MEDHtmlCanvas >> iconArrowLeft [
	self fas: 'arrow-left'
]

{ #category : #icons }
MEDHtmlCanvas >> iconArrowLeftRight [
	self fas: 'arrows-alt-h'
]

{ #category : #icons }
MEDHtmlCanvas >> iconArrowRight [
	self fas: 'arrow-right'
]

{ #category : #icons }
MEDHtmlCanvas >> iconArrowUpDown [
	self fas: 'arrows-alt-v'
]

{ #category : #icons }
MEDHtmlCanvas >> iconCopy [
	self fas: 'copy'
]

{ #category : #icons }
MEDHtmlCanvas >> iconDelete [
	self fas: 'trash'
]

{ #category : #icons }
MEDHtmlCanvas >> iconDocument [
	self fas: 'file'
]

{ #category : #icons }
MEDHtmlCanvas >> iconDownload [
	self fas: 'download'
]

{ #category : #icons }
MEDHtmlCanvas >> iconDrop [
	self fas: 'mouse-pointer'
]

{ #category : #icons }
MEDHtmlCanvas >> iconEdit [
	self fas: 'edit'
]

{ #category : #icons }
MEDHtmlCanvas >> iconFullscreen [
	self fas: 'desktop'
]

{ #category : #icons }
MEDHtmlCanvas >> iconGallery [
	self fas: 'images'
]

{ #category : #icons }
MEDHtmlCanvas >> iconHome [
	self fas: 'home'
]

{ #category : #icons }
MEDHtmlCanvas >> iconLogout [
	self fas: 'sign-out-alt'
]

{ #category : #icons }
MEDHtmlCanvas >> iconMedia [
	self fas: 'cube'
]

{ #category : #icons }
MEDHtmlCanvas >> iconMediaSet [
	self fas: 'cubes'
]

{ #category : #icons }
MEDHtmlCanvas >> iconMenu [
	self fas: 'bars'
]

{ #category : #icons }
MEDHtmlCanvas >> iconNo [
	self fas: 'minus-circle'
]

{ #category : #icons }
MEDHtmlCanvas >> iconNoAccess [
	self fas: 'minus-circle'
]

{ #category : #icons }
MEDHtmlCanvas >> iconPreview [
	self fas: 'eye'
]

{ #category : #icons }
MEDHtmlCanvas >> iconRemove [
	self fas: 'minus-circle'
]

{ #category : #icons }
MEDHtmlCanvas >> iconReset [
	self fas: 'power-off'
]

{ #category : #icons }
MEDHtmlCanvas >> iconRotateLeft [
	self fas: 'undo-alt'
]

{ #category : #icons }
MEDHtmlCanvas >> iconRotateRight [
	self fas: 'redo-alt'
]

{ #category : #icons }
MEDHtmlCanvas >> iconSave [
	self fas: 'save'
]

{ #category : #icons }
MEDHtmlCanvas >> iconSearch [
	self fas: 'search'
]

{ #category : #icons }
MEDHtmlCanvas >> iconSideMenu [
	self fas: 'ellipsis-v'
]

{ #category : #icons }
MEDHtmlCanvas >> iconSort [
	self fas: 'sort-numeric-down'
]

{ #category : #icons }
MEDHtmlCanvas >> iconUpload [
	self fas: 'cloud-upload-alt'
]

{ #category : #icons }
MEDHtmlCanvas >> iconYes [
	^ self fas: 'check-circle'
]

{ #category : #elements }
MEDHtmlCanvas >> imageLogo [
	^ self pureImage
		url: '/img/company-logo.png';
		yourself
]

{ #category : #elements }
MEDHtmlCanvas >> labelDanger [
	^ self span class: 'labelDanger'; yourself
]

{ #category : #elements }
MEDHtmlCanvas >> labelSuccess [
	^ self span class: 'labelSuccess'; yourself
]

{ #category : #elements }
MEDHtmlCanvas >> labelWarning [
	^ self span class: 'labelWarning'; yourself
]

{ #category : #'user interface' }
MEDHtmlCanvas >> menu [
	^ self div class: 'pure-menu'

]

{ #category : #'user interface' }
MEDHtmlCanvas >> menu: aBlock [
	self menu with: aBlock
]

{ #category : #'user interface' }
MEDHtmlCanvas >> menuDivider [
	self listItem class: 'menu-item-divider'
]

{ #category : #'user interface' }
MEDHtmlCanvas >> menuEntry: aBlock with: aRenderable [
	self menuItem: [ self menuLink: aBlock with: aRenderable ]
]

{ #category : #'user interface' }
MEDHtmlCanvas >> menuHeading [
	^ self div class: 'pure-menu-heading'; yourself
]

{ #category : #'user interface' }
MEDHtmlCanvas >> menuHeadingAnchor [
	^ self anchor class: 'pure-menu-heading'; yourself
]

{ #category : #'user interface' }
MEDHtmlCanvas >> menuItem: aBlock [
	self listItem class: 'pure-menu-item'; with: aBlock
]

{ #category : #'user interface' }
MEDHtmlCanvas >> menuLink: aBlock with: aRenderable [
	self anchor class: 'pure-menu-link'; callback: aBlock; with: aRenderable

]

{ #category : #'user interface' }
MEDHtmlCanvas >> menuList: aBlock [
	self unorderedList class: 'pure-menu-list'; with: aBlock
]

{ #category : #'user interface' }
MEDHtmlCanvas >> menuTitle: aString [
	self listItem class: 'pure-menu-title'; with: aString
]

{ #category : #'as yet unclassified' }
MEDHtmlCanvas >> pageBody: aBlock [
	self div class: 'content'; with: aBlock
]

{ #category : #'as yet unclassified' }
MEDHtmlCanvas >> pageHeader: aRenderable [
	self div class: 'header'; with: [
		self heading level1; with: aRenderable.
"		html heading level2; with: '...blabla'."
	].

]

{ #category : #'as yet unclassified' }
MEDHtmlCanvas >> pageHeader: aRenderable body: aRenderableBody [
	self pageHeader: aRenderable.
	self pageBody: aRenderableBody
]

{ #category : #'as yet unclassified' }
MEDHtmlCanvas >> pageSubheader: aRenderable [
	self heading level2; class: 'contentSubhead'; with: aRenderable
]

{ #category : #'as yet unclassified' }
MEDHtmlCanvas >> preview: aName media: aMedia [
	^self preview: aName media: aMedia lazy: true
]

{ #category : #'as yet unclassified' }
MEDHtmlCanvas >> preview: aName media: aMedia lazy: aBoolean [
	^self div
		class: 'mediaPreview';
		class: ('size', aName capitalized);
		with: [
			aBoolean
				ifTrue: [ 
					(self lazyImage: (aMedia previewImageUrl: aName)) class: 'pure-img' ]
				ifFalse: [
					self pureImage url: (aMedia previewImageUrl: aName) ]
		]
]

{ #category : #form }
MEDHtmlCanvas >> pureControlGroup: aBlock [
	^ self div
		class: 'pure-control-group';
		with: aBlock
]

{ #category : #form }
MEDHtmlCanvas >> pureControls: aBlock [
	^ self div
		class: 'pure-controls';
		with: aBlock
]

{ #category : #'user interface' }
MEDHtmlCanvas >> pureImage [
	^super image
		class: 'pure-img';
		yourself
]

{ #category : #enumerating }
MEDHtmlCanvas >> selectizeMultiSelect: options [
	^ self multiSelect
		script: (self jQuery this call: 'selectize' with: options asD);
		yourself
	
]

{ #category : #enumerating }
MEDHtmlCanvas >> selectizeSelect [
	^ self selectizeSelect: #()
]

{ #category : #enumerating }
MEDHtmlCanvas >> selectizeSelect: options [

	"Options, see
	https://selectize.dev/docs/usage"

	^ self select
		script: (self jQuery this call: 'selectize' with: options asD);
		yourself
	
]

{ #category : #'user interface' }
MEDHtmlCanvas >> sideMenu: aBlock [
	self anchor url: '#sideMenu'; id: 'sideMenuLink'; with: [
		self iconSideMenu.
	].

	self div id: 'sideMenu'; with: [
		self menu: aBlock]
]

{ #category : #elements }
MEDHtmlCanvas >> spinner [
	self fas: 'hourglass-start'
]

{ #category : #'as yet unclassified' }
MEDHtmlCanvas >> submitButton [
	^super submitButton
		class: 'pure-button';
		yourself
]

{ #category : #'as yet unclassified' }
MEDHtmlCanvas >> submitButtonPrimary [
	^self submitButton
		class: 'pure-button-primary';
		yourself
]

{ #category : #'user interface' }
MEDHtmlCanvas >> table [
	^super table
		class: 'pure-table pure-table-horizontal';
		yourself
]

{ #category : #'as yet unclassified' }
MEDHtmlCanvas >> textOrNa: aString [
	self text: (aString ifBlank: [ MEDHelper noValueLabel ])
]

{ #category : #'as yet unclassified' }
MEDHtmlCanvas >> thumbnail: aMedia [
	^ self preview: #thumbnail media: aMedia
]
