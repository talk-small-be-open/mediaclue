Class {
	#name : #WEBInputDialog,
	#superclass : #WEBComponent,
	#instVars : [
		'value',
		'messageText',
		'multiline',
		'masked'
	],
	#category : #'Webbase-Main-View'
}

{ #category : #'as yet unclassified' }
WEBInputDialog >> beMasked [
	masked := true.
	multiline := false
]

{ #category : #'as yet unclassified' }
WEBInputDialog >> beMultiline [
	multiline := true.
	masked := false
]

{ #category : #'as yet unclassified' }
WEBInputDialog >> beSingleline [
	multiline := false
]

{ #category : #accessing }
WEBInputDialog >> default: aString [
	value := aString
]

{ #category : #'initialize-release' }
WEBInputDialog >> initialize [
	super initialize.
	masked := false.
	self beSingleline
]

{ #category : #testing }
WEBInputDialog >> isMasked [
	^masked = true
]

{ #category : #testing }
WEBInputDialog >> isMultiline [
	^multiline = true
]

{ #category : #testing }
WEBInputDialog >> isSingleline [
	^self isMultiline not
]

{ #category : #'as yet unclassified' }
WEBInputDialog >> messageText: anObject [
	messageText := anObject
]

{ #category : #rendering }
WEBInputDialog >> renderContentOn: html [
	html div class: 'inputDialog'; with: [
		html paragraph: messageText.
		html form
			defaultAction: [ self answer: value ];
			with: [
				html div: [
					self renderInputFieldOn: html.
					html buttonToolbar: [
						html submitButtonPrimary
							callback: [self answer: value];
							with: 'OK'.
						html space.
						html anchorButton
							callback: [self cancel];
							with: 'Abbrechen']]]]
]

{ #category : #rendering }
WEBInputDialog >> renderInputFieldOn: html [
	| field |

	self isMultiline ifTrue: [field := html textArea style: 'height:80px'; yourself].
	self isSingleline ifTrue: [
		field := self isMasked
			ifTrue: [ html passwordInput id: 'pleaseDontAskMeToStoreThisPasswordAgain'; yourself]
			ifFalse: [
				html textInput
					attributeAt: 'autocomplete' put: 'off';
					yourself
			]].

	field
		script: (html jQuery this triggerFocus);
		on: #value of: self.

	^field
]

{ #category : #accessing }
WEBInputDialog >> value [
	^value
]

{ #category : #accessing }
WEBInputDialog >> value: aString [
	value := aString
]
