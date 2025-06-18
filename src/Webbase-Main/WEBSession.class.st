Class {
	#name : #WEBSession,
	#superclass : #WASession,
	#traits : 'TWEBGlobalHelpers',
	#classTraits : 'TWEBGlobalHelpers classTrait',
	#instVars : [
		'user',
		'flashMessages',
		'flashErrorMessages',
		'afterLoginBlock'
	],
	#category : #'Webbase-Main-View'
}

{ #category : #adding }
WEBSession >> addFlashErrorMessage: aString [
	flashErrorMessages add: aString
	
]

{ #category : #adding }
WEBSession >> addFlashMessage: aString [
	flashMessages add: aString
	
]

{ #category : #enumerating }
WEBSession >> afterLoginDo: aBlock [
	afterLoginBlock := aBlock
]

{ #category : #adding }
WEBSession >> consumeFlashErrorMessages [
	| copy |
	copy := flashErrorMessages copy.
	flashErrorMessages removeAll.
	^copy
]

{ #category : #adding }
WEBSession >> consumeFlashMessages [
	| copy |
	copy := flashMessages copy.
	flashMessages removeAll.
	^copy
]

{ #category : #'as yet unclassified' }
WEBSession >> ensureUserIsAnonymous [
"	(user isNil or: [user isAnonymous not]) ifTrue: [self initializeAnonymousUser]"
	user := nil
]

{ #category : #'as yet unclassified' }
WEBSession >> fireAfterLogin [
	self isLoggedIn ifTrue: [
		afterLoginBlock ifNotNil: [
			afterLoginBlock cull: self mainComponent.
			afterLoginBlock := nil
	]]
]

{ #category : #initialization }
WEBSession >> initialize [

	super initialize.

	flashMessages := OrderedCollection new.
	flashErrorMessages := OrderedCollection new.
	user := nil.
]

{ #category : #testing }
WEBSession >> isLoggedIn [
	^user notNil
]

{ #category : #protocol }
WEBSession >> login: aUser [

	"Prevent multiple logins from doing something too much"
	(user == aUser) ifTrue: [^self].
	
	"Does the actual log in of the user"
	self user: aUser.
	
	"user lastLoginAt: DateAndTime now."
	
	self logInfo: 'User ', (aUser email ifBlank: [aUser uuidString]), ' logged in.'
]

{ #category : #protocol }
WEBSession >> loginUser: aUser password: aPasswordString [
	| isValid |
	
	aUser ifNil: [ ^ false ].
	aUser isDisabled ifTrue: [ ^ false ].

	isValid := self db identityProvider isUser: aUser validPassword: aPasswordString.

	isValid ifTrue: [self login: aUser].

	^isValid
]

{ #category : #protocol }
WEBSession >> logout [
	self logInfo: 'User ', user email greaseString, ' logged OUT.'.

	self user: nil.

	"Das macht zuviel? Damit verlieren wir die Session komplett"
"	self unregister"
]

{ #category : #protocol }
WEBSession >> logoutKeepSession [
	self logout
]

{ #category : #accessing }
WEBSession >> mainComponent [
	^self presenter mainComponent
]

{ #category : #'as yet unclassified' }
WEBSession >> relogin [
	self mainComponent answer
]

{ #category : #'as yet unclassified' }
WEBSession >> reloginThen: aBlock [
	self afterLoginDo: aBlock.
	self relogin.

]

{ #category : #accessing }
WEBSession >> user [
	^user
]

{ #category : #accessing }
WEBSession >> user: aUser [
	user := aUser
]

{ #category : #'as yet unclassified' }
WEBSession >> userLabel [
	^ self isLoggedIn ifTrue: [ user displayName ] ifFalse: [ 'Anonymous' ]
]
