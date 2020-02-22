Class {
	#name : #WEBApplicationManager,
	#superclass : #WEBObject,
	#category : #'Webbase-Main-Core'
}

{ #category : #'pharo-integration' }
WEBApplicationManager class >> activateBetatesting [
	| app |

	#('app' 'app-admin') do: [ :each |
		app := WAAdmin defaultDispatcher handlerAt: each.
		app exceptionHandler: WEBBetatestErrorHandler.
	]
]

{ #category : #'pharo-integration' }
WEBApplicationManager class >> activateDebugging [
	| app |

	#('app' 'app-admin') do: [ :each |
		app := WAAdmin defaultDispatcher handlerAt: each.
		app exceptionHandler: WADebugErrorHandler.
	]
]

{ #category : #deployment }
WEBApplicationManager class >> afterDeployment [
]

{ #category : #'as yet unclassified' }
WEBApplicationManager class >> beDevelopment [
]

{ #category : #'as yet unclassified' }
WEBApplicationManager class >> beProduction [
]

{ #category : #'as yet unclassified' }
WEBApplicationManager class >> cleanUpForDevelopment [
	"Entschlacken des Images für Server. Hm, ging nicht ohne Exceptions:"
	
	self isDevelopment ifTrue: [

		self cleanUpPharo.

		"Nicht-aggressives Cleanup in diversen Klassen."
		Smalltalk cleanUp: false.

		Smalltalk fixObsoleteReferences.

		"weiteres cleanup klassenseitig, undeclared etc."
		SmalltalkImage cleanUp.

		3 timesRepeat: [Smalltalk garbageCollect].

		Transcript cr; show: 'DEV Cleanup finished.'
	].
]

{ #category : #'instance creation' }
WEBApplicationManager class >> cleanUpForProduction [
	"Entschlacken des Images für Server. Hm, ging nicht ohne Exceptions:"
	
	self isProduction ifTrue: [
		
		self cleanUpPharo.
		
		"Einzelne Teile entnommen von ImageCleaner>>cleanUpForProduction"

		"trim MC ancestory information"
"old fashion. New ist Iceberg.		MCVersionInfo allInstances do: [ :each | each instVarNamed: 'ancestors' put: nil ]."

		3 timesRepeat: [Smalltalk garbageCollect].
		
		"delete logo"	
		PolymorphSystemSettings showDesktopLogo: false.
		
		"Aggressives Cleanup in diversen Klassen. Entfernt z.B. ChangeSets etc."
		Smalltalk cleanUp: true except: #() confirming: false.

		Smalltalk fixObsoleteReferences.
				
		"weiteres cleanup klassenseitig, undeclared etc."
		SmalltalkImage cleanUp.
		
		3 timesRepeat: [Smalltalk garbageCollect].
		
		Transcript cr; show: 'Cleanup finished.'
		
	].
]

{ #category : #'as yet unclassified' }
WEBApplicationManager class >> cleanUpPharo [
	FreeTypeCache cleanUp.
	Clipboard startUp: true.
	RubEditingState allInstances do: [ :each | each instVarNamed: #undoManager put:nil].
	GTPlayBook reset.
	EditorFindReplaceDialogWindow cleanUp.
	ActiveHand resetClickState; releaseAllFocus.
	UITheme current focusIndicator: nil.
	CairoBackendCache soleInstance flush.
	40 timesRepeat: [
		1 second wait.
		World doOneCycle.
	]. 

"	Smalltalk garbageCollect."
]

{ #category : #'pharo-integration' }
WEBApplicationManager class >> enableAutomation [
	Smalltalk addToStartUpList: self.
	Smalltalk addToShutDownList: self
]

{ #category : #'as yet unclassified' }
WEBApplicationManager class >> ensureExternalProcessWarmup [
	"Manchmal gab es Zombie-Prozesse und dies half dagegen"
	OSProcessAccessor initialize
]

{ #category : #'as yet unclassified' }
WEBApplicationManager class >> ensureFixedTimeZone [
	"OPTIMIZE: evt. direkt LocalTimeZone new nehmen, ohne fixed...,
	das braucht aber stets für den Offset ein primitives Aufruf, aber
	dadurch wären Sommerzeit/Winterzeit Übergänge ruckelfrei"
	DateAndTime localTimeZone: LocalTimeZone new asFixedTimeZone.

]

{ #category : #'pharo-integration' }
WEBApplicationManager class >> ensureStartUpConditions [
	self ensureExternalProcessWarmup.

	self isProduction ifTrue: [
"		self installPharoUiManager."
		self setMaxExternalSemaphores.
		
	].

	self isDevelopment ifTrue: [
		self setDevelopmentProcessEnvironment].
	
"	self ensureFixedTimeZone."
"	self ensureSwissStartOfWeek."

	self ensureTranscriptVisible.
]

{ #category : #'as yet unclassified' }
WEBApplicationManager class >> ensureSwissStartOfWeek [
	(Week dayNames includes: #Monday) ifTrue: [
		Week startDay: #Monday ].
	
	(Week dayNames includes: #Montag) ifTrue: [
		Week startDay: #Montag ].
]

{ #category : #'as yet unclassified' }
WEBApplicationManager class >> ensureTranscriptVisible [
	| label transcriptWindows |

	Smalltalk isHeadless ifTrue: [ ^self ].

	label := 'Log transcript'.
	transcriptWindows := UIManager default currentWorld windowsSatisfying: [ :each | each label = label ].
	transcriptWindows ifEmpty: [
		"OPTIMIZE: Hier gab es komische Effekte beim Aufstarten war das ein NonInteractiveTranscript"
		[ Smalltalk tools transcript openLabel: label ] ifError: [ "just continue, hmhm" ]
	]
]

{ #category : #installation }
WEBApplicationManager class >> install [
	self installProduction
]

{ #category : #installation }
WEBApplicationManager class >> installDemo [
	self installProduction.
	WEBDatabase switchProductionToDemo
]

{ #category : #installation }
WEBApplicationManager class >> installDevelopment [
	self installDevelopmentSeasideComponents.
	self installSmtpConfig.
	self db ensureAdminExists.
	self loadDefaultData.

	"Webserver starten"
	ZnZincServerAdaptor startOn: self pi seasideWebserverPort.
]

{ #category : #'pharo-integration' }
WEBApplicationManager class >> installDevelopmentSeasideComponents [
	| app runTaskApp admin config |

	app := self pi defaultFrontendMainTaskClass registerAsApplication.
	app exceptionHandler: WADebugErrorHandler.
	app configuration
		at: #maximumRelativeAge put: (60 * 60 * 1); "1 Stunden"
		at: #maximumAbsoluteAge put: (60 * 60 * 24 * 1). "1 Tage"

	WAAdmin defaultDispatcher defaultName: app name.

	admin := self pi defaultBackendMainTaskClass registerAsApplication.
	admin exceptionHandler: WADebugErrorHandler.
	admin configuration
		at: #maximumRelativeAge put: (60 * 60 * 1); "1 Stunden"
		at: #maximumAbsoluteAge put: (60 * 60 * 24 * 1). "1 Tage"

	"Registrieren von weiteren Hilfs-Handlers"
	runTaskApp := WEBRunTaskRequestHandler register.
	WEBPingRequestHandler register.
	WEBSessionKeepaliveRequestHandler register.

	config := self globalConfiguration.

	"Email SMTP settings in Seaside settings übertragen"
	{app. admin. runTaskApp}	do: [ :each |
		each preferenceAt: #smtpServer put: config smtpServer.
		each preferenceAt: #smtpUsername put: config smtpUsername.
		each preferenceAt: #smtpPassword put: config smtpPassword.
	]
]

{ #category : #'as yet unclassified' }
WEBApplicationManager class >> installGermanConstants [
	ChronologyConstants installGermanNames
]

{ #category : #installation }
WEBApplicationManager class >> installProduction [
	self installProductionSeasideComponents.

	"Bei korrektem Installieren sind die Seaside-Development Teile sowieso nicht existent,
	aber sicherheitshalber trotzdem:"
	self removeDevelopmentSeasideComponents.

	self enableAutomation.
	self installSmtpConfig.
	self db ensureAdminExists.
	self loadDefaultData.
	
"	db := ALDatabase current.
	configurator := db schoolConfigurator."

	"Erste Tasks durchführen, damit gewisse Dinge initialisiert werden"
"	configurator tasksClass runMinutelyTasks.
	configurator tasksClass runAllFiveMinutesTasks.
	configurator tasksClass timetablesPublish."
		
	"Webserver starten"
	ZnZincServerAdaptor startOn: self pi seasideWebserverPort.
]

{ #category : #'pharo-integration' }
WEBApplicationManager class >> installProductionSeasideComponents [
	| app runTaskApp admin config |

	app := self pi defaultFrontendMainTaskClass registerAsApplication.
	app exceptionHandler: WEBEmailErrorHandler.
	app configuration
		at: #maximumRelativeAge put: (60 * 60 * 4); "4 Stunden"
		at: #maximumAbsoluteAge put: (60 * 60 * 24 * 3). "3 Tage"

	WAAdmin defaultDispatcher defaultName: app name.

	admin := self pi defaultBackendMainTaskClass registerAsApplication.
	admin exceptionHandler: WEBEmailErrorHandler.
	admin configuration
		at: #maximumRelativeAge put: (60 * 60 * 4); "4 Stunden"
		at: #maximumAbsoluteAge put: (60 * 60 * 24 * 3). "3 Tage"

	"Registrieren von weiteren Hilfs-Handlers"
	runTaskApp := WEBRunTaskRequestHandler register.
	WEBPingRequestHandler register.
	WEBSessionKeepaliveRequestHandler register.

	config := self globalConfiguration.

	"Email SMTP settings in Seaside settings übertragen"
	{app. admin. runTaskApp}	do: [ :each |
		each preferenceAt: #smtpServer put: config smtpServer.
		each preferenceAt: #smtpUsername put: config smtpUsername.
		each preferenceAt: #smtpPassword put: config smtpPassword.
	]
]

{ #category : #installation }
WEBApplicationManager class >> installSmtpConfig [
	| apps server user password |

	apps := OrderedCollection new.
	apps add: (WAAdmin defaultDispatcher handlerAt: 'app').
	apps add: (WAAdmin defaultDispatcher handlerAt: 'app-admin').

	server := self globalConfiguration smtpServer.
	user := self globalConfiguration smtpUsername.
	password := self globalConfiguration smtpPassword.
	
	apps do: [:each |
		each preferenceAt: #smtpServer put: server.
		each preferenceAt: #smtpUsername put: user.
		each preferenceAt: #smtpPassword put: password.
	]
]

{ #category : #'as yet unclassified' }
WEBApplicationManager class >> loadDefaultData [
	"subclasses"
]

{ #category : #removing }
WEBApplicationManager class >> removeDevelopmentSeasideComponents [

	"Entfernen der Seaside Toolbar"
	WAAdmin developmentToolsEnabled ifTrue: [
		WAAdmin disableDevelopmentTools].
	
	"Unnötige Apps entfernen"
	WAAdmin
		unregister: 'config'; "Gefährliche App"
		unregister: 'browse';
		unregister: 'comet';
		unregister: 'examples';
		unregister: 'seaside';
		unregister: 'welcome';
		unregister: 'tools'.
		
	"Config application Passwort schützen"
"	configApp := WAAdmin defaultDispatcher handlerAt: 'config'.
	configApp configuration addParent: WAAuthConfiguration instance.
	configApp
		preferenceAt: #login put: 'andreas.brodbeck';
		preferenceAt: #passwordHash put: (GRPlatform current secureHashFor: '************');
		addFilter: WAAuthenticationFilter new."
]

{ #category : #initialization }
WEBApplicationManager class >> setDevelopmentProcessEnvironment [
	Smalltalk platform environment
		at: 'PATH'
		put: '/usr/local/bin:/usr/local/sbin:/opt/local/bin:/opt/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/mysql/bin'
]

{ #category : #initialization }
WEBApplicationManager class >> setMaxExternalSemaphores [
	"Normal ist 4096 und es muss 2-Potenz sein"
	Smalltalk vm maxExternalSemaphoresSilently: 8192
]

{ #category : #'pharo-integration' }
WEBApplicationManager class >> shutDown: isQuitting [
"	lastImageSavedAt := DateAndTime now."
	isQuitting ifTrue: [
"		Transcript show: 'Called Shutdown-Handler'."
		]
]

{ #category : #'pharo-integration' }
WEBApplicationManager class >> startUp: isComingUp [
	isComingUp ifTrue: [
		self logInfo: 'Called Startup-Handler'.
		self ensureStartUpConditions.
		
"		self isProduction ifTrue: [
			self restoreLastBackupIfNewer]]"
	]
]

{ #category : #installation }
WEBApplicationManager class >> update [
	self updateProduction
]

{ #category : #installation }
WEBApplicationManager class >> updateProduction [
	self pi defaultDataMigratorClass migrate
]
