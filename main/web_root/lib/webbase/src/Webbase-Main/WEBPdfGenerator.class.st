Class {
	#name : #WEBPdfGenerator,
	#superclass : #WEBObject,
	#instVars : [
		'component',
		'targetName',
		'targetFolder',
		'binPath',
		'printSessionClass'
	],
	#category : #'Webbase-Main-Misc'
}

{ #category : #'as yet unclassified' }
WEBPdfGenerator class >> component: aComponent [
	^self new
		component: aComponent;
		yourself
]

{ #category : #accessing }
WEBPdfGenerator >> binPath [
	^ binPath
]

{ #category : #accessing }
WEBPdfGenerator >> binPath: anObject [
	binPath := anObject
]

{ #category : #accessing }
WEBPdfGenerator >> component [
	^ component
]

{ #category : #accessing }
WEBPdfGenerator >> component: anObject [
	component := anObject
]

{ #category : #'as yet unclassified' }
WEBPdfGenerator >> ensureTarget [
	(targetFolder isNil or: [ targetName isNil ]) ifTrue: [
		| pdfFile |
		pdfFile := WEBTempFile pdfForXSendfile.
		targetFolder := pdfFile directory.
		targetName := pdfFile fileName.
	]
]

{ #category : #'as yet unclassified' }
WEBPdfGenerator >> generate [
	^self generateWithWkhtmltopdf
]

{ #category : #'as yet unclassified' }
WEBPdfGenerator >> generateWithWkhtmltopdf [
	| shellCommandString tempFile |
	
	self ensureTarget.
	
	tempFile := WEBTempFile html
		write: self xhtmlString;
		yourself.
	
	"--footer-right [page]"
	shellCommandString := binPath, 'wkhtmltopdf --quiet --encoding utf8 --page-size A4 -B 0 -L 0 -R 0 -T 0  --disable-forms --stop-slow-scripts --print-media-type ', (tempFile filePath), ' "', (self targetFilePath), '"'.
	
	WEBSystemCommand run: shellCommandString.

	self ifProductionOrAlike: [	
		tempFile delete ].

	^self targetFilePath
]

{ #category : #'as yet unclassified' }
WEBPdfGenerator >> initialize [
	super initialize.
	binPath := '/usr/local/bin/'.
	
	self ifDevelopment: [
		binPath := '/usr/local/bin/'].

	printSessionClass := WEBSession
]

{ #category : #accessing }
WEBPdfGenerator >> printSessionClass [
	^ printSessionClass
]

{ #category : #accessing }
WEBPdfGenerator >> printSessionClass: anObject [
	printSessionClass := anObject
]

{ #category : #'as yet unclassified' }
WEBPdfGenerator >> targetFilePath [
	^targetFolder, '/', targetName
]

{ #category : #accessing }
WEBPdfGenerator >> targetFolder [
	^ targetFolder
]

{ #category : #accessing }
WEBPdfGenerator >> targetFolder: anObject [
	targetFolder := anObject
]

{ #category : #accessing }
WEBPdfGenerator >> targetName [
	^ targetName
]

{ #category : #accessing }
WEBPdfGenerator >> targetName: anObject [
	targetName := anObject
]

{ #category : #updating }
WEBPdfGenerator >> updateRoot: anHtmlRoot [
	anHtmlRoot beHtml5.
	anHtmlRoot meta charset: 'utf-8'.
"Nicht gut, weil die internen Anchor-Links dann als externe angeschaut werden	anHtmlRoot base url: self globalConfiguration webUrlLocal."

	anHtmlRoot htmlAttributes at: 'lang' put: 'de'.
	anHtmlRoot title: 'WEB-App PDF Generator'.
	anHtmlRoot stylesheet resourceUrl: '/print.css'.

	"Die Komponente auch noch dran lassen"
	component updateRoot: anHtmlRoot
]

{ #category : #'as yet unclassified' }
WEBPdfGenerator >> xhtmlString [
	| xhtmlString fakeRequestContext fakeSession |
	
	"Siehe auch Code-Fast-Duplikat mit
	WEBHelper>>writeComponent: aComponent toHtmlFile: aFilename folder: aFolder"
	
	fakeRequestContext := WARequestContext request: WARequest new response: WABufferedResponse new codec: (GRCodec forEncoding: 'utf8').

	fakeSession := printSessionClass new.

	fakeRequestContext
		push: fakeSession
		during: [
			| builder |

			builder := self pi defaultHtmlCanvasClass builder
				codec: (GRCodec forEncoding: 'utf-8');
				fullDocument: true;
				resourceUrl: self globalConfiguration webUrlLocal;
				rootBlock: [ :root |
					self updateRoot: root.
					(WAVisiblePresenterGuide client:
						(WAUpdateRootVisitor root: root))
						start: component
					];
				yourself.

			xhtmlString := builder render: [:html |
				html render: component]
		].

	^xhtmlString
]
