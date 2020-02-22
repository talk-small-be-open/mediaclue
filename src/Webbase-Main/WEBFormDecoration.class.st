Class {
	#name : #WEBFormDecoration,
	#superclass : #WEBComponentDecoration,
	#instVars : [
		'buttons',
		'defaultButton',
		'cancelButtonNames',
		'cssClass',
		'isDirtyChecked',
		'closeButtonNames'
	],
	#category : #'Webbase-Main-View'
}

{ #category : #buttons }
WEBFormDecoration >> addButton: aString perform: aSymbol [
	buttons add: (aSymbol->aString)
]

{ #category : #buttons }
WEBFormDecoration >> addCancelButton [
	buttons add: (#cancel->'Abbrechen')
]

{ #category : #buttons }
WEBFormDecoration >> addCloseButton [
	buttons add: (#close->'Schliessen')
]

{ #category : #buttons }
WEBFormDecoration >> addOkButton [
	buttons add: (#ok->'OK')
]

{ #category : #buttons }
WEBFormDecoration >> addSaveAndCloseButton [
	buttons add: (#saveAndClose->'Speichern und schliessen')
]

{ #category : #buttons }
WEBFormDecoration >> addSaveButton [
	self addSaveButton: 'Speichern'
]

{ #category : #buttons }
WEBFormDecoration >> addSaveButton: aLabel [
	buttons add: (#save->aLabel)
]

{ #category : #buttons }
WEBFormDecoration >> addSavetempButton [
	self addSaveButton: 'Zwischenspeichern'
]

{ #category : #'as yet unclassified' }
WEBFormDecoration >> beDirtyChecked [
	isDirtyChecked := true
]

{ #category : #accessing }
WEBFormDecoration >> buttons [
	^ buttons
]

{ #category : #accessing }
WEBFormDecoration >> buttons: selectorLabelAssociationsArray [
	buttons := selectorLabelAssociationsArray
]

{ #category : #accessing }
WEBFormDecoration >> cssClass: aValue [
	cssClass := aValue
]

{ #category : #accessing }
WEBFormDecoration >> defaultAction [
	self decoratedComponent perform: self defaultButton
]

{ #category : #accessing }
WEBFormDecoration >> defaultButton [
	^defaultButton ifNil: [buttons first key]
]

{ #category : #accessing }
WEBFormDecoration >> defaultButton: anObject [
	defaultButton := anObject
]

{ #category : #testing }
WEBFormDecoration >> hasButtons [
	^buttons notEmpty
]

{ #category : #initialization }
WEBFormDecoration >> initialize [
	super initialize.
	
	buttons := {#ok->'OK'. #cancel->'Abbrechen'} asOrderedCollection.
	cancelButtonNames := #(cancel abort).
	closeButtonNames := #(close).
	isDirtyChecked := false
]

{ #category : #testing }
WEBFormDecoration >> isCancelButton: aButtonName [
	^cancelButtonNames includes: aButtonName
]

{ #category : #testing }
WEBFormDecoration >> isCloseButton: aButtonName [
	^closeButtonNames includes: aButtonName
]

{ #category : #buttons }
WEBFormDecoration >> removeButtons [
	buttons := OrderedCollection new
]

{ #category : #rendering }
WEBFormDecoration >> renderButton: aLabelSymbol forSelector: aMethodSymbol on: html [
	| callback |
	callback := [self decoratedComponent perform: aMethodSymbol].
	(self isCancelButton: aMethodSymbol) ifTrue: [
		html anchorButton
			callback: callback;
			with: aLabelSymbol.
		^self].
	(self isCloseButton: aMethodSymbol) ifTrue: [
		html anchorButton
			callback: callback;
			with: aLabelSymbol.
		^self].

	"Normal Button"
	html submitButtonPrimary
		class: 'dirtyWarn';
		callback: callback;
		with: aLabelSymbol
]

{ #category : #rendering }
WEBFormDecoration >> renderButtonsOn: html [
	buttons ifNotEmpty: [
		html div class: 'dialogButtons'; with: [
			self buttons do: [ :each |
				| actionName labelKey |
				actionName := each key.
				labelKey := each value.
				html span
					"class: 'dialog-button-' , methodName;"
					with: [
						self renderButton: labelKey forSelector: actionName on: html.
						html space.]].
			isDirtyChecked ifTrue: [
				self decoratedComponent renderDirtyFlagOn: html]]]
]

{ #category : #rendering }
WEBFormDecoration >> renderContentOn: html [
	| formTag |
	formTag := html form
		noAutocomplete;
		class: cssClass;
		class: 'dirtycheck' if: isDirtyChecked;
		multipart: self requiresMultipartForm;
		yourself.

	self hasButtons ifTrue: [
		formTag defaultAction: [self defaultAction]].
	
	formTag with: [
		self renderNextOn: html.
		self renderButtonsOn: html ]
]

{ #category : #testing }
WEBFormDecoration >> requiresMultipartForm [
	^ self decoratedComponent requiresMultipartForm
]

{ #category : #buttons }
WEBFormDecoration >> withCloseButton [
	self removeButtons.
	self addCloseButton.

]

{ #category : #buttons }
WEBFormDecoration >> withOkCancelButton [
	self removeButtons.
	self addOkButton.
	self addCancelButton
]

{ #category : #buttons }
WEBFormDecoration >> withSaveButton [
	self removeButtons.
	self addSaveButton
]

{ #category : #buttons }
WEBFormDecoration >> withSaveCloseButtons [
	self removeButtons.
	self addSaveButton.
	self addCloseButton
]

{ #category : #buttons }
WEBFormDecoration >> withStandardSaveCancelButtons [
	self removeButtons.
	self addSaveAndCloseButton.
	self addSaveButton.
	self addCancelButton
]

{ #category : #buttons }
WEBFormDecoration >> withStandardSaveCancelButtonsForNewObjects [
	self removeButtons.
	self addSaveAndCloseButton.
	self addSavetempButton.
	self addCancelButton
]

{ #category : #buttons }
WEBFormDecoration >> withStandardSaveCloseButtons [
	self removeButtons.
	self addSaveAndCloseButton.
	self addSaveButton.
	self addCloseButton
]
