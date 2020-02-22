Trait {
	#name : #TWEBGlobalHelpers,
	#category : #'Webbase-Main-Traits'
}

{ #category : #helpers }
TWEBGlobalHelpers classSide >> db [
	^WEBDatabase current
]

{ #category : #helpers }
TWEBGlobalHelpers classSide >> globalConfiguration [
	^self db globalConfiguration
]

{ #category : #helpers }
TWEBGlobalHelpers classSide >> isDemo [
	^self db isDemo
]

{ #category : #helpers }
TWEBGlobalHelpers classSide >> isDevelopment [
	^self db isDevelopment
]

{ #category : #helpers }
TWEBGlobalHelpers classSide >> isProduction [
	^self db isProduction
]

{ #category : #testing }
TWEBGlobalHelpers classSide >> isProductionOrAlike [
	^self isProduction or: [ self isStaging or: [ self isDemo ] ]
]

{ #category : #testing }
TWEBGlobalHelpers classSide >> isProductionOrStaging [
	^self isProduction or: [ self isStaging ]
]

{ #category : #testing }
TWEBGlobalHelpers classSide >> isStaging [
	^self db isStaging
]

{ #category : #logging }
TWEBGlobalHelpers classSide >> logDebug: aMessageText [
	self db logDebug: aMessageText
]

{ #category : #logging }
TWEBGlobalHelpers classSide >> logError: aMessageText [
	self db logError: aMessageText
]

{ #category : #logging }
TWEBGlobalHelpers classSide >> logInfo: aMessageText [
	self db logInfo: aMessageText
]

{ #category : #logging }
TWEBGlobalHelpers classSide >> logWarning: aMessageText [
	self db logWarning: aMessageText
]

{ #category : #helpers }
TWEBGlobalHelpers classSide >> mailer [
	^self db mailer
]

{ #category : #helpers }
TWEBGlobalHelpers classSide >> notifier [
	^self db notifier
]

{ #category : #helpers }
TWEBGlobalHelpers classSide >> pi [
	^WEBProjectInfo current
]

{ #category : #helpers }
TWEBGlobalHelpers >> db [
	^WEBDatabase current
]

{ #category : #helpers }
TWEBGlobalHelpers >> globalConfiguration [
	^self db globalConfiguration
]

{ #category : #helpers }
TWEBGlobalHelpers >> ifDemo: aBlock [
	^self isDemo ifTrue: aBlock
]

{ #category : #helpers }
TWEBGlobalHelpers >> ifDemoOrDevelopment: aBlock [
	^(self isDevelopment or: [self isDemo]) ifTrue: aBlock
]

{ #category : #helpers }
TWEBGlobalHelpers >> ifDevelopment: aBlock [
	^self isDevelopment ifTrue: aBlock
]

{ #category : #helpers }
TWEBGlobalHelpers >> ifDevelopment: aBlock else: anElseBlock [
	^self isDevelopment ifTrue: aBlock ifFalse: anElseBlock
]

{ #category : #helpers }
TWEBGlobalHelpers >> ifProduction: aBlock [
	^self isProduction ifTrue: aBlock
]

{ #category : #helpers }
TWEBGlobalHelpers >> ifProductionOrAlike: aBlock [
	^self isProductionOrAlike ifTrue: aBlock
]

{ #category : #helpers }
TWEBGlobalHelpers >> ifTesting: aBlock [
	^self isTesting ifTrue: aBlock
]

{ #category : #helpers }
TWEBGlobalHelpers >> isDemo [
	^self db isDemo
]

{ #category : #helpers }
TWEBGlobalHelpers >> isDevelopment [
	^self db isDevelopment
]

{ #category : #helpers }
TWEBGlobalHelpers >> isPeriodAware [
	^false
]

{ #category : #helpers }
TWEBGlobalHelpers >> isProduction [
	^self db isProduction
]

{ #category : #helpers }
TWEBGlobalHelpers >> isProductionOrAlike [
	^self isProduction or: [ self isStaging or: [ self isDemo ] ]
]

{ #category : #helpers }
TWEBGlobalHelpers >> isProductionOrStaging [
	^self isProduction or: [ self isStaging ]
]

{ #category : #helpers }
TWEBGlobalHelpers >> isStaging [
	^self db isStaging
]

{ #category : #helpers }
TWEBGlobalHelpers >> isTesting [
	^self db isTesting
]

{ #category : #logging }
TWEBGlobalHelpers >> logDebug: aMessageText [
	self db logDebug: aMessageText
]

{ #category : #logging }
TWEBGlobalHelpers >> logError: aMessageText [
	self db logError: aMessageText
]

{ #category : #logging }
TWEBGlobalHelpers >> logInfo: aMessageText [
	self db logInfo: aMessageText
]

{ #category : #logging }
TWEBGlobalHelpers >> logWarning: aMessageText [
	self db logWarning: aMessageText
]

{ #category : #helpers }
TWEBGlobalHelpers >> mailer [
	^self db mailer
]

{ #category : #helpers }
TWEBGlobalHelpers >> notifier [
	^self db notifier
]

{ #category : #helpers }
TWEBGlobalHelpers >> pi [
	"Project info"
	^WEBProjectInfo current
]
