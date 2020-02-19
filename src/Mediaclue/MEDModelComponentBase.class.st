Class {
	#name : #MEDModelComponentBase,
	#superclass : #MEDComponent,
	#instVars : [
		'model',
		'validationResult',
		'maComponent'
	],
	#category : #'Mediaclue-View'
}

{ #category : #accessing }
MEDModelComponentBase class >> model: aModel [
	^ self basicNew
		setModel: aModel;
		initialize;
		yourself	
]

{ #category : #hooks }
MEDModelComponentBase >> children [
	^Array with: maComponent
]

{ #category : #'as yet unclassified' }
MEDModelComponentBase >> ifCanEdit: aBlock [
	(model canEdit: self currentUser) ifTrue: aBlock
]

{ #category : #'as yet unclassified' }
MEDModelComponentBase >> ifCanEdit: aBlock else: anElseBlock [
	(model canEdit: self currentUser) ifTrue: aBlock ifFalse: anElseBlock
]

{ #category : #'as yet unclassified' }
MEDModelComponentBase >> ifCanView: aBlock [
	(model canView: self currentUser) ifTrue: aBlock
]

{ #category : #initialization }
MEDModelComponentBase >> initialize [
	super initialize.
	self initializeMaComponent

]

{ #category : #initialization }
MEDModelComponentBase >> initializeMaComponent [
	maComponent := model asComponent
		addValidation;
		superComponent: self;
		readonly: self isEditor not;
		yourself
]

{ #category : #testing }
MEDModelComponentBase >> isEditor [
	^false
]

{ #category : #accessing }
MEDModelComponentBase >> isValid [
	^ self validate isValid
]

{ #category : #'as yet unclassified' }
MEDModelComponentBase >> maComponent [
	^ maComponent
]

{ #category : #accessing }
MEDModelComponentBase >> model [
	^model
]

{ #category : #accessing }
MEDModelComponentBase >> modelValidator [
	^model defaultValidator
]

{ #category : #initialization }
MEDModelComponentBase >> refresh [
	self resetMaComponent
]

{ #category : #rendering }
MEDModelComponentBase >> renderContentOn: html [
	self renderValidationResultsOn: html.
	self renderModelComponentOn: html.
]

{ #category : #rendering }
MEDModelComponentBase >> renderMaModelOn: html [
	"html ist ein magrittified html canvas"
	
	"Delegation weil lesbarer"
	self renderModelOn: html

]

{ #category : #rendering }
MEDModelComponentBase >> renderModelComponentOn: html [
	"Hinweis: Die maComponent ruft zurück renderMaModelOn: mit einem erweiterten canvas"
	html render: maComponent
]

{ #category : #rendering }
MEDModelComponentBase >> renderModelOn: html [
	"html ist ein magrittified html canvas"
	self subclassResponsibility
]

{ #category : #rendering }
MEDModelComponentBase >> renderValidationResults: aValidationResult on: html [
	"OPTIMIZE: Verschachtelte faileRules einzeln rausholen und rekursiv darstellen, statt eines verdichteten Strings"
	(aValidationResult notNil and: [aValidationResult isValid not]) ifTrue: [
		html div
			class: 'validationResults';
			with: [
				html div class: 'title'; with: 'Validation'.
				html div with: 'Dieses Objekt hat Fehler'.
				html unorderedList
					with: [
						aValidationResult failedRules do: [:eachRule |
							html listItem: [
								eachRule
									renderErrorMessageOn: html].
				]]]]
]

{ #category : #rendering }
MEDModelComponentBase >> renderValidationResultsOn: html [
	self renderValidationResults: validationResult on: html
]

{ #category : #initialization }
MEDModelComponentBase >> resetMaComponent [
	maComponent reset
]

{ #category : #accessing }
MEDModelComponentBase >> setModel: aModel [
	model := aModel
]

{ #category : #accessing }
MEDModelComponentBase >> validate [
	validationResult := model validateWith: self modelValidator.
	^ validationResult
]
