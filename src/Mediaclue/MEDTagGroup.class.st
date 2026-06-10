Class {
	#name : #MEDTagGroup,
	#superclass : #MEDModelObject,
	#instVars : [
		'title',
		'tags',
		'isMainTagGroup'
	],
	#category : #'Mediaclue-Models'
}

{ #category : #accessing }
MEDTagGroup class >> displayName [
	^'Schlagwortgruppe'
]

{ #category : #accessing }
MEDTagGroup class >> isVoyageRoot [
	^ true
]

{ #category : #'submorphs-add/remove' }
MEDTagGroup >> delete [
	self remove.
"	self cleanupAfterDeletion."

]

{ #category : #magritte }
MEDTagGroup >> descriptionIsMainTagGroup [
	<magritteDescription>
	^ MABooleanDescription new
		accessor: #isMainTagGroup;
		label: 'Ist Haupt-Schlagwortgruppe';
		trueString: 'Ja';
		falseString: 'Nein';
		yourself
]

{ #category : #magritte }
MEDTagGroup >> descriptionTags [
	<magritteDescription>
	^ MEDMaMultipleOptionDescription new
		accessor: #tags;
		label: 'Schlagwörter';
		optionsBlock: [ self db tags sortedBySortKey ];
		priority: 20;
		yourself
]

{ #category : #magritte }
MEDTagGroup >> descriptionTitle [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #title;
		label: 'Titel';
		priority: 10;
		beRequired;
		yourself
]

{ #category : #accessing }
MEDTagGroup >> displayName [
	^ self title
]

{ #category : #testing }
MEDTagGroup >> hasTag: aTag [
	^ tags includes: aTag
]

{ #category : #initialization }
MEDTagGroup >> initialize [
	super initialize.
	isMainTagGroup := false.
]

{ #category : #accessing }
MEDTagGroup >> isMainTagGroup [
	^ isMainTagGroup
]

{ #category : #accessing }
MEDTagGroup >> isMainTagGroup: anObject [
	isMainTagGroup := anObject
]

{ #category : #accessing }
MEDTagGroup >> tags [
	^ tags
]

{ #category : #accessing }
MEDTagGroup >> tags: anObject [
	tags := anObject
]

{ #category : #accessing }
MEDTagGroup >> title [
	^ title
]

{ #category : #accessing }
MEDTagGroup >> title: anObject [
	title := anObject
]
