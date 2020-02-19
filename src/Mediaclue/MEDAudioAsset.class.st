Class {
	#name : #MEDAudioAsset,
	#superclass : #MEDMediaAsset,
	#instVars : [
		'fileReference'
	],
	#category : #'Mediaclue-Models'
}

{ #category : #'as yet unclassified' }
MEDAudioAsset class >> contentTypesAndExtensions [
	^{'audio/mpeg'. #(mpga mp2 mp2a mp3 m2a m3a).
	'audio/mp4'. #(m4a mp4a).
	'audio/x-wav'. #('wav').
	}

]

{ #category : #'as yet unclassified' }
MEDAudioAsset class >> displayName [
	^'Ton'
]

{ #category : #visiting }
MEDAudioAsset >> acceptVisitor: aVisitor [
	^ aVisitor visitAudioAsset: self
]

{ #category : #'as yet unclassified' }
MEDAudioAsset >> audioNameStart: aStart stop: aStop [
	"Creates a fragment in desired length in the same folder and answers the filename of it"
	| thumbnailSuffix |
	thumbnailSuffix := self buildFragmentStart: aStart stop: aStop.
	^self fileReference fileName, thumbnailSuffix.

]

{ #category : #'as yet unclassified' }
MEDAudioAsset >> audioUrl [
	^self urlBasePath, fileReference urlPath
]

{ #category : #'as yet unclassified' }
MEDAudioAsset >> audioUrlStart: aStart stop: aStop [
	^fileReference urlDirectory, '/', (self audioNameStart: aStart stop: aStop)
]

{ #category : #'as yet unclassified' }
MEDAudioAsset >> buildFragmentStart: aStart stop: aStop [
	^self buildFragmentStart: aStart stop: aStop inFolder: self fileReference directory
]

{ #category : #'as yet unclassified' }
MEDAudioAsset >> buildFragmentStart: aStart stop: aStop inFolder: aTargetFolder [
	"Creates a audio excerpt, if file does not exist yet."

	| file filepath audioFragmentFilepath cmd suffix startText stopText |
	
	startText := (aStart ifBlank: ['start']) greaseString.
	stopText := (aStop ifBlank: ['end']) greaseString.

	file := self fileReference.
	filepath := file filePath.
	suffix := '_', startText, '_', stopText, '.', file fileExtension.

	audioFragmentFilepath := aTargetFolder, '/', self fileReference fileName, suffix.

	audioFragmentFilepath asFileReference exists ifFalse: [
		cmd := String streamContents: [:s |
			s nextPutAll: 'ffmpeg -nostats -loglevel warning -y '.
			aStart ifNotBlank: [
				s nextPutAll: '-ss ', aStart greaseString].
			s nextPutAll: ' -i "', filepath, '" '.
			aStop ifNotBlank: [
				s nextPutAll: ' -t ', (aStop - (aStart ifNil: [0])) greaseString].
			s nextPutAll: ' -acodec copy "', audioFragmentFilepath, '"'].

		WEBSystemCommand run: cmd].

	^suffix
]

{ #category : #'as yet unclassified' }
MEDAudioAsset >> buildWaveformImage: previewName max: maxDimension path: aTargetFilePath [

	"Creates a video still image."
	| filepath cmd sizeOption |

	filepath := self fileReference filePath.
	sizeOption := 's=', maxDimension asString, 'x', (maxDimension//2) asString.

	cmd := 'ffmpeg -nostats -loglevel error -y -i "', filepath, '" -filter_complex "aformat=channel_layouts=mono,showwavespic=', sizeOption, '":colors=SkyBlue -frames:v 1 "', aTargetFilePath, '"'.

	WEBSystemCommand run: cmd
]

{ #category : #'as yet unclassified' }
MEDAudioAsset >> byteSize [
	^fileReference byteSize
]

{ #category : #'as yet unclassified' }
MEDAudioAsset >> cleanupAfterDeletion [
	super cleanupAfterDeletion.
	fileReference deleteFile
]

{ #category : #'as yet unclassified' }
MEDAudioAsset >> deleteTransformedMediaFiles [
	"TODO Fragments löschen?"
]

{ #category : #'as yet unclassified' }
MEDAudioAsset >> editorClass [
	^ MEDAudioEditor
]

{ #category : #'as yet unclassified' }
MEDAudioAsset >> fileName [
	^fileReference fileName
]

{ #category : #accessing }
MEDAudioAsset >> fileReference [
	^ fileReference
]

{ #category : #accessing }
MEDAudioAsset >> fileReference: anObject [
	fileReference := anObject.
	
	title := anObject title.
]

{ #category : #'as yet unclassified' }
MEDAudioAsset >> fileReferenceStart: aStart stop: aStop [
	| fr |
	
	fr := self fileReference copy.
	fr fileName: (self audioNameStart: aStart stop: aStop).
	
	^fr
]

{ #category : #testing }
MEDAudioAsset >> isAudio [
	^ true
]

{ #category : #'as yet unclassified' }
MEDAudioAsset >> location [
	^self audioUrl
]

{ #category : #'as yet unclassified' }
MEDAudioAsset >> mimeType [
	^fileReference contentType
]

{ #category : #'as yet unclassified' }
MEDAudioAsset >> viewerClass [
	^ MEDAudioViewer
]
