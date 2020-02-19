Trait {
	#name : #TMEDModelEditor,
	#category : #'Mediaclue-Traits'
}

{ #category : #actions }
TMEDModelEditor >> afterSave [
	"subclasses"
]

{ #category : #actions }
TMEDModelEditor >> afterSaveAndStay [
	"subclasses"
]

{ #category : #actions }
TMEDModelEditor >> afterTrySave [
	"subclasses"
]

{ #category : #actions }
TMEDModelEditor >> beforeSave [
	^ true
]

{ #category : #accessing }
TMEDModelEditor >> formAt: anAccessor [
	| description maComponent |
	maComponent := self maComponent.
	description := maComponent magritteDescription atAccessor: anAccessor.
	^ maComponent memento readUsing: description
]

{ #category : #accessing }
TMEDModelEditor >> formAt: anAccessor write: aValue [
	| description maComponent |
	maComponent := self maComponent.
	description := maComponent magritteDescription atAccessor: anAccessor.
	maComponent memento write: aValue using: description
]

{ #category : #testing }
TMEDModelEditor >> isEditor [
	^true
]

{ #category : #'as yet unclassified' }
TMEDModelEditor >> maComponent [
	^ super maComponent
]

{ #category : #actions }
TMEDModelEditor >> save [
	self validateMaComponent.
	
	self beforeSave ifFalse: [ ^ false ].

	"Zuerst die innere Validierung: Magritte"
	self saveMaComponent ifTrue: [
		"Dann die äussere Validierung, unsere eigene"
		self validate isValid ifTrue: [
			self model save.
			self afterSave.
			^ true ] ].
	
	self afterTrySave.
	
	^ false
]

{ #category : #actions }
TMEDModelEditor >> saveAndClose [
	self save ifTrue: [ self close ]
]

{ #category : #actions }
TMEDModelEditor >> saveAndStay [
	self save ifTrue: [ self afterSaveAndStay ]
]

{ #category : #'as yet unclassified' }
TMEDModelEditor >> saveMaComponent [
	self validateMaComponent ifFalse: [ ^ false ].
	self maComponent commit.
	^true
]

{ #category : #'as yet unclassified' }
TMEDModelEditor >> validateMaComponent [
	^ self maComponent validate
]
