"
I am a dialog for setting a new password. Has two input fields, for confirmation of the password. Validates password format.
"
Class {
	#name : #WEBSetPasswordComponent,
	#superclass : #WEBComponent,
	#instVars : [
		'password',
		'passwordConfirmation',
		'validationResult'
	],
	#category : #'Webbase-Main-View'
}

{ #category : #testing }
WEBSetPasswordComponent >> isConfirmationMismatch [
	^passwordConfirmation notNil and: [self isConfirmed not]
]

{ #category : #testing }
WEBSetPasswordComponent >> isConfirmed [
	^password = passwordConfirmation
]

{ #category : #actions }
WEBSetPasswordComponent >> ok [
	self validate.
	validationResult = #ok ifTrue: [
		self answer: password.
		password := nil.
		passwordConfirmation := nil]
]

{ #category : #accessing }
WEBSetPasswordComponent >> password [
	^password
]

{ #category : #accessing }
WEBSetPasswordComponent >> password: anObject [
	password := anObject trimBoth
]

{ #category : #accessing }
WEBSetPasswordComponent >> passwordConfirmation [
	^ passwordConfirmation
]

{ #category : #accessing }
WEBSetPasswordComponent >> passwordConfirmation: anObject [
	passwordConfirmation := anObject trimBoth
]

{ #category : #rendering }
WEBSetPasswordComponent >> renderContentOn: html [
	html heading: 'Passwort neu setzen'.
	validationResult ifNotBlank: [
		html bsAlertDanger: validationResult].
	html paragraph: 'Hier können Sie Ihr Passwort neu setzen.'.
	html form noAutocomplete; with: [
		html bsTable: [
			html tableRow: [
				html tableData: 'Neues Passwort'.
				html tableData: [
					html passwordInput
						script: (html jQuery this triggerFocus);
						callback: [:value | self password: value];
						with: nil]].
			html tableRow: [
				html tableData: 'Passwort-Wiederholung'.
				html tableData: [
					html passwordInput
						callback: [:value | self passwordConfirmation: value];
						with: nil]]].
		html div class: 'topBuffer'; with: [
			html submitButtonPrimary
				class: 'mr-2';
				callback: [self ok];
				with: 'OK, neues Passwort übernehmen'.
			html anchor
				callback: [ self cancel ];
				with: 'Abbrechen'
		].
	].
]

{ #category : #validation }
WEBSetPasswordComponent >> validate [
	validationResult := nil.

"TODO: zentrale Passwortformat-Check verwenden, siehe auch descirptionPassword"

	password ifEmpty: [
		validationResult := 'Fehler: Leeres Passwort'. ^self].

	password size < 6 ifTrue: [
		validationResult := 'Fehler: Passwort zu kurz'. ^self].
	
	self isConfirmationMismatch ifTrue: [
		validationResult := 'Wiederholung falsch'. ^self].
	
	
	validationResult ifNil: [validationResult := #ok]
]
