Class {
	#name : #WEBLoginComponent,
	#superclass : #WEBComponent,
	#instVars : [
		'onLoginBlock',
		'errorMessage',
		'password',
		'userIdentifier',
		'title'
	],
	#category : #'Webbase-Main-View'
}

{ #category : #'initialize-release' }
WEBLoginComponent >> clearErrorMessage [
	errorMessage := nil
]

{ #category : #actions }
WEBLoginComponent >> directLoginUser: aUser [
	self session login: aUser.
	self loginSuccess
]

{ #category : #'initialize-release' }
WEBLoginComponent >> initialize [
	super initialize.

	self clearErrorMessage.

	title := 'Anmeldung'
]

{ #category : #actions }
WEBLoginComponent >> login [
	| userToLogin loginSuccessful |

	"Nicht Seaside-artiges holen der Daten, wegen autocomplete Formular-fähigkeit"
	self userIdentifier: (self requestContext request postFields at: 'loginUsername' ifAbsent: nil).
	self password: (self requestContext request postFields at: 'loginPassword' ifAbsent: nil).

	loginSuccessful := false.
	
	self clearErrorMessage.

	"Check if email and password are given"
	(userIdentifier notBlank and: [password notBlank]) ifTrue: [
		"Try to login"

		"We try to find the user from email.
		Since we want to read some attributes of the user, we need the
		user object prior to login."
		userToLogin := self db findUserByUserIdentifier: userIdentifier.
		
		"If we have an object, we do some checks first"
		userToLogin ifNotNil: [
			"Authenticate"
			loginSuccessful := self session loginUser: userToLogin password: password]].

	loginSuccessful
		ifTrue: [self loginSuccess]
		ifFalse: [self loginFailed]
]

{ #category : #actions }
WEBLoginComponent >> loginDisabled [
	errorMessage := 'Dieses Login ist zur Zeit deaktiviert'
]

{ #category : #actions }
WEBLoginComponent >> loginFailed [
	errorMessage := 'Login falsch'
]

{ #category : #actions }
WEBLoginComponent >> loginSuccess [
	onLoginBlock ifNotNil: [onLoginBlock cull: self currentUser].
	self answer: self currentUser
]

{ #category : #actions }
WEBLoginComponent >> mustResetPasswordUser: aUser [
	"TODO: Prüfen"
	| newPassword |
	newPassword := nil.
	
	[ newPassword isBlank ]
		whileTrue: [newPassword := self request: 'Geben Sie hier Ihr neues Passwort ein:'].

	aUser password: newPassword.
	self flashMessage: 'Passwort geändert!'
]

{ #category : #'as yet unclassified' }
WEBLoginComponent >> onLogin: aBlock [
	onLoginBlock := aBlock
]

{ #category : #accessing }
WEBLoginComponent >> password: aPasswordText [
	password := nil.
	aPasswordText ifNotBlank: [
		password := aPasswordText greaseString]
]

{ #category : #rendering }
WEBLoginComponent >> renderContentOn: html [
	errorMessage ifNotNil: [
		html alertDanger: errorMessage ].

	title ifNotBlank: [ html h2: title ].
	html form: [
		html div: [
			html basicTable class: 'login'; with: [
				html tableRow: [
					html tableData: 'Benutzername (E-Mail)'.
					html tableData: [
						html textInput
							script: (userIdentifier ifBlank: [(html jQuery this triggerFocus)]);
							name: 'loginUsername';
							with: userIdentifier]].
				html tableRow: [
					html tableData: [
						html text: 'Passwort' ].
					html tableData: [
						html passwordInput
							script: (userIdentifier ifNotBlank: [(html jQuery this triggerFocus)]);
							name: 'loginPassword']].
				html tableRow: [
					html tableData.
					html tableData: [
						html submitButton
							callback: [self login];
							with: [
								html iconLogin; space.
								html text: 'Anmelden']]]].
	]]
]

{ #category : #accessing }
WEBLoginComponent >> userIdentifier [
	^ userIdentifier
]

{ #category : #accessing }
WEBLoginComponent >> userIdentifier: anObject [
	userIdentifier := anObject greaseString trimBoth
]
