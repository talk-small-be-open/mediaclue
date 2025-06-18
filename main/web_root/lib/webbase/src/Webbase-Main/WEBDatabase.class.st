Class {
	#name : #WEBDatabase,
	#superclass : #WEBObject,
	#instVars : [
		'mailer',
		'butler',
		'globalConfiguration',
		'trash',
		'identityProvider'
	],
	#classVars : [
		'Current',
		'Demo',
		'Development',
		'Production',
		'Staging',
		'Testing'
	],
	#category : #'Webbase-Main-Database'
}

{ #category : #'as yet unclassified' }
WEBDatabase class >> createDevelopmentDatabase [

"	Current destroyDataRepository."
	"->	repository dropDatabase.
	VORepository current cache flush."

	
	Development := self new.
]

{ #category : #'as yet unclassified' }
WEBDatabase class >> createProductionDatabase [
	Production := self new.
]

{ #category : #'as yet unclassified' }
WEBDatabase class >> createTestingDatabase [
	Testing := self new.
]

{ #category : #accessing }
WEBDatabase class >> current [
	^Current
]

{ #category : #'as yet unclassified' }
WEBDatabase class >> destroyDevelopmentDatabase [

	Development := nil
]

{ #category : #'as yet unclassified' }
WEBDatabase class >> destroyProductionDatabase [

	(UIManager default confirm: 'Really destroy production database ?!?!?!?!') ifTrue: [
		Production := nil ]
]

{ #category : #'as yet unclassified' }
WEBDatabase class >> destroyTestingDatabase [

	Testing := nil
]

{ #category : #accessing }
WEBDatabase class >> development [
	^Development
]

{ #category : #accessing }
WEBDatabase class >> production [
	^Production
]

{ #category : #'as yet unclassified' }
WEBDatabase class >> switchProductionToDemo [
	Demo := Production.
	Current := Demo.
	Production := nil.
	
	Current instVarNamed: 'identityProvider' put: WEBLocalIdentityProvider new.
]

{ #category : #'as yet unclassified' }
WEBDatabase class >> useDatabase: aDatabase [
	Current := aDatabase
]

{ #category : #'as yet unclassified' }
WEBDatabase class >> useDevelopmentDatabase [
	self useDatabase: Development
]

{ #category : #'as yet unclassified' }
WEBDatabase class >> useProductionDatabase [
	self useDatabase: Production
]

{ #category : #'as yet unclassified' }
WEBDatabase class >> useTestingDatabase [
	self useDatabase: Testing
]

{ #category : #initialization }
WEBDatabase >> addAllToTrash: aCollection [
	trash addAll: aCollection
]

{ #category : #accessing }
WEBDatabase >> addApplicationCommand: aSystemCommand [
	self subclassResponsibility
]

{ #category : #initialization }
WEBDatabase >> addToTrash: aCollection [
	trash addIfNotPresent: aCollection
]

{ #category : #accessing }
WEBDatabase >> butler [
	^butler
]

{ #category : #'as yet unclassified' }
WEBDatabase >> ensureAdminExists [
]

{ #category : #'as yet unclassified' }
WEBDatabase >> ensureIdentityProvider [
	| type provider |
	type := self globalConfiguration identityProviderType.

	"Poor man solution, but KISS"
	type = 'ldap' ifTrue: [ provider := self pi concreteInstanceOf: WEBLdapIdentityProvider ].
	type = 'local' ifTrue: [ provider := self pi concreteInstanceOf: WEBLocalIdentityProvider ].

	"default"
	provider ifNil: [
		provider := self pi defaultIdentityProviderClass new
	].
	
	self db identityProvider: provider
]

{ #category : #finders }
WEBDatabase >> findApplicationCommandByCode: aString [
	self subclassResponsibility
]

{ #category : #finders }
WEBDatabase >> findUserByUserIdentifier: aString [
	^ self findUserByUsername: aString
]

{ #category : #finders }
WEBDatabase >> findUserByUsername: aString [
	self subclassResponsibility
]

{ #category : #accessing }
WEBDatabase >> globalConfiguration [
	^ globalConfiguration
]

{ #category : #accessing }
WEBDatabase >> identityProvider [
	^ identityProvider
]

{ #category : #accessing }
WEBDatabase >> identityProvider: anObject [
	identityProvider := anObject
]

{ #category : #initialization }
WEBDatabase >> initializeDefaultValues [
	super initializeDefaultValues.

	mailer ifNil: [ mailer := self pi defaultMailerClass new ].
	butler ifNil: [ butler := self pi defaultButlerClass new ].
	trash ifNil: [ trash := OrderedCollection new ].
	identityProvider ifNil: [ identityProvider := self pi defaultIdentityProviderClass new ]
]

{ #category : #initialization }
WEBDatabase >> initializeGlobalConfiguration [
	globalConfiguration ifNil: [
		globalConfiguration := self pi defaultGlobalConfigurationClass new]
]

{ #category : #testing }
WEBDatabase >> isDemo [
	^self == Demo
]

{ #category : #testing }
WEBDatabase >> isDevelopment [
	^self == Development
]

{ #category : #testing }
WEBDatabase >> isProduction [
	^self == Production
]

{ #category : #testing }
WEBDatabase >> isStaging [
	^self == Staging
]

{ #category : #testing }
WEBDatabase >> isTesting [
	^self == Testing
]

{ #category : #logging }
WEBDatabase >> logDebug: aMessageText [
	| text |
	
	self isDevelopment ifFalse: [ ^self ].
	
	text := '[DEBUG] ', aMessageText greaseString.
	
	self simpleLogText: text

"	LoggingEvent category: #general level: #info message: aMessageText"
]

{ #category : #logging }
WEBDatabase >> logError: aMessageText [
	| text |
	text := '[ERROR] ', aMessageText greaseString.
	
	self simpleLogText: text

"	LoggingEvent category: #general level: #info message: aMessageText"
]

{ #category : #logging }
WEBDatabase >> logInfo: aMessageText [
	| text |
	text := '[INFO] ', aMessageText greaseString.
	
	self simpleLogText: text

"	LoggingEvent category: #general level: #info message: aMessageText"
]

{ #category : #logging }
WEBDatabase >> logWarning: aMessageText [
	| text |
	text := '[WARNING] ', aMessageText greaseString.
	
	self simpleLogText: text

"	LoggingEvent category: #general level: #info message: aMessageText"
]

{ #category : #accessing }
WEBDatabase >> mailer [
	^mailer
]

{ #category : #logging }
WEBDatabase >> simpleLogText: aTextString [
	| text |

"	isEnabledLog ifFalse: [^self]."

	text := DateAndTime now printString, ' ', aTextString.

	Transcript show: text; cr.
]

{ #category : #'as yet unclassified' }
WEBDatabase >> trashedObjects [
	^ trash copy
]

{ #category : #accessing }
WEBDatabase >> users [
	self subclassResponsibility
]
