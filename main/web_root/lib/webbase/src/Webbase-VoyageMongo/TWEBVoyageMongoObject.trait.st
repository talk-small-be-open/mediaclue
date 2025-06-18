Trait {
	#name : #TWEBVoyageMongoObject,
	#category : #'Webbase-VoyageMongo'
}

{ #category : #'as yet unclassified' }
TWEBVoyageMongoObject classSide >> createMongoIndex: aDictionary [
	self voyageRepository createIndex: aDictionary on: self voyageCollectionName
]

{ #category : #'as yet unclassified' }
TWEBVoyageMongoObject classSide >> createMongoIndex: aDictionary options: anOptionsDictionary [
	self voyageRepository createIndex: aDictionary on: self voyageCollectionName options: anOptionsDictionary
]

{ #category : #'as yet unclassified' }
TWEBVoyageMongoObject classSide >> createMongoIndexField: aString [
	| dict |
	dict := { aString->1 }.
	self createMongoIndex: dict
]

{ #category : #'as yet unclassified' }
TWEBVoyageMongoObject classSide >> createMongoTextIndexFields: aCollection [
	| dict |
	dict := aCollection collect: [ :each | each->'text' ].
	self createMongoIndex: dict options: { 'default_language'->'de' }
]

{ #category : #testing }
TWEBVoyageMongoObject classSide >> isVoyageRoot [
	self shouldBeImplemented
]

{ #category : #'as yet unclassified' }
TWEBVoyageMongoObject classSide >> mongoContainer [ 
	<mongoContainer>
	
	"TODO in user class: Overwrite this method in the traits user, since the pragma will not be found by Voyage"
	self subclassResponsibility.

	^WEBVoContainer new 
]

{ #category : #'as yet unclassified' }
TWEBVoyageMongoObject classSide >> voyageCollectionName [
	^self persistentClass name allButFirst: 3
]

{ #category : #'as yet unclassified' }
TWEBVoyageMongoObject >> afterRemove [
	"subclasses"
]

{ #category : #'as yet unclassified' }
TWEBVoyageMongoObject >> beforeSave [
	self ensureUuid
]

{ #category : #actions }
TWEBVoyageMongoObject >> remove [
	super remove.
	self afterRemove.

]

{ #category : #'as yet unclassified' }
TWEBVoyageMongoObject >> rereadFromDatabase [
	self class voyageRepository synchronize: self
]

{ #category : #actions }
TWEBVoyageMongoObject >> save [
	self beforeSave.
	super save.
"	self afterSave"
]
