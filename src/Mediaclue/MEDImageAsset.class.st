Class {
	#name : #MEDImageAsset,
	#superclass : #MEDMediaAsset,
	#instVars : [
		'fileReference'
	],
	#category : #'Mediaclue-Models'
}

{ #category : #'as yet unclassified' }
MEDImageAsset class >> contentTypesAndExtensions [
^{
'image/jpeg'. #(jpeg jpg jpe).
'image/png'. #(png).
'image/gif'. #(gif).
'image/tiff'. #(tif tiff).
'image/vnd.adobe.photoshop'. #(psd).
}
]

{ #category : #'as yet unclassified' }
MEDImageAsset class >> displayName [
	^'Bild'
]

{ #category : #visiting }
MEDImageAsset >> acceptVisitor: aVisitor [
	^ aVisitor visitImageAsset: self
]

{ #category : #'as yet unclassified' }
MEDImageAsset >> buildScaledImageWidth: aWidth height: aHeight [

	^ self buildScaledImageWidth: aWidth height: aHeight inFolder: self previewsPath.
]

{ #category : #'as yet unclassified' }
MEDImageAsset >> buildScaledImageWidth: aWidth height: aHeight inFolder: aTargetFolder [
	"Scales and converts a thumbnail file, with ImageMagick, if file does not exist yet."

	| fileRef scaledImageFilepath suffix |

	fileRef := self fileReference.
	suffix := '_', aWidth asString, '_', aHeight asString, '.', (fileRef fileExtension).

	scaledImageFilepath := aTargetFolder, '/', fileRef fileName, suffix.

	self buildScaledImageWidth: aWidth height: aHeight path: scaledImageFilepath.

	^suffix
]

{ #category : #'as yet unclassified' }
MEDImageAsset >> buildScaledImageWidth: aWidth height: aHeight path: aTargetFilePath [
	"Scales and converts a thumbnail file, with ImageMagick, if file does not exist yet."
	| cmd quality pixels |
	
	quality := '95'.
	
	"If small image, we want display speed"
	pixels := MEDPreviewGenerator pixelDimensionFor: #medium.
	aWidth <= pixels ifTrue: [ quality := '80' ]. 

	aTargetFilePath asFileReference exists ifTrue: [ ^ self ].

	aTargetFilePath asFileReference parent ensureCreateDirectory.

	cmd := 'convert -quality ', quality, ' -auto-orient -background white -alpha remove -bordercolor white -border 1x1 -fuzz 5% -trim +repage -strip -resize "', aWidth asString,'x', aHeight asString, '>" "', self fileReference filePath, '" "', aTargetFilePath, '"'.

	WEBSystemCommand run: cmd
]

{ #category : #'as yet unclassified' }
MEDImageAsset >> byteSize [
	^fileReference byteSize
]

{ #category : #'as yet unclassified' }
MEDImageAsset >> cleanupAfterDeletion [
	super cleanupAfterDeletion.
	fileReference deleteFile
]

{ #category : #'as yet unclassified' }
MEDImageAsset >> editorClass [
	^ MEDImageEditor
]

{ #category : #'as yet unclassified' }
MEDImageAsset >> fileName [
	^fileReference fileName
]

{ #category : #accessing }
MEDImageAsset >> fileReference [
	^ fileReference
]

{ #category : #accessing }
MEDImageAsset >> fileReference: anObject [
	fileReference := anObject.
	
	title := anObject title.
]

{ #category : #'as yet unclassified' }
MEDImageAsset >> imageNameMaxWidth: aMaxWidth maxHeight: aMaxHeight [
	"Creates a thumbnail in desired maximum dimension in the same folder and answers the filename of it"
	| thumbnailSuffix |
	thumbnailSuffix := self buildScaledImageWidth: aMaxWidth height: aMaxHeight.
	^self fileReference fileName, thumbnailSuffix.

]

{ #category : #'as yet unclassified' }
MEDImageAsset >> imageUrl [
	^self urlBasePath, fileReference urlPath
]

{ #category : #'as yet unclassified' }
MEDImageAsset >> imageUrlWidth: aMaxWidth height: aMaxHeight [
	^self globalConfiguration previewsUrlBasePath, '/', self fileReference fileRelativePath, '/', (self imageNameMaxWidth: aMaxWidth maxHeight: aMaxHeight)
]

{ #category : #testing }
MEDImageAsset >> isImage [
	^ true
]

{ #category : #'as yet unclassified' }
MEDImageAsset >> location [
	^self imageUrl
]

{ #category : #'as yet unclassified' }
MEDImageAsset >> mimeType [
	^fileReference contentType
]

{ #category : #'as yet unclassified' }
MEDImageAsset >> pillarTemplateStrings [
	^{
	'+caption>', self uuidString, '|width=50+'.
	'+', self uuidString, '+'.
	'+', self uuidString, '|width=50+'.
	}
]

{ #category : #'as yet unclassified' }
MEDImageAsset >> rotate: aDegreesInteger [
	"Rotates the original picture"
	| cmd |
	
	cmd := 'mogrify -rotate "', aDegreesInteger asString,'" "', self fileReference filePath, '"'.

	WEBSystemCommand run: cmd.
	
	self createPreviewsOffloaded
]

{ #category : #'as yet unclassified' }
MEDImageAsset >> rotateLeft [
	self rotate: -90

]

{ #category : #'as yet unclassified' }
MEDImageAsset >> rotateRight [
	self rotate: 90

]

{ #category : #'as yet unclassified' }
MEDImageAsset >> viewerClass [
	^ MEDImageViewer
]
