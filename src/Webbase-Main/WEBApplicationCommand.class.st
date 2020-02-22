"
I am an abstract class for commands to the (GUI-) application. ApplicationCommands can be executed, typically through the unique URL of that command.

IMPORTANT: In the executeOnApplication methods you should not use any seaside calls, since this will lead to ""task not delegated"" errors from within the main task.
"
Class {
	#name : #WEBApplicationCommand,
	#superclass : #WEBModelObject,
	#instVars : [
		'code',
		'createdAt',
		'user',
		'maxExecutions',
		'executionsCount',
		'isAutologin',
		'isLoginRequired',
		'params',
		'isLogoutRequired'
	],
	#category : #'Webbase-Main-Core'
}

{ #category : #'instance creation' }
WEBApplicationCommand class >> fromCode: aString [
	"Factory method. Either instantiate from the String, if it contains all the information, or find a predefined"

	"TODO: Simplify this, with encryption and decryption into a single string for the URL. We dont need to store everything in the DB!"
	^self db findApplicationCommandByCode: aString
]

{ #category : #testing }
WEBApplicationCommand class >> isVoyageRoot [
	^true
]

{ #category : #'instance creation' }
WEBApplicationCommand class >> lifetimeDuration [
	^24 hours
]

{ #category : #'as yet unclassified' }
WEBApplicationCommand >> beAutologin [
	isLoginRequired := true.
	isAutologin := true
]

{ #category : #'as yet unclassified' }
WEBApplicationCommand >> beLoginNotRequired [
	isLoginRequired := false
]

{ #category : #'as yet unclassified' }
WEBApplicationCommand >> beLoginRequired [
	isLoginRequired := true
]

{ #category : #'as yet unclassified' }
WEBApplicationCommand >> beSingleExecutable [
	maxExecutions := 1
]

{ #category : #'as yet unclassified' }
WEBApplicationCommand >> beUnlimitedExecutable [
	maxExecutions := nil
]

{ #category : #accessing }
WEBApplicationCommand >> clearParams [
	params := nil
]

{ #category : #'as yet unclassified' }
WEBApplicationCommand >> code [
	^code
]

{ #category : #'as yet unclassified' }
WEBApplicationCommand >> dictionaryToParams: aDictionary [
	"Dictionary {x->aaa y->bbb} gets to String x:aaa:y:bbb"

	^String streamContents: [:stream |
		aDictionary associations do: [:assoc |
			| key value |
			key := assoc key.
			value := assoc value.
			stream nextPutAll: key greaseString.
			stream nextPut: $/. 
			stream nextPutAll: value greaseString]
			separatedBy: [
				stream nextPut: $/]]
]

{ #category : #'as yet unclassified' }
WEBApplicationCommand >> executeOnApplication: anApplicationComponent currentUser: anObject [
	self increaseExecutionCounter
]

{ #category : #'as yet unclassified' }
WEBApplicationCommand >> expirationDate [
	^createdAt + self lifetimeDuration
]

{ #category : #testing }
WEBApplicationCommand >> hasParam: aKey [
	params ifNil: [^false].
	^params includesKey: aKey
]

{ #category : #testing }
WEBApplicationCommand >> hasParams [
	^params isEmptyOrNil not
]

{ #category : #testing }
WEBApplicationCommand >> hasUser [
	^user notNil
]

{ #category : #'as yet unclassified' }
WEBApplicationCommand >> ifHasParam: aKey then: aBlock [
	^(self hasParam: aKey) ifTrue: [aBlock value: (self paramAt: aKey)]
]

{ #category : #'as yet unclassified' }
WEBApplicationCommand >> increaseExecutionCounter [
	executionsCount := executionsCount + 1
]

{ #category : #initialization }
WEBApplicationCommand >> initialize [
	super initialize.
	createdAt := DateAndTime now.
	code := UUID new asString asSymbol.
	self beSingleExecutable.
	executionsCount := 0.
	isAutologin := false.
	self beLoginNotRequired
]

{ #category : #testing }
WEBApplicationCommand >> isAutologin [
	^isAutologin = true
]

{ #category : #testing }
WEBApplicationCommand >> isExecutable [
	^self isExpired not and: [self isMaxExecutionsReached not]
]

{ #category : #testing }
WEBApplicationCommand >> isExpired [
	^self isExpiredAtDateTime: DateAndTime now
]

{ #category : #testing }
WEBApplicationCommand >> isExpiredAtDateTime: aDateAndTime [  
	^self expirationDate < aDateAndTime
]

{ #category : #testing }
WEBApplicationCommand >> isLoginRequired [
	^isLoginRequired = true
]

{ #category : #testing }
WEBApplicationCommand >> isLogoutRequired [
	^isLogoutRequired = true
]

{ #category : #testing }
WEBApplicationCommand >> isMaxExecutionsReached [
	^maxExecutions notNil and: [executionsCount >= maxExecutions]
]

{ #category : #'as yet unclassified' }
WEBApplicationCommand >> lifetimeDuration [
	^self class lifetimeDuration
]

{ #category : #accessing }
WEBApplicationCommand >> paramAt: aKey [
	params ifNil: [^false].
	^params at: aKey
]

{ #category : #accessing }
WEBApplicationCommand >> paramAt: aKey put: aValue [
	params ifNil: [params := Dictionary new].
	params at: aKey put: aValue
]

{ #category : #'as yet unclassified' }
WEBApplicationCommand >> paramsString [
	params ifNil: [^''].
	
	^self dictionaryToParams: params
]

{ #category : #'as yet unclassified' }
WEBApplicationCommand >> paramsString: aString [
	params := self paramsToDictionary: aString.
]

{ #category : #'as yet unclassified' }
WEBApplicationCommand >> paramsToDictionary: aParamsString [
	"x:aaa:y:bbb gets to Dictionary {x->aaa y->bbb}"
	| tokens |
	tokens := aParamsString findTokens: '/'.

	^Dictionary newFromPairs: tokens.
]

{ #category : #'as yet unclassified' }
WEBApplicationCommand >> prepareExecution [
	"Runs before the command is beeing executed. You can put some preparation code in here, 
	before the command will go through the command execution steps."
]

{ #category : #testing }
WEBApplicationCommand >> store [
	self save
]

{ #category : #'as yet unclassified' }
WEBApplicationCommand >> uiLanguage [
	"Within a command we might guess a best language for displaying errors and the like. Overwrite this in subclasses for better results"
	^self hasUser
		ifTrue: [self user preferredLanguage]
		ifFalse: [self db defaultLanguage]
]

{ #category : #accessing }
WEBApplicationCommand >> url [
	| commandVar paramsVar |
	commandVar := 'c=', code greaseString.
	
	paramsVar := self urlParamsFragment.
	paramsVar ifNotEmpty: [paramsVar := '&', paramsVar].
	
	^self globalConfiguration webUrl, '?', commandVar, paramsVar
]

{ #category : #'as yet unclassified' }
WEBApplicationCommand >> urlParamsFragment [
	^self hasParams
		ifTrue: ['cp=', self paramsString.]
		ifFalse: ['']
]

{ #category : #accessing }
WEBApplicationCommand >> user [
	^ user
]

{ #category : #accessing }
WEBApplicationCommand >> user: anObject [
	user := anObject
]
