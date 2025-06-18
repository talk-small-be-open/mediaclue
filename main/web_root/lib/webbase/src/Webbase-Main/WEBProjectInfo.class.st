"
Normally I am subclassed for the project.

I represent static information about the concrete project which is made with the Webbase framework. I define classes and other stuff to get the code bootstrapped.

I do NOT hold dynamic information about the installation of the application (aka customer settings), which is done in the WEBConfiguration class structure.
"
Class {
	#name : #WEBProjectInfo,
	#superclass : #Object,
	#classVars : [
		'Current'
	],
	#category : #'Webbase-Main-Core'
}

{ #category : #'as yet unclassified' }
WEBProjectInfo class >> bootstrapMyNewProject: aNameString code: aCodeString [
	| piClass |
	"Package erstellen"
	
	"ProjectInfo Klasse erstellen"
	piClass := self createProjectSubclassOf: self namespace: aCodeString package: aNameString.

	piClass current bootstrapMyNewProject: aNameString code: aCodeString

]

{ #category : #accessing }
WEBProjectInfo class >> clear [
	Current := nil
]

{ #category : #'as yet unclassified' }
WEBProjectInfo class >> concreteClassOf: aClass [
	aClass allSubclasses ifNotEmpty: [ :ss | ^ss last ].
	^aClass
	
]

{ #category : #'as yet unclassified' }
WEBProjectInfo class >> createProjectSubclassOf: aClass namespace: aNamespaceString package: aPackageString [
	| basename |
	basename := aClass name allButFirst: 3.

	^self createProjectSubclassOf: aClass namespace: aNamespaceString package: aPackageString basename: basename
]

{ #category : #'as yet unclassified' }
WEBProjectInfo class >> createProjectSubclassOf: aClass namespace: aNamespaceString package: aPackageString basename: aBasenameString [
	| className |
	className := (aNamespaceString asUppercase, aBasenameString) asSymbol.

	^(Smalltalk hasClassNamed: className)
		ifTrue: [ Smalltalk classNamed: className ]
		ifFalse: [
			aClass subclass: className
				instanceVariableNames: ''
				classVariableNames: ''
				package: aPackageString]
]

{ #category : #accessing }
WEBProjectInfo class >> current [
	Current ifNil: [ Current := (self concreteClassOf: self) new ].
	^Current
]

{ #category : #'as yet unclassified' }
WEBProjectInfo >> bootstrapMyNewProject: aNameString code: aCodeString [
	"TODO: Die neu erstellten Klassen in die Methoden default...Class einbauen, statt
	den automatischen Mechanismus zu belassen"
	
	self class createProjectSubclassOf: self defaultDatabaseBaseClass namespace: aCodeString package: aNameString basename: 'Database'.
	
	"Subklassen erstellen: WEBComponent, WEBDatabase, WEBModelObject ..."
	"OPTIMIZE: Einfache alle abstract Klassen automatisch nehmen?"
	{ WEBObject.
	WEBModelObject. WEBComponent. WEBTasks.
	WEBDataMigrator. WEBGarbageCollector. WEBError. WEBHelper. WEBMailer.
	WEBButler. WEBMainDecoration. WEBLightbox. WEBHtmlCanvas.
	WEBFrontendMainTask. WEBBackendMainTask.
	WEBFrontendSession. WEBBackendSession.
	WEBApplicationManager.
	} do: [ :each |
		self class createProjectSubclassOf: each namespace: aCodeString package: aNameString.
	].
	
	"Trait Users erstellen: TWEBConfiguration, TWEBGlobalConfiguration"
]

{ #category : #'as yet unclassified' }
WEBProjectInfo >> concreteClassOf: aClass [
	^self class concreteClassOf: aClass
]

{ #category : #'as yet unclassified' }
WEBProjectInfo >> concreteInstanceOf: aClass [
	^ (self concreteClassOf: aClass) new
]

{ #category : #'as yet unclassified' }
WEBProjectInfo >> defaultAdminLoggedInMainComponentClass [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WEBProjectInfo >> defaultAdminPublicMainComponentClass [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WEBProjectInfo >> defaultBackendMainTaskClass [
	^self concreteClassOf: WEBBackendMainTask
]

{ #category : #'as yet unclassified' }
WEBProjectInfo >> defaultBackendSessionClass [
	^self concreteClassOf: WEBBackendSession
]

{ #category : #'as yet unclassified' }
WEBProjectInfo >> defaultButlerClass [
	^self concreteClassOf: WEBButler
]

{ #category : #'as yet unclassified' }
WEBProjectInfo >> defaultDataMigratorClass [
	^self concreteClassOf: WEBDataMigrator
]

{ #category : #'as yet unclassified' }
WEBProjectInfo >> defaultDatabaseBaseClass [
	^WEBDatabase
]

{ #category : #'as yet unclassified' }
WEBProjectInfo >> defaultFrontendMainTaskClass [
	^self concreteClassOf: WEBFrontendMainTask
]

{ #category : #'as yet unclassified' }
WEBProjectInfo >> defaultFrontendSessionClass [
	^self concreteClassOf: WEBFrontendSession
]

{ #category : #'as yet unclassified' }
WEBProjectInfo >> defaultGarbageCollectorClass [
	^ self concreteClassOf: WEBGarbageCollector
]

{ #category : #'as yet unclassified' }
WEBProjectInfo >> defaultGlobalConfigurationClass [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WEBProjectInfo >> defaultHtmlCanvasClass [
	^self concreteClassOf: WEBHtmlCanvas
]

{ #category : #'as yet unclassified' }
WEBProjectInfo >> defaultIdentityProviderClass [
	^self concreteClassOf: WEBLocalIdentityProvider
]

{ #category : #'as yet unclassified' }
WEBProjectInfo >> defaultLightboxClass [
	^self concreteClassOf: WEBLightbox
]

{ #category : #'as yet unclassified' }
WEBProjectInfo >> defaultLoggedInMainComponentClass [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WEBProjectInfo >> defaultMailerClass [
	^self concreteClassOf: WEBMailer
]

{ #category : #'as yet unclassified' }
WEBProjectInfo >> defaultMainDecorationClass [
	^self concreteClassOf: WEBMainDecoration
]

{ #category : #'as yet unclassified' }
WEBProjectInfo >> defaultPdfGeneratorClass [
	^self concreteClassOf: WEBPdfGenerator
]

{ #category : #'as yet unclassified' }
WEBProjectInfo >> defaultPublicMainComponentClass [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WEBProjectInfo >> defaultTasksClass [
	^self concreteClassOf: WEBTasks
]

{ #category : #'as yet unclassified' }
WEBProjectInfo >> defaultUserClass [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WEBProjectInfo >> logoRelativePath [
	^'/images/logo.png'
]

{ #category : #'as yet unclassified' }
WEBProjectInfo >> projectCode [
	^self projectShortName withoutSeparators asLowercase
]

{ #category : #'as yet unclassified' }
WEBProjectInfo >> projectName [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WEBProjectInfo >> projectPrefix [
	^self className first: 3
]

{ #category : #'as yet unclassified' }
WEBProjectInfo >> projectShortName [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WEBProjectInfo >> seasideWebserverPort [
	^8085
]
