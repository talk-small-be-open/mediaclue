Class {
	#name : #WEBMainTask,
	#superclass : #WATask,
	#traits : 'TWEBComponentHelpers',
	#classTraits : 'TWEBComponentHelpers classTrait',
	#instVars : [
		'mainComponent'
	],
	#category : #'Webbase-Main-View'
}

{ #category : #'as yet unclassified' }
WEBMainTask class >> registerAsApplication [

	^self registerAsApplication: 'app'

]

{ #category : #'as yet unclassified' }
WEBMainTask class >> registerAsApplication: aName [
	self subclassResponsibility
]

{ #category : #'helpers-ui' }
WEBMainTask class >> requestPassword [
	^self window: 'Passwortabfrage' with: WEBPasswordComponent new
]

{ #category : #running }
WEBMainTask >> callApplication [
	self isLoggedIn
		ifTrue: [self callLoggedInApplication]
		ifFalse: [self callPublicApplication]
]

{ #category : #running }
WEBMainTask >> callLoggedInApplication [

	"Security check, only call the application if user is logged in"
	self isLoggedIn ifFalse: [^self].
	
	self mainComponent: self loggedInMainComponentClass new.
	self executeCommand.

	self callMainComponent.
	self clearMainComponent.

]

{ #category : #'as yet unclassified' }
WEBMainTask >> callMainComponent [
	self call: mainComponent
]

{ #category : #'as yet unclassified' }
WEBMainTask >> callPublicApplication [

	self session ensureUserIsAnonymous.

	self mainComponent: self publicMainComponentClass new.
	self executeCommand.

	self callMainComponent.
	self clearMainComponent.
]

{ #category : #'as yet unclassified' }
WEBMainTask >> clearMainComponent [
	mainComponent := nil
]

{ #category : #'as yet unclassified' }
WEBMainTask >> displayMessageAndCallPublicApplication: aMessageText [
	| displayer |
	displayer := WEBPluggableComponent new
		contentText: aMessageText;
		showCloseButton: true;
		addDecoration: WEBWindowDecoration new;
		yourself.

	self call: displayer.
	self callPublicApplication.
]

{ #category : #execution }
WEBMainTask >> executeCommand [
	"subclasses maybe"
]

{ #category : #running }
WEBMainTask >> go [
	self callApplication
]

{ #category : #initialization }
WEBMainTask >> initialize [

	super initialize.

	self addDecoration: self pi defaultMainDecorationClass new
]

{ #category : #'as yet unclassified' }
WEBMainTask >> loggedInMainComponentClass [
	self subclassResponsibility
]

{ #category : #accessing }
WEBMainTask >> mainComponent [
	^mainComponent
]

{ #category : #accessing }
WEBMainTask >> mainComponent: aComponent [
	mainComponent := aComponent
]

{ #category : #'as yet unclassified' }
WEBMainTask >> mainComponentClass [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WEBMainTask >> publicMainComponentClass [
	self subclassResponsibility
]
