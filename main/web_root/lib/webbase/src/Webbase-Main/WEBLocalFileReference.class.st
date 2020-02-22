Class {
	#name : #WEBLocalFileReference,
	#superclass : #WEBFileReference,
	#instVars : [
		'fileBasePath',
		'fileRelativePath',
		'fileName'
	],
	#category : #'Webbase-Main-Misc'
}

{ #category : #'instance creation' }
WEBLocalFileReference class >> fromPath: aString [
	| fileReference |
	fileReference := aString asFileReference.
	
	^ self new
		fileBasePath: fileReference parent pathString;
		fileRelativePath: nil;
		fileName: fileReference basename;
		yourself
]

{ #category : #'file menu action' }
WEBLocalFileReference >> deleteFile [
	self pharoFileReference ensureDelete
]

{ #category : #'as yet unclassified' }
WEBLocalFileReference >> directory [
	fileRelativePath ifBlank: [^self fileBasePath].
	
	^ self fileBasePath, '/', fileRelativePath
]

{ #category : #'as yet unclassified' }
WEBLocalFileReference >> fileBasePath [
	^fileBasePath
]

{ #category : #accessing }
WEBLocalFileReference >> fileBasePath: anObject [
	fileBasePath := anObject
]

{ #category : #accessing }
WEBLocalFileReference >> fileExtension [
	^self fileName asFileReference extension
]

{ #category : #accessing }
WEBLocalFileReference >> fileName [
	^ fileName
]

{ #category : #accessing }
WEBLocalFileReference >> fileName: anObject [
	fileName := anObject
]

{ #category : #'as yet unclassified' }
WEBLocalFileReference >> filePath [
	fileName ifBlank: [^'noname'].
	
	fileRelativePath ifBlank: [^self fileBasePath, '/', fileName].

	^self fileBasePath, '/', fileRelativePath, '/', fileName
]

{ #category : #accessing }
WEBLocalFileReference >> fileRelativePath [
	^ fileRelativePath
]

{ #category : #accessing }
WEBLocalFileReference >> fileRelativePath: anObject [
	fileRelativePath := anObject
]

{ #category : #testing }
WEBLocalFileReference >> isFileDefined [
	"Prüfe, ob die minimal Angaben vorhanden sind"
	^fileName notBlank and: [fileBasePath notBlank]
]

{ #category : #testing }
WEBLocalFileReference >> isFileExisting [
	^self isFileDefined and: [
		| ref |
		ref := self pharoFileReference.
		ref isFile and: [ref exists]]
]

{ #category : #'as yet unclassified' }
WEBLocalFileReference >> moveToFolderBase: aBasePath relative: aRelativePath [
	| source target |

	source := self pharoFileReference.
	target := (aBasePath, '/', aRelativePath).
	FileSystem disk ensureCreateDirectory: target.

	source moveTo: (target, '/', source basename) asFileReference.

	self fileBasePath: aBasePath.
	self fileRelativePath: aRelativePath.
]

{ #category : #'as yet unclassified' }
WEBLocalFileReference >> moveToSubFolderNamed: aString [
	self moveToFolderBase: self fileBasePath relative: (self fileRelativePath, '/', aString)
]

{ #category : #'as yet unclassified' }
WEBLocalFileReference >> path [
	^self filePath
]

{ #category : #accessing }
WEBLocalFileReference >> pharoFileReference [
	^self filePath asFileReference
]

{ #category : #'as yet unclassified' }
WEBLocalFileReference >> readContentType [
	contentType := WEBHelper readContentTypeOfFile: self path
]

{ #category : #'as yet unclassified' }
WEBLocalFileReference >> readFileSize [
	byteSize := [self pharoFileReference size] ifError: [0]
]

{ #category : #'as yet unclassified' }
WEBLocalFileReference >> title [
	^super title ifNil: [self fileName]
]

{ #category : #'as yet unclassified' }
WEBLocalFileReference >> urlDirectory [
"	^'http://', self db domain, '/', self fileRelativePath, '/', self fileName"
	self fileRelativePath ifBlank: [^''].
	
	^String streamContents: [:s |
		(self fileRelativePath first = $/) ifFalse: [
			s nextPut: $/].
		s nextPutAll: self fileRelativePath.
		]

]

{ #category : #'as yet unclassified' }
WEBLocalFileReference >> urlPath [
"	^'http://', self db domain, '/', self fileRelativePath, '/', self fileName"
	
	"Robustness"
	self fileName ifBlank: [^''].
	
	^String streamContents: [:s |
		s nextPutAll: self urlDirectory.
		s nextPut: $/.
		s nextPutAll: self fileName
		]

]
