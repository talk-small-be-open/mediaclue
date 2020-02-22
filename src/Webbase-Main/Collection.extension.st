Extension { #name : #Collection }

{ #category : #'*Webbase-Main' }
Collection >> add: anObject if: aValuable [
	aValuable value ifTrue: [^self add: anObject]
]

{ #category : #'*Webbase-Main' }
Collection >> addAllIfNotPresent: aCollection [
	aCollection do: [ :each | self addIfNotPresent: each ]
]

{ #category : #'*Webbase-Main' }
Collection >> addIfNotBlank: anObject [
	^self add: anObject if: anObject isBlank not
]

{ #category : #'*Webbase-Main' }
Collection >> addIfNotNil: anObject [
	^self add: anObject if: anObject isNil not
]

{ #category : #'*Webbase-Main' }
Collection >> addIfNotPresent: anObject then: aBlock [

	(self includes: anObject) ifFalse: [
		self add: anObject.
		aBlock cull: anObject].

	^ anObject
]

{ #category : #'*Webbase-Main' }
Collection >> allEqual: aBlock [
	"Prüft, ob alle mit aBlock berechneten Werte gleich sind"
	| any |
	any := aBlock value: self anyOne.
	^self allSatisfy: [:each | (aBlock value: each) = any]
]

{ #category : #'*Webbase-Main' }
Collection >> anyOneOrNil [
	^self ifEmpty: [nil] ifNotEmpty: [:me | me anyOne]
]

{ #category : #'*Webbase-Main' }
Collection >> asD [
	"Kurzversion, wegen einfacherem Aufbau von Javascript Dictionaries"
	^self asDictionary
]

{ #category : #'*Webbase-Main' }
Collection >> collectAsSet: aBlock [
	^self inject: Set new into: [ :set :each | 
		set add: (aBlock value: each); yourself]
]

{ #category : #'*Webbase-Main' }
Collection >> copyWithItems [
	^self collect: #copy
]

{ #category : #'*Webbase-Main' }
Collection >> copyWithoutBlanks [
	"Answer a copy of the receiver that does not contain any
	elements that are either nil or empty strings. Use only with collections of strings!"

	^self reject: [:each | each isBlank]
]

{ #category : #'*Webbase-Main' }
Collection >> copyWithoutNils [
	"Answer a copy of the receiver that does not contain nils"
	^self copyWithout: nil
]

{ #category : #'*Webbase-Main' }
Collection >> detectNonBlank [
	^self detectNonBlank: [ :each | each ] ifFound: [ :each | each ]
]

{ #category : #'*Webbase-Main' }
Collection >> detectNonBlank: aBlock ifFound: aFoundBlock [
	"Sucht den ersten durch aBlock berechneten Wert welcher nicht blank ist. Liefert diesen an den aFoundBlock"
	| value |
	self detect: [:each | value := aBlock value: each. value notBlank] ifFound: [^aFoundBlock value: value].

	^nil
]

{ #category : #'*Webbase-Main' }
Collection >> detectNonBlank: aBlock ifNone: aNoneBlock [
	"Sucht den ersten durch aBlock berechneten Wert welcher nicht blank ist. Liefert diesen oder
	sonst den aNoneBlock Wert"
	| value |
	self detect: [:each | value := aBlock value: each. value notBlank] ifNone: [^aNoneBlock value].
	^value
]

{ #category : #'*Webbase-Main' }
Collection >> equalElements: aCollection [
	^self size = aCollection size and: [
		self allSatisfy: [:each | aCollection includes: each]]
]

{ #category : #'*Webbase-Main' }
Collection >> groupedBy: aGroupBlock sortedBy: aSortBlock [
	| grouped sortedKeys dict|
	"sorted := self sortedBySortKey."
	grouped := self groupedBy: aGroupBlock.
	sortedKeys := grouped keys sortedBy: aSortBlock.
	
	"Abfüllen in sortierbaren Dictionary"
	dict := OrderPreservingDictionary new.
	
	sortedKeys do: [:each |
		dict at: each put: (grouped at: each) sortedBySortKey].
	
	^dict
]

{ #category : #'*Webbase-Main' }
Collection >> groupedBy: aGroupBlock sortedBy: aSortBlock subSortedBy: aSubSortBlock [
	| grouped sorted result sortedKeys dict|
	"sorted := self sortedBySortKey."
	grouped := self groupedBy: aGroupBlock.
	sortedKeys := grouped keys sortedBy: aSortBlock.
	
	"Abfüllen in sortierbaren Dictionary"
	dict := OrderPreservingDictionary new.
	
	sortedKeys do: [:each |
		dict at: each put: ((grouped at: each) sortedBy: aSubSortBlock)].
	
	^dict
]

{ #category : #'*Webbase-Main' }
Collection >> groupedBy: aGroupBlock subSortedBy: aSubSortBlock [
	^self groupedBy: aGroupBlock sortedBy: [:e | 0] subSortedBy: aSubSortBlock
]

{ #category : #'*Webbase-Main' }
Collection >> groupedByMany: aBlock [
	"Answer a dictionary whose keys are the result of evaluating aBlock
	for all my elements, and the value for each key is the selection of 
	my elements that evaluated to that key. Uses species."
	| groups |
	groups := PluggableDictionary integerDictionary.
	self do: [ :each |
		(aBlock value: each) do: [:eachValue |
			(groups at: eachValue ifAbsentPut: [ OrderedCollection new ]) add: each ]].

	self species ~~ OrderedCollection ifTrue: [
		groups associationsDo: [ :association |
			association value: (self species withAll: association value) ]].

	^ groups

]

{ #category : #'*Webbase-Main' }
Collection >> groupedByMany: aGroupBlock sortedBy: aSortBlock subSortedBy: aSubSortBlock [
	| grouped sortedKeys dict|

	grouped := self groupedByMany: aGroupBlock.
	sortedKeys := grouped keys sortedBy: aSortBlock.
	
	"Abfüllen in sortierbaren Dictionary"
	dict := OrderPreservingDictionary new.
	
	sortedKeys do: [:each |
		dict at: each put: ((grouped at: each) sortedBy: aSubSortBlock)].
	
	^dict
]

{ #category : #'*Webbase-Main' }
Collection >> identityIncludesAll: aCollection [ 
	"Answer whether any element of aCollection is one of the receiver's elements. Identity check"
	aCollection do: [:elem | (self identityIncludes: elem) ifFalse: [^false]].
	^true
]

{ #category : #'*Webbase-Main' }
Collection >> identityIncludesAny: aCollection [ 
	"Answer whether any element of aCollection is one of the receiver's elements. Identity check"
	aCollection do: [:elem | (self identityIncludes: elem) ifTrue: [^ true]].
	^ false
]

{ #category : #'*Webbase-Main' }
Collection >> identityRemove: anObject [
	self removeAllSuchThat: [:each | each == anObject]
]

{ #category : #'*Webbase-Main' }
Collection >> includesNil [
	^self includes: nil
]

{ #category : #'*Webbase-Main' }
Collection >> isBlank [
	^self isEmpty
]

{ #category : #'*Webbase-Main' }
Collection >> map: aBlock [
	"Create a Dictionary with the original elements as keys and the
	value from the aBlock. Note, that equal elements result in only 1 key/value"
	| map |
	map := OrderedDictionary new.
	self do: [ :each |
		map at: each put: (aBlock value: each)
	].
	^map
]

{ #category : #'*Webbase-Main' }
Collection >> notAllEqual: aBlock [
	^(self allEqual: aBlock) not
]

{ #category : #'*Webbase-Main' }
Collection >> oneAndAllSatisfy: aBlock [
	"Alle und mind. 1"

	self ifEmpty: [ ^false ].
	
	^self allSatisfy: aBlock
]

{ #category : #'*Webbase-Main' }
Collection >> removeBlanks [
	self removeAllSuchThat: [:each | each isBlank]
]

{ #category : #'*Webbase-Main' }
Collection >> removeIfPresent: anObject [
	^self remove: anObject ifAbsent: [  ]
]

{ #category : #'*Webbase-Main' }
Collection >> removeNils [
	self removeAllSuchThat: [:each | each isNil]
]

{ #category : #'*Webbase-Main' }
Collection >> selectKindOf: aClass [
	^self select: [ :each | each isKindOf: aClass]
]

{ #category : #'*Webbase-Main' }
Collection >> sortByKey: aSymbolOrBlock [
	"Hinweis: GemStone definiert bereits sortBy:, deshalb anderer Name"
	self sort: [:a :b | (aSymbolOrBlock value: a) <= (aSymbolOrBlock value: b)]
]

{ #category : #'*Webbase-Main' }
Collection >> sortBySortKey [
	^self sortByKey: #sortKey
]

{ #category : #'*Webbase-Main' }
Collection >> sortReversedBy: aSymbolOrBlock [
	self sort: [:a :b | (aSymbolOrBlock value: b) <= (aSymbolOrBlock value: a)]
]

{ #category : #'*Webbase-Main' }
Collection >> sortedBy: aSymbolOrBlock [
	^self sorted: [:a :b | (aSymbolOrBlock value: a) <= (aSymbolOrBlock value: b)]
]

{ #category : #'*Webbase-Main' }
Collection >> sortedBySortKey [
	^self sortedBy: #sortKey
]

{ #category : #'*Webbase-Main' }
Collection >> sortedGroupedBy: aGroupBlock [
	| grouped sorted result sortedKeys dict|
	"sorted := self sortedBySortKey."
	grouped := self groupedBy: aGroupBlock.
	sortedKeys := grouped keys sorted.
	
	"Abfüllen in sortierbaren Dictionary"
	dict := OrderPreservingDictionary new.
	
	sortedKeys do: [:each |
		dict at: each put: (grouped at: each) sortedBySortKey].
	
	^dict
]

{ #category : #'*Webbase-Main' }
Collection >> sortedReversedBy: aSymbolOrBlock [
	^self sorted: [:a :b | (aSymbolOrBlock value: b) <= (aSymbolOrBlock value: a)]
]
