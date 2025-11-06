Trait {
	#name : #TMEDTaggable,
	#category : #'Mediaclue-Traits'
}

{ #category : #'as yet unclassified' }
TMEDTaggable classSide >> descriptionTagTitleList [
	<mongoDescription>
	^ VOMongoShadowDescription new
		accessor: #tagTitleList;
		transformationBlock: [ :each | each ];
		attributeName: #tagTitleList;
		yourself
]

{ #category : #magritte }
TMEDTaggable classSide >> mongoTagList [
	"TODO: Override mit klassenspezifischen Namen der Instanzvariable"
	self subclassResponsibility
"	<mongoDescription>
	
	^VOToManyDescription new
		attributeName: '<INSTANZVARIABLE-NAME>';
		beEager;
		yourself"
]

{ #category : #accessing }
TMEDTaggable classSide >> suggestedTags [
"	| all |"
	^self db tags sortedBySortKey
"Sammeln aus bestehender Verwendung"
"	all := OrderedCollection new.
	self selectAll do: [:each | each tagList ifNotBlank: [:tl | all addAll: tl]].
	^all asSet sortedBySortKey"
]

{ #category : #'as yet unclassified' }
TMEDTaggable >> addTag: aTag [
	self tags: (self tags copyWith: aTag)
]

{ #category : #'as yet unclassified' }
TMEDTaggable >> addTags: aCollection [
	self tags: (self tags copyWithAll: aCollection asArray)
]

{ #category : #accessing }
TMEDTaggable >> addTagsCommaSeparated: aString [
	| tagsByString |
	tagsByString := MEDTag tagsFromString: aString.

	self addTags: tagsByString
]

{ #category : #'as yet unclassified' }
TMEDTaggable >> clearTags [
	self tagList ifNotBlank: [:tl | tl removeAll]
]

{ #category : #magritte }
TMEDTaggable >> descriptionTags [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #tagsCommaSeparatedTrimmed;
		label: 'Schlagworte';
		componentClass: MEDMaTagListInputComponent;
		beRequired;
"		addCondition: [:value | MEDTag stringContainsSchoolSubject: value ] labelled: 'Es muss ein Fach als Schlagwort enthalten sein.';"
		yourself
]

{ #category : #magritte }
TMEDTaggable >> descriptionTagsReadonly [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #tagsCommaSeparated;
		label: 'Schlagworte';
		beReadonly;
		yourself
]

{ #category : #testing }
TMEDTaggable >> hasAnyTag: aCollection [
	^aCollection anySatisfy: [ :each | self hasTag: each ]
]

{ #category : #testing }
TMEDTaggable >> hasTag: aTag [
	^self tagList
		ifNil: [false]
		ifNotNil: [:tl |
			tl includes: aTag]
]

{ #category : #testing }
TMEDTaggable >> hasTags: aCollection [
	^aCollection allSatisfy: [ :each | self hasTag: each ]
]

{ #category : #testing }
TMEDTaggable >> matchesAnyTag: aCollection [
	^aCollection anySatisfy: [ :each | self matchesTag: each ]
]

{ #category : #testing }
TMEDTaggable >> matchesTag: aTag [
	"Subklassen können smarter reagieren"
	^self hasTag: aTag
]

{ #category : #testing }
TMEDTaggable >> matchesTagGrouping: aDictionary [
	^aDictionary allSatisfy: [ :tags |
		self matchesAnyTag: tags
	]
]

{ #category : #'as yet unclassified' }
TMEDTaggable >> removeTag: aTag [
	self tags: (self tags copyWithout: aTag)
]

{ #category : #'as yet unclassified' }
TMEDTaggable >> removeTags: aCollection [
	self tags: (self tags copyWithoutAll: aCollection asArray)
]

{ #category : #'as yet unclassified' }
TMEDTaggable >> schoolSubjectTags [
	^ self tags select: [ :each | each isSchoolSubject = true ]
]

{ #category : #accessing }
TMEDTaggable >> suggestedTags [
	^self class suggestedTags
]

{ #category : #accessing }
TMEDTaggable >> tagList [
	self subclassResponsibility
]

{ #category : #accessing }
TMEDTaggable >> tagList: aCollection [
	self subclassResponsibility
]

{ #category : #accessing }
TMEDTaggable >> tagTitleList [
	^self tags collect: [ :each | each title ]
]

{ #category : #accessing }
TMEDTaggable >> tags [
	^ self tagList
		ifBlank: [#()]
		ifNotBlank: [ :tl | tl asOrderedCollection "Kopie UND kein Set" ]
]

{ #category : #scripting }
TMEDTaggable >> tags: aCollection [
	aCollection ifBlank: [ self clearTags. ^self ].

	self tagList: aCollection asSet copy
]

{ #category : #accessing }
TMEDTaggable >> tagsCommaSeparated [
	^(self tags collect: [ :each | each displayName ]) sorted joinUsing: ', '
]

{ #category : #accessing }
TMEDTaggable >> tagsCommaSeparated: aString [
	| tagsByString |
	tagsByString := MEDTag tagsFromString: aString.
	
	self tags: tagsByString
]

{ #category : #accessing }
TMEDTaggable >> tagsCommaSeparatedTrimmed [
	^(self tags collect: [ :each | each displayName ]) sorted joinUsing: ','
]

{ #category : #accessing }
TMEDTaggable >> tagsCommaSeparatedTrimmed: aValue [
	^ self tagsCommaSeparated: aValue
]
