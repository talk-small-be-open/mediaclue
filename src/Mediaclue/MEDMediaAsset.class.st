Class {
	#name : #MEDMediaAsset,
	#superclass : #MEDModelObject,
	#traits : 'TMEDTaggable + TMEDProtected',
	#classTraits : 'TMEDTaggable classTrait + TMEDProtected classTrait',
	#instVars : [
		'title',
		'owner',
		'originDate',
		'metaData',
		'description',
		'source',
		'permissionType',
		'tagList',
		'previewImages',
		'uploadedDate',
		'readPermittedAuthorities',
		'writePermittedAuthorities'
	],
	#category : #'Mediaclue-Models'
}

{ #category : #'as yet unclassified' }
MEDMediaAsset class >> allFileExtensions [
	^self subclasses flatCollectAsSet: [ :each | each fileExtensions ]
]

{ #category : #'as yet unclassified' }
MEDMediaAsset class >> classByContentType: aContentType [
	| contentType |
	contentType := aContentType seasideMimeType.
	^self subclasses detect: [ :each | each contentTypes includes: contentType ] ifNone: [nil]
]

{ #category : #'as yet unclassified' }
MEDMediaAsset class >> contentTypes [
	^ self contentTypesAndExtensions pairsCollect: [ :mime :extensions | mime seasideMimeType ]
]

{ #category : #'as yet unclassified' }
MEDMediaAsset class >> contentTypesAndExtensions [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
MEDMediaAsset class >> displayName [
	^'Media'
]

{ #category : #'as yet unclassified' }
MEDMediaAsset class >> fileExtensions [
	^ (self contentTypesAndExtensions pairsCollect: [ :mime :extensions | extensions ]) flattened asSet
]

{ #category : #testing }
MEDMediaAsset class >> isVoyageRoot [
	^true
]

{ #category : #'as yet unclassified' }
MEDMediaAsset class >> takeFromFileReference: aFileReference [
	^self basicNew
		initializeFromFileReference: aFileReference;
		yourself
]

{ #category : #'as yet unclassified' }
MEDMediaAsset class >> takeFromTemporaryFileReference: aFileReference [
	^self basicNew
		initializeFromTemporaryFileReference: aFileReference;
		yourself
]

{ #category : #visiting }
MEDMediaAsset >> acceptVisitor: aVisitor [
	^ aVisitor visitMediaAsset: self
]

{ #category : #accessing }
MEDMediaAsset >> addPreviewImage: aPreviewImage [
	previewImages add: aPreviewImage
]

{ #category : #'as yet unclassified' }
MEDMediaAsset >> altitude [
	^ self metaDataAt: 'GPSAltitude'
]

{ #category : #'as yet unclassified' }
MEDMediaAsset >> byteSize [
	^0
]

{ #category : #'as yet unclassified' }
MEDMediaAsset >> cleanupAfterDeletion [
	previewImages do: [ :each | each delete ]
	"subclasses"
]

{ #category : #'as yet unclassified' }
MEDMediaAsset >> clearMetaData [
	metaData := Dictionary new 
]

{ #category : #'as yet unclassified' }
MEDMediaAsset >> clearPreviews [
	previewImages ifNotBlank: [
		previewImages do: [ :each | each delete ] ].

	previewImages := OrderedCollection new
]

{ #category : #'as yet unclassified' }
MEDMediaAsset >> createPreviewsOffloaded [
	MEDPreviewGenerator new
		media: self;
		generate
]

{ #category : #'submorphs-add/remove' }
MEDMediaAsset >> delete [
	self removeMeInAllMediaSets.
	self remove.
	self cleanupAfterDeletion.

]

{ #category : #accessing }
MEDMediaAsset >> description [
	^description
]

{ #category : #accessing }
MEDMediaAsset >> description: anObject [
	description := anObject
]

{ #category : #magritte }
MEDMediaAsset >> descriptionDescription [
	<magritteDescription>
	^ MAMemoDescription new
		accessor: #description;
		label: 'Beschreibung';
		lineCount: 1;
		yourself
]

{ #category : #magritte }
MEDMediaAsset >> descriptionMetaData [
"	<magritteDescription>
	^ MAMemoDescription new
		accessor: #metaData;
		label: 'Metadaten';
		beRequired;
		yourself"
]

{ #category : #magritte }
MEDMediaAsset >> descriptionOriginDate [
	<magritteDescription>
	"Mongo kennt nur Date+Time"
	^ WEBMaDateAndTimeDescription new
		accessor: #originDate;
		label: 'Datum des Ereignis';
		yourself
]

{ #category : #magritte }
MEDMediaAsset >> descriptionOriginalFilename [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #originalFilename;
		label: 'Originaler Dateiname';
		beReadonly;
		yourself
]

{ #category : #magritte }
MEDMediaAsset >> descriptionOwner [
	<magritteDescription>
	^ MEDMaSingleOptionDescription new
		optionsBlock: [ self db users ];
		accessor: #owner;
		label: 'Besitzer';
		beRequired;
		beReadonly;
		yourself
]

{ #category : #magritte }
MEDMediaAsset >> descriptionSource [
	<magritteDescription>
	^ MEDMaSingleOptionDescription new
		accessor: #source;
		optionsAndLabels: MEDHelper sourceIndicationList;
		label: 'Quelle/Copyright';
		beRequired;
		undefined: MEDHelper noValueLabel;
"		beRequired;"
		yourself
]

{ #category : #magritte }
MEDMediaAsset >> descriptionTitle [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #title;
		label: 'Titel';
		beRequired;
		yourself
]

{ #category : #magritte }
MEDMediaAsset >> descriptionUploadedDate [
	<magritteDescription>
	"Mongo kennt nur Date+Time"
	^ WEBMaDateAndTimeDescription new
		accessor: #uploadedDate;
		label: 'Hochgeladen am';
		yourself
]

{ #category : #accessing }
MEDMediaAsset >> displayName [
	^self class displayName, ': ', (self title ifBlank: ['noname']), ' (', (self fileName ifBlank: ['nofile']), ')'
]

{ #category : #'as yet unclassified' }
MEDMediaAsset >> downloadUrl [
	^nil
]

{ #category : #'as yet unclassified' }
MEDMediaAsset >> editorClass [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
MEDMediaAsset >> fileName [
	self subclassResponsibility
]

{ #category : #accessing }
MEDMediaAsset >> fileReference [
	self subclassResponsibility
]

{ #category : #accessing }
MEDMediaAsset >> fileReference: anObject [
	self subclassResponsibility
]

{ #category : #testing }
MEDMediaAsset >> hasGeoInformation [
	^ self longitude notNil and: [ self latitude notNil ]
]

{ #category : #testing }
MEDMediaAsset >> hasMetaData [
	^ metaData notBlank
]

{ #category : #testing }
MEDMediaAsset >> hasPreviewImages [
	^ previewImages notBlank
]

{ #category : #'as yet unclassified' }
MEDMediaAsset >> importMetaData: aDictionary [
	| dict |
	dict := aDictionary copy.
	self preprocessMetaData: dict.

	dict := self metaData union: dict.
	
	self metaData: dict
]

{ #category : #accessing }
MEDMediaAsset >> includingMediaSets [
	^ self db findMediaSetsIncludingMedia: self
]

{ #category : #initialization }
MEDMediaAsset >> initialize [

	super initialize.


]

{ #category : #initialization }
MEDMediaAsset >> initializeDefaultValues [

	super initializeDefaultValues.

	title ifNil: [ title := 'Unbenannt' ].

	previewImages ifNil: [ self clearPreviews ].
	
	readPermittedAuthorities ifNil: [ readPermittedAuthorities := OrderedCollection new ].
	writePermittedAuthorities ifNil: [ writePermittedAuthorities := OrderedCollection new ].
	tagList ifNil: [ tagList := Set new ].	

	metaData ifNil: [ self clearMetaData ]
]

{ #category : #'as yet unclassified' }
MEDMediaAsset >> initializeFromFileReference: aFileReference [
	self initialize.
	
	"Verschieben in eigenen Folder, damit Artefakte auch dort liegen"
	aFileReference moveToSubFolderNamed: (aFileReference fileName, '.d').
	self fileReference: aFileReference.
	
	self createPreviewsOffloaded.
	self readMetaDataOffloaded.
]

{ #category : #'as yet unclassified' }
MEDMediaAsset >> initializeFromTemporaryFileReference: aFileReference [
	| relativePath |
	self initialize.
	
	relativePath := (self uuidString first: 5), '/', (self uuidString, '.d').
	
	"Verschieben in eigenen Folder"
	aFileReference moveToFolderBase: self globalConfiguration assetsBasePath relative: relativePath.
	self fileReference: aFileReference.
	
	self createPreviewsOffloaded.
	self readMetaDataOffloaded.
]

{ #category : #testing }
MEDMediaAsset >> isAudio [
	^false
]

{ #category : #testing }
MEDMediaAsset >> isDocument [
	^false
]

{ #category : #testing }
MEDMediaAsset >> isImage [
	^false
]

{ #category : #testing }
MEDMediaAsset >> isVideo [
	^false
]

{ #category : #'as yet unclassified' }
MEDMediaAsset >> latitude [
	^ (self metaDataAt: 'GPSLatitude') ifNotNil: [ :t | t copyReplaceAll: ' deg' with: '°' ]
]

{ #category : #'as yet unclassified' }
MEDMediaAsset >> location [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
MEDMediaAsset >> longitude [
	^ (self metaDataAt: 'GPSLongitude') ifNotNil: [ :t | t copyReplaceAll: ' deg' with: '°' ]
]

{ #category : #accessing }
MEDMediaAsset >> metaData [
	^ metaData
]

{ #category : #accessing }
MEDMediaAsset >> metaData: anObject [
	metaData := anObject
]

{ #category : #accessing }
MEDMediaAsset >> metaDataAt: aKey [
	^ metaData at: aKey ifAbsent: [ nil ]
]

{ #category : #'as yet unclassified' }
MEDMediaAsset >> mimeType [
	^nil
]

{ #category : #accessing }
MEDMediaAsset >> originDate [
	^ originDate
]

{ #category : #accessing }
MEDMediaAsset >> originDate: anObject [
	originDate := anObject
]

{ #category : #accessing }
MEDMediaAsset >> originalFilename [
	^self fileReference title
]

{ #category : #accessing }
MEDMediaAsset >> owner [
	^ owner
]

{ #category : #accessing }
MEDMediaAsset >> owner: anObject [
	owner := anObject
]

{ #category : #'as yet unclassified' }
MEDMediaAsset >> partitionedPath [
"  # Liefert ein Pfad-Segment nach dem Muster 0000/0001/image.jpg
  def partitioned_path(*args)
    raise 'ID muss beim Pfad generieren vorhanden sein!' if id.nil?
    (%08d % id).scan(/..../) + args
  end
"
]

{ #category : #accessing }
MEDMediaAsset >> permissionType [
	^ permissionType ifBlank: [ #owner ]
]

{ #category : #accessing }
MEDMediaAsset >> permissionType: anObject [
	permissionType := anObject
]

{ #category : #'as yet unclassified' }
MEDMediaAsset >> pillarTemplateStrings [
	^#()
]

{ #category : #'as yet unclassified' }
MEDMediaAsset >> preprocessMetaData: aMetaData [

	"Entfernen von unerwünschten EXIF-Tags"
	self globalConfiguration unwantedExifTags do: [ :each |
		aMetaData keysAndValuesRemove: [ :tag :value |
			tag matchesRegexIgnoringCase: each
		]
	].

    "Entfernen von binären EXIF-Values"
    "Exiftool schreibt z.B. '(Binary data 93321 bytes, use -b option to extract)' wenn es ein Binärdatenfeld ist"
	aMetaData keysAndValuesRemove: [ :tag :value |
		value asString matchesRegexIgnoringCase: '^\(Binary data.*'
	].
    
	"Remove also second keyword tag. We don't want to have the tags in the meta data anymore"
	aMetaData removeKey: 'Subject' ifAbsent: [  ].

	"Auto-Verschlagwortung"
	"Schlagwörter setzen aus IPTC-Feld 'Keywords'"
	(aMetaData removeKey: 'Keywords' ifAbsent: [ nil ]) ifNotBlank: [ :string |
		self addTagsCommaSeparated: string ]
]

{ #category : #'as yet unclassified' }
MEDMediaAsset >> prettyFilename [
]

{ #category : #'as yet unclassified' }
MEDMediaAsset >> previewImageNamed: aName [
	^ previewImages detect: [ :each | each sizeName = aName ] ifNone: [ nil ]
]

{ #category : #'as yet unclassified' }
MEDMediaAsset >> previewImageUrl [
	^ self previewImageUrl: #thumbnail
]

{ #category : #'as yet unclassified' }
MEDMediaAsset >> previewImageUrl: aPreviewSizeName [
	^ (self previewImageNamed: aPreviewSizeName)
		ifNil: [ '/img/nopreview-', aPreviewSizeName, '.png' ]
		ifNotNil: #url
]

{ #category : #'as yet unclassified' }
MEDMediaAsset >> previewsPath [
	^self globalConfiguration previewsBasePath, '/', self fileReference fileRelativePath
]

{ #category : #'as yet unclassified' }
MEDMediaAsset >> readMetaDataOffloaded [
	self db butler doJob: ('Read Meta-Data ', self uuidString) block: [ self rereadMetaData ]
]

{ #category : #'as yet unclassified' }
MEDMediaAsset >> readPermittedAuthorities [
	^ readPermittedAuthorities
]

{ #category : #accessing }
MEDMediaAsset >> readPermittedAuthorities: anObject [
	readPermittedAuthorities := anObject
]

{ #category : #removing }
MEDMediaAsset >> removeMeInAllMediaSets [
	self includingMediaSets do: [ :each |
		each remove: self.
		each save ]
]

{ #category : #'as yet unclassified' }
MEDMediaAsset >> rereadMetaData [
	| tool dict |
	tool := MEDExiftool new.
	
	dict := tool read: self.

	self clearMetaData.
	self importMetaData: dict.
]

{ #category : #accessing }
MEDMediaAsset >> source [
	^ source
]

{ #category : #accessing }
MEDMediaAsset >> source: anObject [
	source := anObject
]

{ #category : #accessing }
MEDMediaAsset >> tagList [
	^ tagList
]

{ #category : #accessing }
MEDMediaAsset >> tagList: aCollection [
	tagList := aCollection
]

{ #category : #accessing }
MEDMediaAsset >> title [
	^ title
]

{ #category : #accessing }
MEDMediaAsset >> title: anObject [
	title := anObject
]

{ #category : #accessing }
MEDMediaAsset >> uploadedDate [
	^ uploadedDate
]

{ #category : #accessing }
MEDMediaAsset >> uploadedDate: anObject [
	uploadedDate := anObject
]

{ #category : #'as yet unclassified' }
MEDMediaAsset >> urlBasePath [
	^self globalConfiguration assetsUrlBasePath
]

{ #category : #accessing }
MEDMediaAsset >> urlToGoogleMaps [
	^ 'https://www.google.com/maps/search/?api=1&query={1},{2}' format: { self latitude urlEncoded. self longitude urlEncoded }
]

{ #category : #accessing }
MEDMediaAsset >> urlToOpenstreetmap [
	^ 'http://www.openstreetmap.org/?mlat={1}&mlon={2}&zoom=12' format: { self latitude urlEncoded. self longitude urlEncoded }
	

]

{ #category : #accessing }
MEDMediaAsset >> urlToWikimapia [
	^ 'http://wikimapia.org/#lat={1}&lon={2}&z=10&lang=de&m=w&v=2' format: { self latitude urlEncoded. self longitude urlEncoded }
	

]

{ #category : #'as yet unclassified' }
MEDMediaAsset >> viewerClass [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
MEDMediaAsset >> writePermittedAuthorities [
	^ writePermittedAuthorities
]

{ #category : #accessing }
MEDMediaAsset >> writePermittedAuthorities: anObject [
	writePermittedAuthorities := anObject
]
