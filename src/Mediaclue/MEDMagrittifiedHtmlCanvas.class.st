Class {
	#name : #MEDMagrittifiedHtmlCanvas,
	#superclass : #MEDHtmlCanvas,
	#instVars : [
		'maContainerComponent'
	],
	#category : #'Mediaclue-View'
}

{ #category : #'as yet unclassified' }
MEDMagrittifiedHtmlCanvas >> descriptionFor: anAccessorLike [
	^ maContainerComponent magritteDescription atAccessor: anAccessorLike
]

{ #category : #'as yet unclassified' }
MEDMagrittifiedHtmlCanvas >> maChildComponentAt: anAccessorLike [
	| desc |
	desc := self descriptionFor: anAccessorLike.
	desc ifNil: [ ^ nil ].

	^ maContainerComponent childAt: desc
]

{ #category : #'as yet unclassified' }
MEDMagrittifiedHtmlCanvas >> maChildComponentAtDesc: aDescription [
	aDescription ifNil: [ ^ nil ].

	^ maContainerComponent childAt: aDescription
]

{ #category : #'as yet unclassified' }
MEDMagrittifiedHtmlCanvas >> maClassFor: aDescription [
	| classes |
	classes := OrderedCollection withAll: aDescription currentCssClasses.
	(self maHasError: aDescription)
		ifTrue: [ classes add: 'error' ].
	^ classes isEmpty
		ifFalse: [ classes reduce: [ :a :b | a , ' ' , b ] ]
]

{ #category : #accessing }
MEDMagrittifiedHtmlCanvas >> maContainerComponent [
	^ maContainerComponent
]

{ #category : #accessing }
MEDMagrittifiedHtmlCanvas >> maContainerComponent: anObject [
	maContainerComponent := anObject
]

{ #category : #'as yet unclassified' }
MEDMagrittifiedHtmlCanvas >> maControl: anAccessorLike [
	| desc |
	desc := self descriptionFor: anAccessorLike.
	self maControlDesc: desc
]

{ #category : #'as yet unclassified' }
MEDMagrittifiedHtmlCanvas >> maControlDesc: aDescription [
	| childComponent |
	
	childComponent := self maChildComponentAtDesc: aDescription.
	childComponent ifNil: [ ^ self ].
	
	self render: childComponent
]

{ #category : #'as yet unclassified' }
MEDMagrittifiedHtmlCanvas >> maFor: anAccessor do: aBlock [
	| desc |
	desc := self descriptionFor: anAccessor.
	desc ifNotNil: [
		aBlock cull: desc ]
]

{ #category : #'as yet unclassified' }
MEDMagrittifiedHtmlCanvas >> maGrid: anAccessor [
	| desc |
	desc := self descriptionFor: anAccessor.
	desc ifNil: [ ^ self ].

	self grid
		class: 'magritte';
		class: (self maClassFor: desc);
		with: [ 
			(self gridUnitFraction: 1/3)
				class: 'magritteLabel';
				with: [ self maLabel: anAccessor ].
			(self gridUnitFraction: 2/3)
				class: 'magritteControl';
				with: [ self maControl: anAccessor ] ].
]

{ #category : #'as yet unclassified' }
MEDMagrittifiedHtmlCanvas >> maHasError: aDescription [
	"Hinweis: Errors sind MAValidationError und im Attribute tag versteckt sich die magritte Description"
	^ maContainerComponent errors anySatisfy: [:each | each tag = aDescription]
]

{ #category : #'as yet unclassified' }
MEDMagrittifiedHtmlCanvas >> maIs: anAccessorLike equal: aValue [
	^ self maIs: anAccessorLike satisfying: [ :value | value = aValue ]
]

{ #category : #'as yet unclassified' }
MEDMagrittifiedHtmlCanvas >> maIs: anAccessorLike satisfying: aBlock [
	^ (aBlock value: (self maChildComponentAt: anAccessorLike) value) = true
]

{ #category : #'as yet unclassified' }
MEDMagrittifiedHtmlCanvas >> maIsBlank: anAccessorLike [
	^ (self maChildComponentAt: anAccessorLike) value isBlank
]

{ #category : #'as yet unclassified' }
MEDMagrittifiedHtmlCanvas >> maLabel: anAccessorLike [
	| desc |

	desc := self descriptionFor: anAccessorLike.
	self maLabelDesc: desc
]

{ #category : #'as yet unclassified' }
MEDMagrittifiedHtmlCanvas >> maLabelDesc: aDescription [
	| label childComponent |

	aDescription ifNil: [ ^ self ].
	aDescription hasLabel ifFalse: [ ^ self ].
	
	label := self label.
	childComponent := self maChildComponentAtDesc: aDescription.
	childComponent hasLabelId
		ifTrue: [ label for: childComponent labelId ].

	label with: [ self render: aDescription label]
]

{ #category : #'as yet unclassified' }
MEDMagrittifiedHtmlCanvas >> maRow: anAccessor [
	self maFor: anAccessor do: [ :desc |
		self tableRow: [
			self tableHeading: [ 
				self maLabelDesc: desc ].
			self tableData: [ 
				self maControlDesc: desc ].
		]]
]

{ #category : #'as yet unclassified' }
MEDMagrittifiedHtmlCanvas >> maRowIfNotBlank: anAccessor [
	(self maIsBlank: anAccessor) ifFalse: [
		self maRow: anAccessor]
]
