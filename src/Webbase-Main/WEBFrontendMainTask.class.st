Class {
	#name : #WEBFrontendMainTask,
	#superclass : #WEBMainTask,
	#instVars : [
		'commandExecuted',
		'command'
	],
	#category : #'Webbase-Main-View'
}

{ #category : #'as yet unclassified' }
WEBFrontendMainTask class >> registerAsApplication [

	^self registerAsApplication: 'app'

]

{ #category : #'as yet unclassified' }
WEBFrontendMainTask class >> registerAsApplication: aName [
	| app  |

	app := WAAdmin 
		register: self
		asApplicationAt: aName.

	app configuration addParent: WAEmailConfiguration instance.

	app
		preferenceAt: #sessionClass put: self pi defaultFrontendSessionClass;
		preferenceAt: #trackingStrategy put: WACookieIfSupportedSessionTrackingStrategy new;
		scriptGeneratorClass: JQScriptGenerator.
		
"		preferenceAt: #renderPhaseContinuationClass put: ALRenderPhaseContinuation;
		preferenceAt: #actionPhaseContinuationClass put: ALCallbackProcessingActionContinuation;"

	app exceptionHandler: WADebugErrorHandler.

	^app
	





]

{ #category : #'as yet unclassified' }
WEBFrontendMainTask >> clearCommand [
"	commandCode := nil."
	command := nil
]

{ #category : #'as yet unclassified' }
WEBFrontendMainTask >> commandExpired [

	self call: (
		(WEBPluggableComponent new
			contentText: 'command expired';
			yourself)
		addDecoration: WEBWindowDecoration new;
		yourself)
]

{ #category : #actions }
WEBFrontendMainTask >> directLoginUser: aUser [
	"We log the user in, if he isnt already"
	(self currentUser == aUser) ifFalse: [
		self session login: aUser]
]

{ #category : #actions }
WEBFrontendMainTask >> ensureLoginUser [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WEBFrontendMainTask >> executeCommand [
	command ifNotNil: [
		commandExecuted ifFalse: [
			[
			command executeOnApplication: mainComponent currentUser: self currentUser
			] ensure: [
				command save.
				commandExecuted := true]
		]
	]
]

{ #category : #running }
WEBFrontendMainTask >> go [
	[self isCommandNeedsExecution
		ifTrue: [
			(command isExecutable not)
				ifTrue: [
					self commandExpired.
					self clearCommand]
				ifFalse: [
					"OK, here the command is valid and can be executed. We try to autologin or ask the user to login"
					command prepareExecution.

					command isLogoutRequired ifTrue: [
						"We start the public interface, since the command might operate on that. Never log in here."
						"self callPublicApplication"
						self logoutUser].

					command isLoginRequired ifTrue: [
						command hasUser
							ifTrue: [command isAutologin
								ifTrue: [self directLoginUser: command user]
								ifFalse: [self verifyLoginUser: command user]]
							ifFalse: [self ensureLoginUser]]]].

	"Call the main application, either logged in or not, smart."
	self callApplication]
		on: Error
		do: [:error |
			self ifDevelopment: [error pass].
			self displayMessageAndCallPublicApplication: error messageText].
		
	self clearCommand.
]

{ #category : #hooks }
WEBFrontendMainTask >> initialRequest: aRequest [

	super initialRequest: aRequest.

	"Get the command, if any given"
	aRequest at: 'c' ifPresent: [:value |
		command := self db findApplicationCommandByCode: value].


]

{ #category : #initialization }
WEBFrontendMainTask >> initialize [
	super initialize.
	commandExecuted := false
]

{ #category : #testing }
WEBFrontendMainTask >> isCommandGiven [
	^command notNil
]

{ #category : #testing }
WEBFrontendMainTask >> isCommandNeedsExecution [
	^command notNil and: [ commandExecuted not ]
]

{ #category : #'as yet unclassified' }
WEBFrontendMainTask >> loggedInMainComponentClass [
	^self pi defaultLoggedInMainComponentClass 
]

{ #category : #'as yet unclassified' }
WEBFrontendMainTask >> logoutUser [
	self session logoutKeepSession
]

{ #category : #'as yet unclassified' }
WEBFrontendMainTask >> publicMainComponentClass [
	^self pi defaultPublicMainComponentClass 
]

{ #category : #'as yet unclassified' }
WEBFrontendMainTask >> verifyLoginUser: aUser [
	"We open a login dialog, if the same user is not already logged in"
	(self currentUser == aUser)
	"OPTIMIZE: Der Logindialog sollte vermutlich den usernamen fixiert haben?"
		ifFalse: [ self ensureLoginUser ]
]
