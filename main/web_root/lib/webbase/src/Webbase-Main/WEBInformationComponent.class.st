"
I display an information and the user can press OK to continue. I am simple. I am used in workflows, typically.
"
Class {
	#name : #WEBInformationComponent,
	#superclass : #WEBComponent,
	#instVars : [
		'onOkBlock',
		'message',
		'bsIconName'
	],
	#category : #'Webbase-Main-View'
}

{ #category : #'as yet unclassified' }
WEBInformationComponent class >> message: aMessageSymbol [
	^self basicNew
		setMessage: aMessageSymbol;
		initialize;
		yourself
]

{ #category : #'as yet unclassified' }
WEBInformationComponent >> beWarning [
	bsIconName := 'alert'
]

{ #category : #accessing }
WEBInformationComponent >> message: anObject [
	message := anObject
]

{ #category : #actions }
WEBInformationComponent >> ok [
	onOkBlock ifNotNil: [onOkBlock value].
	self answer: true.
]

{ #category : #accessing }
WEBInformationComponent >> onOk: aBlock [
	onOkBlock := aBlock
]

{ #category : #rendering }
WEBInformationComponent >> renderContentOn: html [
	html paragraph: [
		bsIconName ifNotNil: [
			html span style: 'font-size: 150%;'; with: [
				html fasIcon: bsIconName; space ]].
		html paragraph withLineBreaks: message].

	"Render as button, that robots dont klick it"
	html form: [
		html submitButtonPrimary
			callback: [self ok];
			with: 'OK']
]

{ #category : #accessing }
WEBInformationComponent >> setMessage: anObject [
	message := anObject
]
