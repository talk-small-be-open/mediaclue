Class {
	#name : #MEDApplicationManager,
	#superclass : #WEBApplicationManager,
	#category : #'Mediaclue-Misc'
}

{ #category : #'as yet unclassified' }
MEDApplicationManager class >> beDevelopment [
	MEDDatabase development ifNil: [
		MEDDatabase
			createDevelopmentDatabase;
			useDevelopmentDatabase].

	self globalConfiguration
		appDomain: 'mediaclue';
		emailDomain: 'mediaclue.local';
		smtpServer: 'localhost';
		smtpUsername: '';
		smtpPassword: '';
		sysAdminEmailAddress: 'guru@you.com';
		assetsBasePath: (WEBHelper appMainFolder / 'media_storage') pathString;
		assetsUrlBasePath: '/m';
		previewsBasePath: (WEBHelper appMainFolder / 'preview_storage') pathString;
		previewsUrlBasePath: '/p';
		unwantedExifTags: self defaultUnwantedExifTags;
		organizationShortName: 'XY';
		organizationName: 'Schule XY';
		ldapServers: 'localhost';
		ldapBaseDn: '';
		ldapUser: '';
		ldapPassword: '';
		ldapUidField: 'uid';
		ldapCustomUidField: '';
		save.
]

{ #category : #'as yet unclassified' }
MEDApplicationManager class >> beProduction [
	MEDDatabase production ifNil: [
		MEDDatabase
			createProductionDatabase;
			useProductionDatabase].

	"Ein paar Defaultwerte einfüllen. Sollte vom Installerscript genauer gesetzt werden"
	self globalConfiguration
		appDomain: 'mediaclueproduction';
		emailDomain: 'mediaclueproduction';
		smtpServer: 'localhost';
		smtpUsername: '';
		smtpPassword: '';
		sysAdminEmailAddress: 'admin@your.domain.tld';
		assetsBasePath: '/opt/mediaclue/main/media_storage';
		assetsUrlBasePath: '/m';
		previewsBasePath: '/opt/mediaclue/main/preview_storage';
		previewsUrlBasePath: '/p';
		unwantedExifTags: self defaultUnwantedExifTags;
		organizationShortName: 'XY';
		organizationName: 'Schule XY';
		save.
]

{ #category : #'as yet unclassified' }
MEDApplicationManager class >> createAllMissingPreviews [
	| mongoQuery medias |

	mongoQuery := Dictionary new.

	mongoQuery at: 'previewImages' put: {
		'$exists'->true.
		'$size'->0.
	} asD.

	self db butler cleanupAggressive.

	"Take maximum of 50 at a time"
	medias := MEDMediaAsset selectMany: mongoQuery limit: 50.

	"Ignore those, who have no file, since they will loop endless"
	medias := medias select: [ :each | each isFileOnDiskOk ].
	
	"TODO: Prevent endless reiteration, if some media fails to generate previews.
	Maybe force stop this iteration on some condition? An admin can stop it through
	the web interface, though"

	medias ifNotBlank: [
		medias do: [ :each |
			each createPreviewsOffloaded.
			each readMetaDataOffloaded.
		].

		"Achtung iterativ rekursiv"
		self db butler doJob: 'Nächste 50 Vorschau-Medien holen' block: [ self createAllMissingPreviews ]
	]
]

{ #category : #'as yet unclassified' }
MEDApplicationManager class >> defaultUnwantedExifTags [
^ {
'FileName'.
'FileSize'.
'FileType'.
'FilePermissions'.
'Directory'.
'SourceFile'.
'ExifToolVersion'.
'MIMEType'.
'CRC'.
'Apple.*'.
'MatrixStructure'.
'.*Date'.
'.*Time'.
'GUID'.
'NextTrackID'.
}
]

{ #category : #'pharo-integration' }
MEDApplicationManager class >> ensureStartUpConditions [
	super ensureStartUpConditions.

	self installGermanConstants.
"	self ensureFixedTimeZone."
	self ensureSwissStartOfWeek.

	self isDevelopment ifFalse: [
		self ensureUnoconvServerIsRunning
	].

	self isDevelopment ifTrue: [
	].

]

{ #category : #'as yet unclassified' }
MEDApplicationManager class >> ensureUnoconvServerIsRunning [
	WEBSystemCommand runAsync: 'unset LD_LIBRARY_PATH && ', (WEBHelper cliToolsFolder pathString, '/unoconv --listener')
]

{ #category : #'pharo-integration' }
MEDApplicationManager class >> installDevelopmentSeasideComponents [
	| galleriesApp |
	super installDevelopmentSeasideComponents.

	galleriesApp := self installGalleriesApp.
	galleriesApp exceptionHandler: WADebugErrorHandler.

]

{ #category : #'pharo-integration' }
MEDApplicationManager class >> installGalleriesApp [
	| galleriesApp config |

	galleriesApp := MEDPublicGalleriesComponent registerAsApplication: 'galleries'.
	galleriesApp exceptionHandler: WEBEmailErrorHandler.
	galleriesApp configuration
		at: #maximumRelativeAge put: (60 * 30); "30 Minuten"
		at: #maximumAbsoluteAge put: (60 * 30). "30 Minuten"

	config := self globalConfiguration.

	"Email SMTP settings in Seaside settings übertragen"
	galleriesApp preferenceAt: #smtpServer put: config smtpServer.
	galleriesApp preferenceAt: #smtpUsername put: config smtpUsername.
	galleriesApp preferenceAt: #smtpPassword put: config smtpPassword.

	^galleriesApp
]

{ #category : #'pharo-integration' }
MEDApplicationManager class >> installProductionSeasideComponents [
	super installProductionSeasideComponents.

	self installGalleriesApp.
]

{ #category : #'as yet unclassified' }
MEDApplicationManager class >> loadDefaultData [
	self loadDefaultTags
]

{ #category : #'as yet unclassified' }
MEDApplicationManager class >> loadDefaultTags [
	self pi defaultSchoolSubjectNames do: [ :each |
		| tag |
		tag := MEDTag findOrCreateFromString: each.
		
		tag isSchoolSubject: true.
		tag save.
	]
]

{ #category : #'as yet unclassified' }
MEDApplicationManager class >> recreateAllPreviews [
	| todo |
	todo := MEDMediaAsset selectAll.

	self recreatePreviews: todo
]

{ #category : #'as yet unclassified' }
MEDApplicationManager class >> recreatePreviews: aTodoMediaCollection [
	| medias |

	self db butler cleanupAggressive.

	"Break the loop"
	aTodoMediaCollection ifBlank: [ ^ self ].

	"Take maximum of 50 at a time. Remove them in the todo-collection"
	aTodoMediaCollection size > 50
		ifTrue: [ medias := aTodoMediaCollection removeFirst: 50 ]
		ifFalse: [
			medias := aTodoMediaCollection copy.
			aTodoMediaCollection removeAll ].
	
	medias do: [ :each |
		each createPreviewsOffloaded.
		each readMetaDataOffloaded.
	].

	"Achtung iterativ rekursiv"
	self db butler doJob: 'Nächste 50 Vorschau-Medien holen' block: [
		self recreatePreviews: aTodoMediaCollection ]
]
