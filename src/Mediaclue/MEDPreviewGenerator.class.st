Class {
	#name : #MEDPreviewGenerator,
	#superclass : #MEDObject,
	#traits : 'TMEDVisitor',
	#classTraits : 'TMEDVisitor classTrait',
	#instVars : [
		'media',
		'previewNames',
		'instructionsBase'
	],
	#category : #'Mediaclue-Misc'
}

{ #category : #'as yet unclassified' }
MEDPreviewGenerator class >> pixelDimensionFor: aSizeName [
	"Liefert die maximale Pixel-Grösse eines Preview-Typs"
	| data |
	
	"TODO: Evt. diese instructions in die globalConfig reinnehmen?"
	
	data := self new instructionsBase detect: [ :each | each first = aSizeName ] ifNone: [ ^0 ].
	
	^ data second

]

{ #category : #'as yet unclassified' }
MEDPreviewGenerator >> convertAudioToThumbnail: previewName max: maxDimension [
	| filename imageThumbnail fileReference |
	
	filename := media fileReference fileName , '_waveform_', previewName, '.jpg'.

	fileReference := WEBLocalFileReference new
			fileBasePath: self globalConfiguration previewsBasePath;
			fileRelativePath: media fileReference fileRelativePath;
			fileName: filename;
"			title: (row at: 7);"
			yourself.
	
	imageThumbnail := MEDPreviewImage new
		fileReference: fileReference;
		sizeName: previewName;
		sizePx: maxDimension;
		yourself.
		
	"Offloading"
	self offload: 'Audio Waveform erzeugen' do: [
		fileReference pharoFileReference parent ensureCreateDirectory.
		fileReference pharoFileReference ensureDelete.
		media buildWaveformImage: previewName max: maxDimension path: fileReference filePath.
	].
  
	media addPreviewImage: imageThumbnail
]

{ #category : #'as yet unclassified' }
MEDPreviewGenerator >> convertDocumentToPdf [
	| filename previewPdf fileReference |
	
	filename := media fileReference fileName , '_preview.pdf'.

	fileReference := WEBLocalFileReference new
			fileBasePath: self globalConfiguration previewsBasePath;
			fileRelativePath: media fileReference fileRelativePath;
			fileName: filename;
"			title: (row at: 7);"
			yourself.
	
	previewPdf := MEDPreviewPdf new
		fileReference: fileReference;
		yourself.
		
	"Offloading"
	self offload: 'Dokument in PDF konvertieren' do: [
		| tempFile inputPdf |
		fileReference pharoFileReference parent ensureCreateDirectory.
		fileReference pharoFileReference ensureDelete.

		inputPdf := media isPdf
			ifTrue: [ media fileReference filePath ]
			ifFalse: [
				tempFile := WEBTempFile pdf.
				media buildPdfPath: tempFile filePath.
				tempFile filePath
			].

		"PDF normalisieren"
		"OPTIMIZE: Eigentlich cat 1-3, aber wenn das File weniger 3 Seiten hat, dann gibts Error"
		MEDHelper runPdftkInputs: { inputPdf } commands: ('cat output ', fileReference filePath)
	].
  
	media previewPdf: previewPdf
]

{ #category : #'as yet unclassified' }
MEDPreviewGenerator >> convertDocumentToThumbnail: previewName max: maxDimension [
	| filename imageThumbnail fileReference |
	
	filename := media fileReference fileName , '_insight_', previewName, '.jpg'.

	fileReference := WEBLocalFileReference new
			fileBasePath: self globalConfiguration previewsBasePath;
			fileRelativePath: media fileReference fileRelativePath;
			fileName: filename;
"			title: (row at: 7);"
			yourself.
	
	imageThumbnail := MEDPreviewImage new
		fileReference: fileReference;
		sizeName: previewName;
		sizePx: maxDimension;
		yourself.
		
	"Offloading"
	self offload: 'Dokument Einblick erzeugen' do: [
		fileReference pharoFileReference parent ensureCreateDirectory.
		fileReference pharoFileReference ensureDelete.
		media buildInsightImage: previewName max: maxDimension path: fileReference filePath.
	].
  
	media addPreviewImage: imageThumbnail
]

{ #category : #'as yet unclassified' }
MEDPreviewGenerator >> convertImageToThumbnail: previewName max: maxDimension [
	| filename imageThumbnail fileReference |
	
	filename := media fileReference fileName, self randomAntiCacheFragment, previewName, '.jpg'.

	fileReference := WEBLocalFileReference new
			fileBasePath: self globalConfiguration previewsBasePath;
			fileRelativePath: media fileReference fileRelativePath;
			fileName: filename;
"			title: (row at: 7);"
			yourself.
	
	imageThumbnail := MEDPreviewImage new
		fileReference: fileReference;
		sizeName: previewName;
		sizePx: maxDimension;
		yourself.
		
	"Offloading"
	self offload: 'Bild skalieren (force)' do: [
		fileReference pharoFileReference parent ensureCreateDirectory.
		fileReference pharoFileReference ensureDelete.
		media buildScaledImageWidth: maxDimension height: (maxDimension * 2) path: fileReference filePath
	].
  
	media addPreviewImage: imageThumbnail
]

{ #category : #'as yet unclassified' }
MEDPreviewGenerator >> convertVideoToThumbnail: previewName max: maxDimension [
	| filename imageThumbnail fileReference |
	
	filename := media fileReference fileName , '_stillframe_', previewName, '.jpg'.

	fileReference := WEBLocalFileReference new
			fileBasePath: self globalConfiguration previewsBasePath;
			fileRelativePath: media fileReference fileRelativePath;
			fileName: filename;
"			title: (row at: 7);"
			yourself.
	
	imageThumbnail := MEDPreviewImage new
		fileReference: fileReference;
		sizeName: previewName;
		sizePx: maxDimension;
		yourself.
		
	"Offloading"
	self offload: 'Video Standbild erzeugen' do: [
		fileReference pharoFileReference parent ensureCreateDirectory.
		fileReference pharoFileReference ensureDelete.
		media buildPosterImage: previewName max: maxDimension path: fileReference filePath.
	].
  
	media addPreviewImage: imageThumbnail
]

{ #category : #translating }
MEDPreviewGenerator >> generate [
	media clearPreviews.
	media acceptVisitor: self
]

{ #category : #initialization }
MEDPreviewGenerator >> initialize [
	super initialize.

	instructionsBase := #(
		#(thumbnail 85)
		#(small 150)
		#(medium 350)
		#(large 800)
		#(xlarge 1200)
		#(pdfslideshow 1400)
	).

	previewNames := instructionsBase collect: [ :each | each first ]
]

{ #category : #accessing }
MEDPreviewGenerator >> instructionsBase [
	^ instructionsBase
]

{ #category : #accessing }
MEDPreviewGenerator >> media [
	^ media
]

{ #category : #accessing }
MEDPreviewGenerator >> media: anObject [
	media := anObject
]

{ #category : #'as yet unclassified' }
MEDPreviewGenerator >> offload: aNameString do: aBlock [
	self db butler doJob: aNameString block: aBlock
]

{ #category : #'as yet unclassified' }
MEDPreviewGenerator >> previewInstructions [
	^instructionsBase select: [ :each | previewNames includes: each first ]
]

{ #category : #translating }
MEDPreviewGenerator >> previewNames: aCollection [
	previewNames := aCollection
]

{ #category : #'as yet unclassified' }
MEDPreviewGenerator >> randomAntiCacheFragment [
	| chars |

	"(($0 to: $9), ($a to: $z)) asString"
	chars := #($0 $1 $2 $3 $4 $5 $6 $7 $8 $9 $a $b $c $d $e $f $g $h $i $j $k $l $m $n $o $p $q $r $s $t $u $v $w $x $y $z).

	^ String streamContents: [ :s |
		s nextPut: $_.
		4 timesRepeat: [ s nextPut: chars atRandom ].
		s nextPut: $_.
	]
	
]

{ #category : #visiting }
MEDPreviewGenerator >> visitAudioAsset: anObject [
	self previewInstructions do: [ :each |
		self convertAudioToThumbnail: each first max: each second].

	anObject save
]

{ #category : #visiting }
MEDPreviewGenerator >> visitDocumentAsset: aDocument [
	self convertDocumentToPdf.
	self previewInstructions do: [ :each |
		self convertDocumentToThumbnail: each first max: each second.
	].

	aDocument save
]

{ #category : #visiting }
MEDPreviewGenerator >> visitImageAsset: anObject [
	self previewInstructions do: [ :each |
		self convertImageToThumbnail: each first max: each second].
	
	anObject save
"      @generated_previews << convert_image_to_thumbnail('thumbnail', 85) if all or preview_names.include?('thumbnail')
      @generated_previews << convert_image_to_thumbnail('small', 150) if all or preview_names.include?('small')
      @generated_previews << convert_image_to_thumbnail('medium', 350) if all or preview_names.include?('medium')
      @generated_previews << convert_image_to_thumbnail('big', 800) if all or preview_names.include?('big')
      @generated_previews << convert_image_to_thumbnail('pdfslideshow', 1400) if all or preview_names.include?('pdfslideshow')
    self.cleanup"

]

{ #category : #visiting }
MEDPreviewGenerator >> visitMediaAsset: anObject [
	"do nothing"
]

{ #category : #visiting }
MEDPreviewGenerator >> visitVideoAsset: anObject [
	self previewInstructions do: [ :each |
		self convertVideoToThumbnail: each first max: each second].

	anObject save
]
