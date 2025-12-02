Class {
	#name : #MEDUploadCockpitComponent,
	#superclass : #MEDComponent,
	#instVars : [
		'uploadingMediaSet',
		'incomingMediaAssets',
		'plUploader',
		'mediaRenderer'
	],
	#category : #'Mediaclue-View'
}

{ #category : #'as yet unclassified' }
MEDUploadCockpitComponent class >> into: aMediaSet [
	^ self basicNew
		setUploadingMediaSet: aMediaSet;
		initialize;
		yourself
]

{ #category : #hooks }
MEDUploadCockpitComponent >> children [
	^Array with: plUploader
]

{ #category : #testing }
MEDUploadCockpitComponent >> hasExistingMedias [
	^ uploadingMediaSet isEmpty not
]

{ #category : #testing }
MEDUploadCockpitComponent >> hasLotsOfUploadedMedias [
	^ self hasUploadedMedias and: [ incomingMediaAssets size > 20 ]
]

{ #category : #testing }
MEDUploadCockpitComponent >> hasMedias [
	^ self hasExistingMedias or: [ self hasUploadedMedias ]
]

{ #category : #testing }
MEDUploadCockpitComponent >> hasUploadedMedias [
	^ incomingMediaAssets notBlank
]

{ #category : #initialization }
MEDUploadCockpitComponent >> incomingUpload: aFileReference [
	| asset assetClass |
	assetClass := MEDMediaAsset classByContentType: aFileReference contentType.
	assetClass ifNotNil: [
		asset := assetClass takeFromTemporaryFileReference: aFileReference.
		asset
			owner: self currentUser;
			uploadedDate: (DateAndTime now);
			save.
			
		uploadingMediaSet add: asset.
		incomingMediaAssets add: asset.

		uploadingMediaSet save ]
]

{ #category : #initialization }
MEDUploadCockpitComponent >> incomingUploads: aCollection [
	aCollection ifNotBlank: [
		aCollection do: [:each |
			self incomingUpload: each ] ]
]

{ #category : #initialization }
MEDUploadCockpitComponent >> initialize [
	super initialize.
	
	incomingMediaAssets := OrderedCollection new.
	mediaRenderer := (MEDMediaRenderer component: self)
		beNoSelect;
		yourself.
	
	"Security double check"
	self session canUpload ifTrue: [
		self initializeUploader ]
]

{ #category : #initialization }
MEDUploadCockpitComponent >> initializeUploader [

	plUploader := WEBPlUploadComponent new
		targetBasePath: (MEDHelper appTempFolder pathString);
		targetRelativePath: 'uploadCockpit';
		title: nil;
		dragDropMessage: 'Medien oder Ordner hierhin ziehen oder ...';
		onUpload: [ :each | self incomingUpload: each ];
		maxFileSizeBytes: self globalConfiguration maxFileSizeBytes;
		maxFileUploads: self globalConfiguration maxUploadSeriesFilesCount;
		extensionsList: (MEDMediaAsset allFileExtensions sorted joinUsing: ',');
		beEmbedded;
		yourself.
	
"	plUploader onAnswer: [ :answerCollection |
		answerCollection ifNotBlank: [
			self incomingUploads: answerCollection ] ]"
]

{ #category : #'as yet unclassified' }
MEDUploadCockpitComponent >> preexistingMedias [
	^ uploadingMediaSet medias copyWithoutAll: incomingMediaAssets
]

{ #category : #rendering }
MEDUploadCockpitComponent >> renderButtonToolbarOn: html [
	html buttonToolbar: [
		html buttonGroup: [ 
			self currentPortfolio uploading = uploadingMediaSet ifTrue: [
				self hasMedias ifTrue: [ 
					html anchorButtonPrimary
						callback: [ self saveAsNewMediaSet ];
						with: 'Speichern, als neue Kollektion']
			].
			html anchorButton
				callback: [ self close ];
				with: 'Schliessen'.

		]]
]

{ #category : #rendering }
MEDUploadCockpitComponent >> renderContentOn: html [
	html pageHeader: 'Hochladen'.
	html pageBody: [

		html render: plUploader.

		self renderButtonToolbarOn: html.
		
		self renderMediasOn: html.
		self renderExistingMediasOn: html.

"		html anchorButton
			callback: [ self showUploader ];
			with: 'Medien auswählen ...'."
		self hasLotsOfUploadedMedias ifTrue: [
			self renderButtonToolbarOn: html ].
"	html small: 'Bereits hochgeladene Dateien bleiben erhalten'"

	]
]

{ #category : #rendering }
MEDUploadCockpitComponent >> renderExistingMediasOn: html [
	self preexistingMedias ifNotEmpty: [ :medias |
		html pageSubheader: 'Bereits vorhandene Medien:'.
		html div class: 'existingMedias'; with: [
			medias do: [ :each |
				html thumbnail: each ] ] ]
]

{ #category : #rendering }
MEDUploadCockpitComponent >> renderMediasOn: html [
	self hasUploadedMedias ifTrue: [ 
		html pageSubheader: 'Hochgeladene Medien:'.
		html div class: 'uploadedMedias'; with: [
			incomingMediaAssets do: [ :each |
				mediaRenderer renderOneliner: each on: html ] ] ]
]

{ #category : #actions }
MEDUploadCockpitComponent >> saveAsNewMediaSet [
	| editor |

	uploadingMediaSet
		title: 'Unbenannt - Letzter Import';
		owner: (self currentUser);
		createdAt: (DateAndTime now);
		save.
		
	self currentPortfolio newUploading.
	
	editor := ((MEDMediaSetEditor mediaSet: uploadingMediaSet)
		beWithBulkOperations;
		beOverwriteMediaProperties;
		yourself).

"nicht mehr 	editor beWithMedias."
		
	self show: editor onAnswer: [
		self session announceDataChange.
		self close
	]

]

{ #category : #initialization }
MEDUploadCockpitComponent >> setUploadingMediaSet: aMediaSet [
	uploadingMediaSet := aMediaSet
]
