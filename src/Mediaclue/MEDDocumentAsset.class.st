Class {
	#name : #MEDDocumentAsset,
	#superclass : #MEDMediaAsset,
	#instVars : [
		'fileReference',
		'previewPdf'
	],
	#category : #'Mediaclue-Models'
}

{ #category : #'as yet unclassified' }
MEDDocumentAsset class >> contentTypesAndExtensions [
	^{
'application/pdf'. #(pdf).
'application/msword'. #(doc dot).
'application/vnd.ms-excel'. #(xls xlm xla xlc xlt xlw).
'application/vnd.ms-powerpoint'. #(ppt pps pot).
'application/zip'. #(zip).
'application/x-zip'. #(zip).
'application/vnd.oasis.opendocument.text'. #(odt). "OpenOffice Text-Dokument"
'application/vnd.oasis.opendocument.spreadsheet'. #(ods).  "OpenOffice Tabellen-Dokument"
'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'. #(xlsx). "Excel XML"
'application/vnd.openxmlformats-officedocument.presentationml.slideshow'. #(ppsx). "PowerPoint XML"
'application/vnd.openxmlformats-officedocument.presentationml.presentation'. #(pptx). "PowerPoint XML"
'application/vnd.openxmlformats-officedocument.wordprocessingml.document'. #(docx). "Word XML"
}

]

{ #category : #'as yet unclassified' }
MEDDocumentAsset class >> displayName [
	^'Dokument'
]

{ #category : #visiting }
MEDDocumentAsset >> acceptVisitor: aVisitor [
	^ aVisitor visitDocumentAsset: self
]

{ #category : #'as yet unclassified' }
MEDDocumentAsset >> buildInsightImage: previewName max: maxDimension path: aTargetFilePath [
	| cmd |

	previewPdf ifNil: [ ^ self ].
	
	"Vom Preview PDF ein Bild machen"
	aTargetFilePath asFileReference parent ensureCreateDirectory.
	cmd := 'convert -background white -alpha remove -bordercolor white -border 1x1 -fuzz 5% -trim +repage -strip -resize "', maxDimension asString,'x', (maxDimension * 2) asString, '>" "', previewPdf fileReference filePath, '[0]" "', aTargetFilePath, '"'.

	WEBSystemCommand run: cmd
]

{ #category : #'as yet unclassified' }
MEDDocumentAsset >> buildPdfPath: aTargetPath [

	MEDHelper runUnoconv: '-e SelectPdfVersion=1 --output="', aTargetPath ,'" -f pdf "', self fileReference filePath, '"'
]

{ #category : #'as yet unclassified' }
MEDDocumentAsset >> cleanupAfterDeletion [
	super cleanupAfterDeletion.
	fileReference deleteFile.
	previewPdf delete
]

{ #category : #'as yet unclassified' }
MEDDocumentAsset >> editorClass [
	^ MEDDocumentEditor
]

{ #category : #'as yet unclassified' }
MEDDocumentAsset >> fileName [
	^fileReference fileName
]

{ #category : #accessing }
MEDDocumentAsset >> fileReference [
	^ fileReference
]

{ #category : #accessing }
MEDDocumentAsset >> fileReference: anObject [
	fileReference := anObject.
	
	title := anObject title.
]

{ #category : #testing }
MEDDocumentAsset >> isDocument [
	^ true
]

{ #category : #testing }
MEDDocumentAsset >> isPdf [
	^self mimeType = 'application/pdf'
]

{ #category : #testing }
MEDDocumentAsset >> isZip [
	^self mimeType = 'application/zip'
]

{ #category : #'as yet unclassified' }
MEDDocumentAsset >> location [
	^self urlBasePath, fileReference urlPath
]

{ #category : #'as yet unclassified' }
MEDDocumentAsset >> mimeType [
	^fileReference contentType
]

{ #category : #accessing }
MEDDocumentAsset >> previewPdf [
	^ previewPdf
]

{ #category : #accessing }
MEDDocumentAsset >> previewPdf: anObject [
	previewPdf := anObject
]

{ #category : #'as yet unclassified' }
MEDDocumentAsset >> viewerClass [
	^ MEDDocumentViewer
]
