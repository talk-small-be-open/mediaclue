Class {
	#name : #WEBTempFile,
	#superclass : #WEBObject,
	#instVars : [
		'fileBaseName',
		'tempDirectory',
		'fileExtension',
		'fileName',
		'fileBasePath',
		'contentType'
	],
	#category : #'Webbase-Main-Misc'
}

{ #category : #'as yet unclassified' }
WEBTempFile class >> csv [
	^self basicNew
		setFileExtension: 'csv';
		initialize;
		yourself
]

{ #category : #'as yet unclassified' }
WEBTempFile class >> csvForXSendfile [
	^self extension: 'csv' tempFolder: self defaultTempDirectory
]

{ #category : #'as yet unclassified' }
WEBTempFile class >> defaultFileExtension [
	^ 'tempfile'
]

{ #category : #'as yet unclassified' }
WEBTempFile class >> defaultTempDirectory [
	^ WEBHelper appTempFolder pathString
]

{ #category : #'as yet unclassified' }
WEBTempFile class >> extension: aString tempFolder: aPath [
	^self extension: aString tempFolder: aPath contentType: nil
]

{ #category : #'as yet unclassified' }
WEBTempFile class >> extension: aString tempFolder: aPath contentType: aMimeTypeString [
	^ self basicNew
		setTempDirectory: aPath;
		setFileExtension: aString;
		setContentType: aMimeTypeString;
		initialize;
		yourself
]

{ #category : #'as yet unclassified' }
WEBTempFile class >> html [
	^self basicNew
		setFileExtension: 'html';
		initialize;
		yourself
]

{ #category : #'as yet unclassified' }
WEBTempFile class >> newInFolder: aPath [
	^ self basicNew
		setTempDirectory: aPath;
		initialize;
		yourself
]

{ #category : #'as yet unclassified' }
WEBTempFile class >> pdf [
	^self basicNew
		setFileExtension: 'pdf';
		initialize;
		yourself
]

{ #category : #'as yet unclassified' }
WEBTempFile class >> pdfForXSendfile [
	^self extension: 'pdf' tempFolder: self defaultTempDirectory contentType: 'application/pdf'.
]

{ #category : #'as yet unclassified' }
WEBTempFile class >> zip [
	^self basicNew
		setFileExtension: 'zip';
		initialize;
		yourself
]

{ #category : #'as yet unclassified' }
WEBTempFile class >> zipForXSendfile [
	| instance |
	instance := self extension: 'zip' tempFolder: self defaultTempDirectory contentType: 'application/zip'.
	instance useSeparateFolder.
	^ instance
]

{ #category : #'submorphs-add/remove' }
WEBTempFile >> delete [
	self filePath asFileReference ensureDelete
]

{ #category : #'as yet unclassified' }
WEBTempFile >> directory [
	^self fileBasePath
]

{ #category : #'as yet unclassified' }
WEBTempFile >> ensureDirectoryExists [
	GRPlatform current ensureExistenceOfFolder: self directory
]

{ #category : #accessing }
WEBTempFile >> fileBaseName [
	^ fileBaseName
]

{ #category : #accessing }
WEBTempFile >> fileBasePath [
	^fileBasePath
]

{ #category : #'as yet unclassified' }
WEBTempFile >> fileExtension [
	^ fileExtension ifNil: [self class defaultFileExtension]
]

{ #category : #accessing }
WEBTempFile >> fileName [
	^ fileName
]

{ #category : #accessing }
WEBTempFile >> filePath [
	fileName ifBlank: [^'noname'].
	
	^fileBasePath, '/', fileName
]

{ #category : #initialization }
WEBTempFile >> initialize [
	super initialize.

	fileBaseName := UUID new asString.
	fileName := fileBaseName, '.', self fileExtension.
	fileBasePath := self tempDirectory asFileReference pathString.

"	file := (ServerFileDirectory on: fileFolder) forceNewFileNamed: self filePath."

]

{ #category : #initialization }
WEBTempFile >> setContentType: aContentType [
	contentType := aContentType
]

{ #category : #'as yet unclassified' }
WEBTempFile >> setFileExtension: aString [
	fileExtension := aString
]

{ #category : #'as yet unclassified' }
WEBTempFile >> setTempDirectory: aPath [
	tempDirectory := aPath
]

{ #category : #'as yet unclassified' }
WEBTempFile >> tempDirectory [
	^ tempDirectory ifNil: [self class defaultTempDirectory]
]

{ #category : #'as yet unclassified' }
WEBTempFile >> useSeparateFolder [
	fileBasePath := fileBasePath, '/', fileBaseName.
	self ensureDirectoryExists
]

{ #category : #writing }
WEBTempFile >> write: aText [

	GRPlatform current write: aText toFile: self fileName inFolder: self directory

]
