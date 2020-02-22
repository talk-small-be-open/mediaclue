Class {
	#name : #WEBMainDecoration,
	#superclass : #WEBComponentDecoration,
	#category : #'Webbase-Main-View'
}

{ #category : #testing }
WEBMainDecoration >> isGlobal [
	^true
]

{ #category : #'as yet unclassified' }
WEBMainDecoration >> mainComponent [
	"Hm, ist das dirty?"
	^self decoratedComponent mainComponent
]

{ #category : #rendering }
WEBMainDecoration >> renderContentOn: html [
	self renderFlashMessagesOn: html.
	self renderFlashErrorMessagesOn: html.

	self renderNextOn: html
]

{ #category : #rendering }
WEBMainDecoration >> renderFlashErrorMessagesOn: html [
	self session consumeFlashErrorMessages ifNotBlank: [ :strings |
		html alertDanger class: 'flashErrorMessages'; with: [
			strings do: [ :each |
				html div: [
					html iconError; space.
					html text: each]
			]
		]
	]
]

{ #category : #rendering }
WEBMainDecoration >> renderFlashMessagesOn: html [
	self session consumeFlashMessages ifNotBlank: [ :strings |
		html alertSuccess class: 'flashMessages'; with: [
			strings do: [ :each |
				html div: [
					html iconYes; space.
					html text: each]
			]
		]
	]
]

{ #category : #updating }
WEBMainDecoration >> updateRoot: anHtmlRoot [
	super updateRoot: anHtmlRoot.
	
	self requestContext response doNotCache.
	
	anHtmlRoot beHtml5.
	
	anHtmlRoot htmlAttributes
		at: 'lang' put: 'de'.		

	self db isDevelopment
		ifTrue: [
			anHtmlRoot title: 'DEVELOPMENT ', self pi projectName.
			anHtmlRoot bodyAttributes addClass: 'development'.
		]
		ifFalse: [
			anHtmlRoot title: self pi projectName.
		].

	anHtmlRoot meta
		charset: 'utf-8'.
		
	"Viewport"
	anHtmlRoot meta
		name: 'viewport';
		content: 'width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no'.
	
	"Tell robots not to follow links"
	anHtmlRoot meta
		name: 'ROBOTS';
		content: 'INDEX, NOFOLLOW'.
		
	"Favicon"
	anHtmlRoot link
		beShortcutIcon;
		url: '/favicon.ico'.

	"libraries... javascript css..."
	self updateRootLibraries: anHtmlRoot
]

{ #category : #updating }
WEBMainDecoration >> updateRootJquery: anHtmlRoot [
	self subclassResponsibility
]

{ #category : #updating }
WEBMainDecoration >> updateRootLibraries: anHtmlRoot [

	self updateRootJquery: anHtmlRoot.

	anHtmlRoot javascript url: '/lib/webbase/lib/js.cookie.js'.
	
"	anHtmlRoot stylesheet url: '/lib/webbase/lib/styles.css'."
	anHtmlRoot javascript url: '/lib/webbase/lib/scripts.js'.

]
