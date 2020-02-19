Class {
	#name : #MEDVideoAsset,
	#superclass : #MEDMediaAsset,
	#instVars : [
		'fileReference',
		'aspectRatio',
		'width',
		'duration'
	],
	#category : #'Mediaclue-Models'
}

{ #category : #'as yet unclassified' }
MEDVideoAsset class >> contentTypesAndExtensions [
	^{'video/quicktime'. #(qt mov).
	'video/mpeg'. #(mpeg mpg mpe m1v m2v).
	'video/mp4'. #(mp4 mp4v mpg4).
	'video/x-m4v'. #(m4v).
	}
]

{ #category : #'as yet unclassified' }
MEDVideoAsset class >> displayName [
	^'Film'
]

{ #category : #visiting }
MEDVideoAsset >> acceptVisitor: aVisitor [
	^ aVisitor visitVideoAsset: self
]

{ #category : #'as yet unclassified' }
MEDVideoAsset >> aspectRatio [
	aspectRatio ifNil: [
		| cmd output |
		cmd := 'mediainfo --Inform="Video;%DisplayAspectRatio%" "', fileReference path, '"'.
		output := (WEBSystemCommand fetch: cmd).
"		output := output copyReplaceAll: ':' with: '/'."
		aspectRatio := Number readFrom: output].

	^aspectRatio
]

{ #category : #'as yet unclassified' }
MEDVideoAsset >> aspectRatio: aValue [
	aspectRatio := aValue
]

{ #category : #'as yet unclassified' }
MEDVideoAsset >> buildFragmentStart: aStart stop: aStop [
	^self buildFragmentStart: aStart stop: aStop inFolder: self fileReference directory
]

{ #category : #'as yet unclassified' }
MEDVideoAsset >> buildFragmentStart: aStart stop: aStop inFolder: aTargetFolder [
	"Creates a video excerpt, if file does not exist yet."

	| file filepath videoFragmentFilepath cmd suffix startText stopText |
	
	startText := (aStart ifBlank: ['start']) greaseString.
	stopText := (aStop ifBlank: ['end']) greaseString.

	file := self fileReference.
	filepath := file filePath.
	suffix := '_', startText, '_', stopText, '.', file fileExtension.

	videoFragmentFilepath := aTargetFolder, '/', self fileReference fileName, suffix.

	videoFragmentFilepath asFileReference exists ifFalse: [
		cmd := String streamContents: [:s |
			s nextPutAll: 'ffmpeg -nostats -loglevel warning -y '.
			aStart ifNotBlank: [
				s nextPutAll: '-ss ', aStart greaseString].
			s nextPutAll: ' -i "', filepath, '" '.
			aStop ifNotBlank: [
				s nextPutAll: ' -t ', (aStop - (aStart ifNil: [0])) greaseString].
			s nextPutAll: ' -vcodec copy -acodec copy "', videoFragmentFilepath, '"'].

		WEBSystemCommand run: cmd].

	^suffix
]

{ #category : #'as yet unclassified' }
MEDVideoAsset >> buildPosterImage: previewName max: maxDimension path: aTargetFilePath [

	"Creates a video still image."
	| filepath cmd sizeOption |

	filepath := self fileReference filePath.
	sizeOption := '-vf scale=w=', maxDimension asString, ':h=', maxDimension asString, ':force_original_aspect_ratio=decrease'.

	cmd := 'ffmpeg -nostats -loglevel warning -y -i "', filepath, '" -ss 0 -vframes 200 -vf thumbnail=200 ', sizeOption,' "', aTargetFilePath, '"'.
	WEBSystemCommand run: cmd
]

{ #category : #'as yet unclassified' }
MEDVideoAsset >> byteSize [
	^fileReference byteSize
]

{ #category : #'as yet unclassified' }
MEDVideoAsset >> cleanupAfterDeletion [
	super cleanupAfterDeletion.
	fileReference deleteFile
]

{ #category : #'as yet unclassified' }
MEDVideoAsset >> deleteTransformedMediaFiles [
	
]

{ #category : #'as yet unclassified' }
MEDVideoAsset >> downloadUrl [
	^nil "TODO fileReference url"
]

{ #category : #'as yet unclassified' }
MEDVideoAsset >> duration [
	"Duration of movie in seconds"
	duration ifNil: [
		| cmd output |
		cmd := 'mediainfo --Inform="Video;%Duration%" "', fileReference path, '"'.
		output := (WEBSystemCommand fetch: cmd).
		duration := (Number readFrom: output) / 1000].

	^duration
]

{ #category : #'as yet unclassified' }
MEDVideoAsset >> editorClass [
	^ MEDVideoEditor
]

{ #category : #'as yet unclassified' }
MEDVideoAsset >> fileName [
	^fileReference fileName
]

{ #category : #accessing }
MEDVideoAsset >> fileReference [
	^ fileReference
]

{ #category : #accessing }
MEDVideoAsset >> fileReference: anObject [
	fileReference := anObject.
	
	title := anObject title.
]

{ #category : #'as yet unclassified' }
MEDVideoAsset >> fileReferenceStart: aStart stop: aStop [
	| fr |
	
	fr := self fileReference copy.
	fr fileName: (self videoNameStart: aStart stop: aStop).
	
	^fr
]

{ #category : #testing }
MEDVideoAsset >> isVideo [
	^ true
]

{ #category : #'as yet unclassified' }
MEDVideoAsset >> location [
	^self videoUrl
]

{ #category : #'as yet unclassified' }
MEDVideoAsset >> mimeType [
	^fileReference contentType
]

{ #category : #'as yet unclassified' }
MEDVideoAsset >> posterFileName [
	"Robustness"
	self fileReference fileName ifBlank: [^''].

	^self fileReference fileName, '.jpg'
]

{ #category : #'as yet unclassified' }
MEDVideoAsset >> posterUrl [
	^self fileReference urlDirectory, '/', self posterFileName
]

{ #category : #'as yet unclassified' }
MEDVideoAsset >> previewImageUrl [
	^self posterUrl
]

{ #category : #'as yet unclassified' }
MEDVideoAsset >> videoNameStart: aStart stop: aStop [
	"Creates a fragment in desired length in the same folder and answers the filename of it"
	| thumbnailSuffix |
	thumbnailSuffix := self buildFragmentStart: aStart stop: aStop.
	^self fileReference fileName, thumbnailSuffix.

]

{ #category : #'as yet unclassified' }
MEDVideoAsset >> videoUrl [
	^self urlBasePath, fileReference urlPath
]

{ #category : #'as yet unclassified' }
MEDVideoAsset >> videoUrlStart: aStart stop: aStop [
	^fileReference urlDirectory, '/', (self videoNameStart: aStart stop: aStop)
]

{ #category : #'as yet unclassified' }
MEDVideoAsset >> viewerClass [
	^ MEDVideoViewer
]

{ #category : #'as yet unclassified' }
MEDVideoAsset >> width [
	width ifNil: [
		| cmd output |
		(fileReference isKindOf: WEBLocalFileReference) ifTrue: [
			cmd := 'mediainfo --Inform="Video;%Width%" "', fileReference path, '"'.
			output := (WEBSystemCommand fetch: cmd).
			width := output asInteger]].

	^width
]
