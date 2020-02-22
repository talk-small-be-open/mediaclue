Class {
	#name : #WEBChoiceDialog,
	#superclass : #WEBComponent,
	#instVars : [
		'options',
		'selection',
		'labelBlock',
		'messageText'
	],
	#category : #'Webbase-Main-View'
}

{ #category : #examples }
WEBChoiceDialog class >> example [
	^ self options: #('Perl' 'Python' 'Ruby' 'Smalltalk') selection: 'Smalltalk'
]

{ #category : #'instance creation' }
WEBChoiceDialog class >> options: aCollection [
	^ self options: aCollection selection: nil
]

{ #category : #'instance creation' }
WEBChoiceDialog class >> options: aCollection selection: anObject [
	^ self new
		options: aCollection;
		selection: anObject;
		yourself
		
]

{ #category : #'as yet unclassified' }
WEBChoiceDialog >> beLabelSorted [
	options sort: [:a :b | (self labelForOption: a) <= (self labelForOption: b)]
]

{ #category : #accessing }
WEBChoiceDialog >> labelBlock [
	^ labelBlock
]

{ #category : #accessing }
WEBChoiceDialog >> labelBlock: anObject [
	labelBlock := anObject
]

{ #category : #'as yet unclassified' }
WEBChoiceDialog >> labelForOption: anObject [
	"Smart choose the standard option for an object"
	labelBlock ifNotNil: [^labelBlock value: anObject].
	
"	(anObject isKindOf: DAZModelObject)
		ifTrue: [^anObject displayName]."

	(anObject respondsTo: #displayName)
		ifTrue: [^anObject displayName].
	
	^anObject greaseString
]

{ #category : #accessing }
WEBChoiceDialog >> messageText [
	^ messageText
]

{ #category : #accessing }
WEBChoiceDialog >> messageText: anObject [
	messageText := anObject
]

{ #category : #actions }
WEBChoiceDialog >> ok [
	self answer: self selection
]

{ #category : #accessing }
WEBChoiceDialog >> options [
	^ options
]

{ #category : #accessing }
WEBChoiceDialog >> options: aCollection [
	options := aCollection
]

{ #category : #rendering }
WEBChoiceDialog >> renderContentOn: html [
	html div class: 'choiceDialog'; with: [
		html paragraph: messageText.
		html form with: [
			html select
				list: self options;
				selected: self selection;
				labels: [:option | self labelForOption: option];
				beOptional;
				callback: [ :value | self selection: value ].
			html break.
			html submitButton
					callback: [self ok];
					with: 'OK'.
			html space.
			html anchorButton
				callback: [self cancel];
				with: 'Abbrechen'
		].
	]
]

{ #category : #accessing }
WEBChoiceDialog >> selection [
	^ selection
]

{ #category : #accessing }
WEBChoiceDialog >> selection: anObject [
	selection := anObject
]
