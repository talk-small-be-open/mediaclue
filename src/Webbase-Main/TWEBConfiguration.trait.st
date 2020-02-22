Trait {
	#name : #TWEBConfiguration,
	#category : #'Webbase-Main-Traits'
}

{ #category : #'as yet unclassified' }
TWEBConfiguration >> ancestorValuesAt: aKey [
	^self ancestors collect: [ :each | each at: aKey ]
]

{ #category : #'as yet unclassified' }
TWEBConfiguration >> ancestors [
	| ancestors |
	ancestors := OrderedCollection new.
	self meAndParentDo: [:each | ancestors add: each].
	^ancestors
]

{ #category : #'as yet unclassified' }
TWEBConfiguration >> at: aKey [
	^self localValueAt: aKey ifAbsent: [self lookupValueAt: aKey]
]

{ #category : #accessing }
TWEBConfiguration >> at: aKey add: anItem [
	| collection |
	collection := self localValueAt: aKey ifAbsentPut: [OrderedCollection new].
	collection add: anItem.
	self changedKey: aKey.
	^anItem
]

{ #category : #accessing }
TWEBConfiguration >> at: aKey addAll: aCollection [
	| collection |
	collection := self localValueAt: aKey ifAbsentPut: [OrderedCollection new].
	collection addAll: aCollection.
	self changedKey: aKey.
	^aCollection
]

{ #category : #'as yet unclassified' }
TWEBConfiguration >> at: aKey ifAbsentPut: aBlock [
	^(self at: aKey) ifNil: [ self at: aKey put: aBlock value ]

]

{ #category : #accessing }
TWEBConfiguration >> at: aKey ifBlank: aBlock [
	| value |
	value := self at: aKey.
	value isBlank ifTrue: [^aBlock value].
	^value
]

{ #category : #'as yet unclassified' }
TWEBConfiguration >> at: aKey ifEmptyOrNil: aBlock [
	| value |
	value := self at: aKey.
	value isEmptyOrNil ifTrue: [^aBlock value].
	^value
]

{ #category : #'as yet unclassified' }
TWEBConfiguration >> at: aKey ifNil: aBlock [
	| value |
	value := self at: aKey.
	value isNil ifTrue: [^aBlock value].
	^value
]

{ #category : #accessing }
TWEBConfiguration >> at: aKey put: anObject [
	self localDictionary at: aKey asSymbol put: anObject.
	self changedKey: aKey.
	^anObject
]

{ #category : #accessing }
TWEBConfiguration >> at: aKey remove: anItem [
	| collection |
	collection := self localValueAt: aKey ifAbsent: nil.
	collection ifNotNil: [
		collection remove: anItem].
	self save
]

{ #category : #accessing }
TWEBConfiguration >> at: aKey removeAll: aCollection [
	| collection |
	collection := self localValueAt: aKey ifAbsent: nil.
	collection ifNotNil: [
		collection removeAllFoundIn: aCollection].
	self save
]

{ #category : #'as yet unclassified' }
TWEBConfiguration >> changedKey: aSymbol [
]

{ #category : #'as yet unclassified' }
TWEBConfiguration >> gatherAllAt: aKey [
	^(self ancestorValuesAt: aKey) gather: [:each | each]
]

{ #category : #testing }
TWEBConfiguration >> hasLocalValueAt: aKey [
	^self localDictionary includesKey: aKey asSymbol
]

{ #category : #'as yet unclassified' }
TWEBConfiguration >> hasParent [
	^self parent notNil
]

{ #category : #'as yet unclassified' }
TWEBConfiguration >> inheritedValueAt: aKey [
	^self lookupValueAt: aKey
]

{ #category : #accessing }
TWEBConfiguration >> localDictionary [
	self subclassResponsibility
]

{ #category : #accessing }
TWEBConfiguration >> localKeys [
	^self localDictionary keys
]

{ #category : #'as yet unclassified' }
TWEBConfiguration >> localValueAt: aKey [
	^self localValueAt: aKey ifAbsent: [nil]
]

{ #category : #'as yet unclassified' }
TWEBConfiguration >> localValueAt: aKey ifAbsent: aBlock [
	^self localDictionary at: aKey asSymbol ifAbsent: aBlock

]

{ #category : #'as yet unclassified' }
TWEBConfiguration >> localValueAt: aKey ifAbsentPut: anObject [
	^self localDictionary at: aKey asSymbol ifAbsentPut: anObject

]

{ #category : #'as yet unclassified' }
TWEBConfiguration >> lookupValueAt: aKey [
	^self hasParent ifTrue: [self parent at: aKey]
]

{ #category : #'as yet unclassified' }
TWEBConfiguration >> meAndParentDo: aBlock [
	aBlock value: self.
	self hasParent ifTrue: [
		self parent meAndParentDo: aBlock]
]

{ #category : #accessing }
TWEBConfiguration >> parent [
	^self globalConfiguration
]

{ #category : #helper }
TWEBConfiguration >> prepopulateEmptyValues [
	(self class selectorsInCategory: 'configs') do: [ :each |
		each isUnary ifTrue: [
			(self perform: each) ifNil: [
				self perform: each asMutator with: ''.
					"Falls setzen mit Blank nichts gebracht hat, bei Passwörtern oder so:"
					(self perform: each) ifNil: [
						self perform: each asMutator with: '***'.
					]

			]
		]
	]
]

{ #category : #'instance creation' }
TWEBConfiguration >> rename: aKey to: aNewKey [
	| value |
	value := self localDictionary at: aKey asSymbol ifAbsent: [^self].

	self localDictionary at: aNewKey asSymbol put: value.
	self localDictionary removeKey: aKey asSymbol
]

{ #category : #'as yet unclassified' }
TWEBConfiguration >> resetIfEqualsInherited: aKey [
	((self inheritedValueAt: aKey) = (self localValueAt: aKey)) ifTrue: [
		self clearValueAt: aKey]
]
