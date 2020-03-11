Class {
	#name : #WEBCaptchaComponent,
	#superclass : #WEBComponent,
	#instVars : [
		'captchaCode',
		'enteredCode',
		'isValid',
		'retry',
		'maxRetryCount'
	],
	#category : #'Webbase-Main-View'
}

{ #category : #'as yet unclassified' }
WEBCaptchaComponent >> calculateCaptchaCode [
	captchaCode := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890/*=-%+!' shuffled first: 5.

	"For Selenium Tests we need to bypass the captcha."
	self ifTesting: [captchaCode := 'abc123'].

]

{ #category : #actions }
WEBCaptchaComponent >> cancel [
	self answer: false
]

{ #category : #'as yet unclassified' }
WEBCaptchaComponent >> enteredCode: aString [
	enteredCode := aString
]

{ #category : #initialization }
WEBCaptchaComponent >> initialize [
	super initialize.
	self calculateCaptchaCode.
	self resetValidity.
	retry := 0.
	maxRetryCount := 10.
]

{ #category : #testing }
WEBCaptchaComponent >> isInvalid [
	^isValid = false
]

{ #category : #actions }
WEBCaptchaComponent >> newCode [
	self calculateCaptchaCode.
	self resetValidity
]

{ #category : #'as yet unclassified' }
WEBCaptchaComponent >> okGoAhead [
	self answer: true
]

{ #category : #'as yet unclassified' }
WEBCaptchaComponent >> reactOnBadBehaviour [
	self session logout
]

{ #category : #rendering }
WEBCaptchaComponent >> renderCaptchaCodeOn: html [
	self subclassResponsibility
]

{ #category : #rendering }
WEBCaptchaComponent >> renderContentOn: html [
	html paragraph: 'Wir verwenden einen Captcha-Code, um gegen Spam vorzubeugen. Bitten tippen Sie folgenden Code korrekt ab, um fortfahren zu können.'.
	self renderCaptchaCodeOn: html.
	html form noAutocomplete with: [
		html textInput
			script: (html jQuery this triggerFocus);
			class: 'captcha';
			callback: [:value | self enteredCode: value].
		self renderErrorMessageOn: html.
		html break.
		html break.
		html submitButtonPrimary
			callback: [self validate];
			with: 'Weiter'.
		html space.
		html anchorButton
			callback: [self cancel];
			with: 'Abbrechen'.
		html space.
		html anchorButton
			callback: [self newCode];
			with: 'Neuer Captcha-Code']
]

{ #category : #rendering }
WEBCaptchaComponent >> renderErrorMessageOn: html [
	self isInvalid ifTrue: [
		html paragraph
			class: 'error';
			with: 'Fehler, bitte erneut versuchen']
]

{ #category : #'as yet unclassified' }
WEBCaptchaComponent >> resetValidity [
	isValid := nil
]

{ #category : #'as yet unclassified' }
WEBCaptchaComponent >> retry [
	retry := retry + 1.
	(retry >= maxRetryCount)
		ifFalse: [self calculateCaptchaCode]
		ifTrue: [self reactOnBadBehaviour]
]

{ #category : #actions }
WEBCaptchaComponent >> validate [
	isValid := enteredCode = captchaCode.
	
	isValid
		ifTrue: [self okGoAhead]
		ifFalse: [self retry]
]
