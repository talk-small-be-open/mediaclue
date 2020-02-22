Class {
	#name : #WEBHtmlCanvas,
	#superclass : #WAHtmlCanvas,
	#traits : 'TWEBGlobalHelpers',
	#classTraits : 'TWEBGlobalHelpers classTrait',
	#category : #'Webbase-Main-View'
}

{ #category : #elements }
WEBHtmlCanvas >> alertDanger [
	^self div
]

{ #category : #elements }
WEBHtmlCanvas >> alertDanger: aRenderable [
	self alertDanger with: aRenderable
]

{ #category : #elements }
WEBHtmlCanvas >> alertSuccess [
	^self div
]

{ #category : #elements }
WEBHtmlCanvas >> alertSuccess: aRenderable [
	self alertSuccess with: aRenderable
]

{ #category : #elements }
WEBHtmlCanvas >> alertWarning [
	^self div
]

{ #category : #elements }
WEBHtmlCanvas >> alertWarning: aRenderable [
	self alertWarning with: aRenderable
]

{ #category : #elements }
WEBHtmlCanvas >> anchorButton [
	^self anchor
]

{ #category : #elements }
WEBHtmlCanvas >> anchorButtonPrimary [
	^self anchorButton
]

{ #category : #'user interface' }
WEBHtmlCanvas >> basicTable [
	^ super table
]

{ #category : #elements }
WEBHtmlCanvas >> buttonGroup [
	^self div class: 'buttonGroup'; yourself
]

{ #category : #elements }
WEBHtmlCanvas >> buttonGroup: aRenderable [
	self buttonGroup with: aRenderable
]

{ #category : #elements }
WEBHtmlCanvas >> buttonToolbar [
	^self div class: 'buttonToolbar'; yourself
]

{ #category : #elements }
WEBHtmlCanvas >> buttonToolbar: aRenderable [
	self buttonToolbar with: aRenderable
]

{ #category : #convenience }
WEBHtmlCanvas >> h1 [
	^self heading level1
]

{ #category : #convenience }
WEBHtmlCanvas >> h1: aBlock [
	self h1 with: aBlock
]

{ #category : #convenience }
WEBHtmlCanvas >> h2 [
	^self heading level2
]

{ #category : #convenience }
WEBHtmlCanvas >> h2: aBlock [
	self h2 with: aBlock
]

{ #category : #convenience }
WEBHtmlCanvas >> h3 [
	^self heading level3
]

{ #category : #convenience }
WEBHtmlCanvas >> h3: aBlock [
	self h3 with: aBlock
]

{ #category : #convenience }
WEBHtmlCanvas >> h4 [
	^self heading level4
]

{ #category : #convenience }
WEBHtmlCanvas >> h4: aBlock [
	self h4 with: aBlock
]

{ #category : #convenience }
WEBHtmlCanvas >> h5 [
	^self heading level5
]

{ #category : #convenience }
WEBHtmlCanvas >> h5: aBlock [
	self h5 with: aBlock
]

{ #category : #convenience }
WEBHtmlCanvas >> h6 [
	^self heading level6
]

{ #category : #convenience }
WEBHtmlCanvas >> h6: aBlock [
	self h6 with: aBlock
]

{ #category : #icons }
WEBHtmlCanvas >> iconAdd [
	"subclasses"
]

{ #category : #icons }
WEBHtmlCanvas >> iconArrowDown [
	"subclasses"
]

{ #category : #icons }
WEBHtmlCanvas >> iconArrowLeft [
	"subclasses"
]

{ #category : #icons }
WEBHtmlCanvas >> iconArrowRight [
	"subclasses"
]

{ #category : #icons }
WEBHtmlCanvas >> iconArrowUp [
	"subclasses"
]

{ #category : #icons }
WEBHtmlCanvas >> iconBack [
	self iconArrowLeft
]

{ #category : #icons }
WEBHtmlCanvas >> iconDelete [
	"subclasses"
]

{ #category : #icons }
WEBHtmlCanvas >> iconDocument [
	"subclasses"
]

{ #category : #icons }
WEBHtmlCanvas >> iconDownload [
	"subclasses"
]

{ #category : #icons }
WEBHtmlCanvas >> iconEdit [
	"subclasses"
]

{ #category : #icons }
WEBHtmlCanvas >> iconError [
	"subclasses"
]

{ #category : #icons }
WEBHtmlCanvas >> iconInfo [
	"subclasses"
]

{ #category : #icons }
WEBHtmlCanvas >> iconLogin [
	"subclasses"
]

{ #category : #icons }
WEBHtmlCanvas >> iconLogout [
	"subclasses"
]

{ #category : #icons }
WEBHtmlCanvas >> iconMenu [
	"subclasses"
]

{ #category : #icons }
WEBHtmlCanvas >> iconNo [
	"subclasses"
]

{ #category : #icons }
WEBHtmlCanvas >> iconNoAccess [
	"subclasses"
]

{ #category : #icons }
WEBHtmlCanvas >> iconOk [
	"subclasses"
]

{ #category : #icons }
WEBHtmlCanvas >> iconRefresh [
	"subclasses"
]

{ #category : #icons }
WEBHtmlCanvas >> iconRemove [
	"subclasses"
]

{ #category : #icons }
WEBHtmlCanvas >> iconSave [
	"subclasses"
]

{ #category : #icons }
WEBHtmlCanvas >> iconSearch [
	"subclasses"
]

{ #category : #icons }
WEBHtmlCanvas >> iconSort [
	"subclasses"
]

{ #category : #icons }
WEBHtmlCanvas >> iconUpload [
	"subclasses"
]

{ #category : #icons }
WEBHtmlCanvas >> iconWait [
	"subclasses"
]

{ #category : #icons }
WEBHtmlCanvas >> iconWarning [
	"subclasses"
]

{ #category : #icons }
WEBHtmlCanvas >> iconYes [
	"subclasses"
]

{ #category : #elements }
WEBHtmlCanvas >> labelDanger [
	^self span
]

{ #category : #elements }
WEBHtmlCanvas >> labelDanger: aRenderable [
	self labelDanger with: aRenderable
]

{ #category : #elements }
WEBHtmlCanvas >> labelSuccess [
	^self span
]

{ #category : #elements }
WEBHtmlCanvas >> labelSuccess: aRenderable [
	self labelSuccess with: aRenderable
]

{ #category : #elements }
WEBHtmlCanvas >> labelWarning [
	^self span
]

{ #category : #elements }
WEBHtmlCanvas >> labelWarning: aRenderable [
	self labelWarning with: aRenderable
]

{ #category : #components }
WEBHtmlCanvas >> lazyImage: anUrlString [
	^self image
		class: 'lazy';
"		url: 'data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7';"
		attributeAt: 'data-src' put: anUrlString;
		yourself
]

{ #category : #elements }
WEBHtmlCanvas >> spinner [
	self span: 'BITTE WARTEN'
]

{ #category : #'form-buttons' }
WEBHtmlCanvas >> submitButton [
	^super button
		beSubmit;
		yourself
]

{ #category : #elements }
WEBHtmlCanvas >> submitButtonPrimary [
	^self submitButton
]
