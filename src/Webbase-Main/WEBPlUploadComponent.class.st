Class {
	#name : #WEBPlUploadComponent,
	#superclass : #WEBComponent,
	#instVars : [
		'uploadSessionUuid',
		'tempFileReferences',
		'targetBasePath',
		'targetRelativePath',
		'errorMessage',
		'title',
		'dragDropMessage',
		'onUpload',
		'isEmbedded',
		'maxFileSizeBytes',
		'maxFileUploads',
		'extensionsList'
	],
	#category : #'Webbase-Main-View'
}

{ #category : #'as yet unclassified' }
WEBPlUploadComponent >> addUploadedFile: fileReference [
	tempFileReferences add: fileReference.
	onUpload ifNotNil: [ onUpload value: fileReference ]

]

{ #category : #'as yet unclassified' }
WEBPlUploadComponent >> ajaxUploadedFile: aString [
	| split filename filetitle |
	split := aString findTokens: '/'.
	filename := split first.
	filetitle := split second.

	self processUploadedFile: filename named: filetitle.

	"self registerUploadedFile: split first named: split second"
]

{ #category : #'as yet unclassified' }
WEBPlUploadComponent >> beEmbedded [
	isEmbedded := true
]

{ #category : #'as yet unclassified' }
WEBPlUploadComponent >> clear [
	self clearTempFileReferences.
	self clearErrorMessage
]

{ #category : #'as yet unclassified' }
WEBPlUploadComponent >> clearErrorMessage [
	errorMessage := nil
]

{ #category : #'as yet unclassified' }
WEBPlUploadComponent >> clearTempFileReferences [
	tempFileReferences := OrderedCollection new
]

{ #category : #accessing }
WEBPlUploadComponent >> dragDropMessage: aString [
	dragDropMessage := aString
]

{ #category : #accessing }
WEBPlUploadComponent >> extensionsList [
	^ extensionsList
]

{ #category : #accessing }
WEBPlUploadComponent >> extensionsList: anObject [
	extensionsList := anObject
]

{ #category : #actions }
WEBPlUploadComponent >> goAhead [
"	self processUploadedFiles"
	self answer: tempFileReferences.
]

{ #category : #testing }
WEBPlUploadComponent >> hasErrorMessage [
	^errorMessage notNil
]

{ #category : #testing }
WEBPlUploadComponent >> hasUploadedFile [
	^tempFileReferences notEmpty "isFileExisting"
]

{ #category : #'as yet unclassified' }
WEBPlUploadComponent >> initialize [
	super initialize.
	targetRelativePath := 'uploads'.
"	acceptedMimeTypes := OrderedCollection new."
	uploadSessionUuid := UUID new asString36.
	isEmbedded := false.
	maxFileSizeBytes := 100 * (1024*1024).
	maxFileUploads := 1000.
	extensionsList := 'jpg,jpeg,png,gif'.
	self clear
]

{ #category : #accessing }
WEBPlUploadComponent >> maxFileSizeBytes [
	^ maxFileSizeBytes
]

{ #category : #accessing }
WEBPlUploadComponent >> maxFileSizeBytes: anObject [
	maxFileSizeBytes := anObject
]

{ #category : #accessing }
WEBPlUploadComponent >> maxFileUploads [
	^ maxFileUploads
]

{ #category : #accessing }
WEBPlUploadComponent >> maxFileUploads: anObject [
	maxFileUploads := anObject
]

{ #category : #accessing }
WEBPlUploadComponent >> onUpload: aBlock [
	onUpload := aBlock
]

{ #category : #'as yet unclassified' }
WEBPlUploadComponent >> processUploadedFile: aFilepathString named: aNameString [
	| uniqueFilename uploadAbsoluteDir uploadRelativeDir uuidString fileReference source |
	uuidString := UUID new greaseString.
	uploadRelativeDir := self targetRelativePath.
	uniqueFilename := uuidString, '.', (aNameString asFileReference extension).

	uploadAbsoluteDir := self targetBasePath, '/', uploadRelativeDir.
	GRPlatform current ensureExistenceOfFolder: uploadAbsoluteDir.

	"Bereits bestehendes File hierhin verschieben"
	source := (self tempUploadFolder, aFilepathString) asFileReference.
	source moveTo: (uploadAbsoluteDir, '/', uniqueFilename) asFileReference.

	fileReference := WEBLocalFileReference new
		fileBasePath: self targetBasePath;
		fileRelativePath: uploadRelativeDir;
		fileName: uniqueFilename;
		title: aNameString;
		yourself.

	self addUploadedFile: fileReference
]

{ #category : #rendering }
WEBPlUploadComponent >> renderContentOn: html [
	html div class: 'uploader'; with: [
		self renderDynamicJsOn: html.
		self renderUploaderOn: html.
		isEmbedded ifFalse: [ 
			self renderUploadedFilesOn: html.

			html div class: 'topBuffer'; with: [	
				self hasUploadedFile ifTrue: [
					html anchorButton
						callback: [self goAhead];
						with: 'OK'.
					html space].
				html anchor
					callback: [self cancel];
					with: 'Abbrechen']
		]]
]

{ #category : #rendering }
WEBPlUploadComponent >> renderDynamicJsOn: html [
	| js jsUploadedEventHandler |
	jsUploadedEventHandler := (html jQuery ajax
		callback: [ :name | self ajaxUploadedFile: name ]
		value: (JSStream on: 'ajaxParameter');
		onError: (html javascript alert: 'Fehler mit der Kommunikation (XHR)!')).

	js := (JSStream on: ('

function seasideUploadSessionUuid() {
	return "', uploadSessionUuid,'";
}

function seasideCallbackFileUploaded(ajaxParameter) {
')), jsUploadedEventHandler, (JSStream on: '
}

function seasideAllowedFileExtensions() {
	return "', extensionsList,'";
}

function seasideMaxFileUploads() {
	return ', maxFileUploads asString,';
}

').

	html script: js
]

{ #category : #rendering }
WEBPlUploadComponent >> renderUploadedFilesOn: html [
	tempFileReferences ifNotBlank: [
		html div class: 'uploadedFilesList'; with: [
			html strong: 'Hochgeladene Dateien:'.
			tempFileReferences do: [:each |
				html div: [
					html text: each displayName]
			]]]
]

{ #category : #rendering }
WEBPlUploadComponent >> renderUploaderOn: html [
	title ifNotBlank: [
		html heading level3; with: title ].

	errorMessage ifNotNil: [
		html div class: 'error'; with: errorMessage.
		self clearErrorMessage].

	html div
		style: 'min-height: 2em;';
		class: 'uploadDropzone';
		id: 'pluploadDropzone';
		with: [
			html div class: 'dragDropMessage'; with: [
				html iconDrop.
				html break.
				html text: dragDropMessage ].
			html div class: 'topBuffer'; with: [ 
				html anchorButton
					id: 'pluploadBrowseButton';
					with: [
						html iconAdd.
						html text: 'Dateien auswählen ...' ] ].

			html div class: 'uploadFilelist'; with: [
				html unorderedList id: 'pluploadFilelist' ].

			html div: [
				html anchorButtonPrimary
					id: 'pluploadStartButton';
					with: [
						html iconUpload.
						html text: 'Hochladen starten!']]
		].

]

{ #category : #accessing }
WEBPlUploadComponent >> targetBasePath [
	^ targetBasePath
]

{ #category : #accessing }
WEBPlUploadComponent >> targetBasePath: anObject [
	targetBasePath := anObject
]

{ #category : #accessing }
WEBPlUploadComponent >> targetRelativePath [
	^ targetRelativePath
]

{ #category : #accessing }
WEBPlUploadComponent >> targetRelativePath: anObject [
	targetRelativePath := anObject
]

{ #category : #'as yet unclassified' }
WEBPlUploadComponent >> tempUploadFolder [
	^'/tmp/plupload/', uploadSessionUuid, '/'
]

{ #category : #accessing }
WEBPlUploadComponent >> title [
	^ title
]

{ #category : #accessing }
WEBPlUploadComponent >> title: anObject [
	title := anObject
]

{ #category : #updating }
WEBPlUploadComponent >> updateRoot: anHtmlRoot [
	super updateRoot: anHtmlRoot.

	anHtmlRoot javascript url: '/lib/webbase/lib/plupload-2.3.6/js/plupload.full.min.js'.
	anHtmlRoot javascript url: '/lib/webbase/lib/plupload-2.3.6/js/i18n/de.js'.
	
	anHtmlRoot javascript with: '
var pluploadMaxFileSize = ', maxFileSizeBytes asString, ';
'.
	anHtmlRoot javascript url: '/lib/webbase/lib/uploader.js'
	
]
