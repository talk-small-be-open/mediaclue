Class {
	#name : #WEBConfirmationComponent,
	#superclass : #WEBComponent,
	#instVars : [
		'messageToConfirm',
		'onConfirmBlock',
		'onRejectBlock',
		'isCaptchaSecured',
		'confirmationText',
		'cancelText'
	],
	#category : #'Webbase-Main-View'
}

{ #category : #accessing }
WEBConfirmationComponent >> beCaptchaSecured [
	isCaptchaSecured := true
]

{ #category : #'as yet unclassified' }
WEBConfirmationComponent >> cancelText [
	^cancelText ifBlank: ['Abbrechen']
]

{ #category : #'as yet unclassified' }
WEBConfirmationComponent >> cancelText: aValue [
	cancelText := aValue
]

{ #category : #actions }
WEBConfirmationComponent >> confirm [
	self isCaptchaSecured ifTrue: [self requestCaptcha ifFalse: [^self]].
	
	onConfirmBlock ifNotNil: [onConfirmBlock value].
	self answer: true
]

{ #category : #'as yet unclassified' }
WEBConfirmationComponent >> confirmationText [
	^confirmationText ifBlank: ['OK']
]

{ #category : #'as yet unclassified' }
WEBConfirmationComponent >> confirmationText: aValue [
	confirmationText := aValue
]

{ #category : #'initialize-release' }
WEBConfirmationComponent >> initialize [
	super initialize.
	isCaptchaSecured := false
]

{ #category : #testing }
WEBConfirmationComponent >> isCaptchaSecured [
	^isCaptchaSecured
]

{ #category : #testing }
WEBConfirmationComponent >> isCaptchaSecured: aValue [
	isCaptchaSecured := aValue
]

{ #category : #accessing }
WEBConfirmationComponent >> message: anObject [
	messageToConfirm := anObject
]

{ #category : #accessing }
WEBConfirmationComponent >> onConfirm: aBlock [
	onConfirmBlock := aBlock
]

{ #category : #accessing }
WEBConfirmationComponent >> onReject: aBlock [
	onRejectBlock := aBlock
]

{ #category : #actions }
WEBConfirmationComponent >> reject [
	onRejectBlock ifNotNil: [onRejectBlock value].
	self answer: false.
]

{ #category : #rendering }
WEBConfirmationComponent >> renderContentOn: html [
	html paragraph withLineBreaks: messageToConfirm.
	html form: [
		html submitButtonPrimary
			callback: [self confirm];
			with: self confirmationText.
		html space.
		html submitButton
			callback: [self reject];
			with: self cancelText]
]
