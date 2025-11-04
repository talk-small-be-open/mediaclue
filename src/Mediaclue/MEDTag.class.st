Class {
	#name : #MEDTag,
	#superclass : #MEDModelObject,
	#instVars : [
		'title',
		'category',
		'isSchoolSubject'
	],
	#category : #'Mediaclue-Models'
}

{ #category : #accessing }
MEDTag class >> displayName [
	^'Schlagwort'
]

{ #category : #'as yet unclassified' }
MEDTag class >> findOrCreateFromString: aString [
	^self db findOrCreateTagByTitle: aString
]

{ #category : #testing }
MEDTag class >> isVoyageRoot [
	^true
]

{ #category : #'as yet unclassified' }
MEDTag class >> stringContainsSchoolSubject: aString [
	^ (self tagsFromString: aString) anySatisfy: [ :each | each isSchoolSubject ]
]

{ #category : #'as yet unclassified' }
MEDTag class >> stringFromTags: aCollection [
	^(aCollection collect: #title) joinUsing: ', '
]

{ #category : #'as yet unclassified' }
MEDTag class >> tagsFromString: aString [
	aString ifBlank: [ ^ #() ].
	
	^((self tokenize: aString) collect: [ :each |
		self findOrCreateFromString: each trimBoth]) copyWithoutNils
]

{ #category : #parsing }
MEDTag class >> tokenize: aString [
	^ (aString findTokens: ',')
]

{ #category : #'as yet unclassified' }
MEDTag class >> validateTitle: aString [
	aString ifBlank: [ ^false ].
	aString isString ifFalse: [ ^false ].
	aString size > 50 ifTrue: [ ^false ].

	^true
]

{ #category : #'submorphs-add/remove' }
MEDTag >> canBeDeleted [
	^ (self db isTagInUse: self) not

]

{ #category : #accessing }
MEDTag >> category [
	^ category
]

{ #category : #accessing }
MEDTag >> category: anObject [
	category := anObject
]

{ #category : #magritte }
MEDTag >> descriptionCategory [
	<magritteDescription>
	^MASingleOptionDescription new
		accessor: #category;
		options: {'00_Thema'. '10_Fach'. '20_Etc'};
		label: 'Kategorie';
		beRequired;
		yourself
]

{ #category : #magritte }
MEDTag >> descriptionIsSchoolSubject [
	<magritteDescription>
	^ MABooleanDescription new
		accessor: #isSchoolSubject;
		label: 'Ist Schulfach';
		yourself
]

{ #category : #magritte }
MEDTag >> descriptionTitle [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #title;
		label: 'Titel';
		beRequired;
		yourself
]

{ #category : #accessing }
MEDTag >> displayName [
	^self title
]

{ #category : #initialization }
MEDTag >> initialize [

	super initialize.

	category := '00_Thema'.
	isSchoolSubject := false.
]

{ #category : #testing }
MEDTag >> isSchoolSubject [
	^ isSchoolSubject
]

{ #category : #testing }
MEDTag >> isSchoolSubject: aBoolean [
	isSchoolSubject := aBoolean
]

{ #category : #accessing }
MEDTag >> sortKey [
	^String streamContents: [ :s |
		category
			ifBlank: [ s << 'zzzzzzzzzzzzz' ]
			ifNotBlank: [s << category asLowercase].
		s << title asLowercase.
	]
]

{ #category : #accessing }
MEDTag >> title [
	^ title
]

{ #category : #accessing }
MEDTag >> title: aString [
	title := aString trimBoth
]
