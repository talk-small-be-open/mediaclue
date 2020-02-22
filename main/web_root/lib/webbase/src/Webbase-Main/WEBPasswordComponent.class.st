"
I am a dialog for entering the current password. Checks the password.
"
Class {
	#name : #WEBPasswordComponent,
	#superclass : #WEBComponent,
	#instVars : [
		'errorMessage',
		'hashedPassword'
	],
	#category : #'Webbase-Main-View'
}

{ #category : #actions }
WEBPasswordComponent >> cancel [
	self answer: false
]

{ #category : #'initialize-release' }
WEBPasswordComponent >> clearErrorMessage [
	errorMessage := nil
]

{ #category : #actions }
WEBPasswordComponent >> fail [
	errorMessage := 'Falsches Passwort'
]

{ #category : #'initialize-release' }
WEBPasswordComponent >> initialize [
	super initialize.
	self clearErrorMessage.

]

{ #category : #actions }
WEBPasswordComponent >> login [
	| success |
	success := false.
	
	self clearErrorMessage.
	
	success := hashedPassword isNil
		ifTrue: [false]
		ifFalse: [
			(self currentUser isValidPasswordHash: hashedPassword)
				ifTrue: [true]
				ifFalse: [false]].
			
	success
		ifTrue: [self success]
		ifFalse: [self fail]
]

{ #category : #accessing }
WEBPasswordComponent >> password: aPasswordText [
	hashedPassword := aPasswordText isEmptyOrNil
		ifFalse: [WEBHelper generatePasswordHash: aPasswordText]
		ifTrue: [nil]
]

{ #category : #rendering }
WEBPasswordComponent >> renderContentOn: html [
	errorMessage ifNotNil: [
		html paragraph class: 'alert alert-danger'; with: errorMessage].
	
	html paragraph: 'Geben Sie zur Sicherheit hier Ihr Passwort nochmals an.'.
	html form: [
		html div class: 'bottomBuffer'; with: [
			html passwordInput
				triggerFocus;
				callback: [:value | self password: value]].

		html buttonToolbar: [
			html submitButtonPrimary
				class: 'mr-2';
				callback: [self login];
				with: 'OK'.

			html anchorButton
				callback: [self cancel];
				with: 'Abbrechen']]
]

{ #category : #actions }
WEBPasswordComponent >> success [
	self answer: true
]
