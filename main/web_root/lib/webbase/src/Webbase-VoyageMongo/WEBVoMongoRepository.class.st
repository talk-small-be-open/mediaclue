Class {
	#name : #WEBVoMongoRepository,
	#superclass : #VOMongoRepository,
	#traits : 'TWEBGlobalHelpers',
	#classTraits : 'TWEBGlobalHelpers classTrait',
	#instVars : [
		'binCommand'
	],
	#category : #'Webbase-VoyageMongo'
}

{ #category : #initialization }
WEBVoMongoRepository >> binCommand [
	self ifDevelopment: [
		^ 'podman exec mediaclueDB-mongo363 mongo' ].

	^ '/usr/bin/mongo'.
	
	

]

{ #category : #'as yet unclassified' }
WEBVoMongoRepository >> createIndex: aDictionary on: aCollectionName [
	^ self createIndex: aDictionary on: aCollectionName options: { }

]

{ #category : #'as yet unclassified' }
WEBVoMongoRepository >> createIndex: aDictionary on: aCollectionName options: anOptionsDictionary [
	| cmd |
	cmd := (self binCommand), ' --eval ''',
	'db.getSiblingDB("', databaseName, '").', aCollectionName, '.','createIndex(', aDictionary asD asJson, ', ', anOptionsDictionary asD asJson, ' )'''.
	
	"dict: {''receipts.description'':1}"
	
	WEBSystemCommand run: cmd
]

{ #category : #'as yet unclassified' }
WEBVoMongoRepository >> dropIndexesOn: aCollectionName [
	| cmd |
	cmd := (self binCommand), ' <<EOF ','
db.getSiblingDB("', databaseName, '").', aCollectionName, '.','dropIndexes()
EOF'.

	WEBSystemCommand run: cmd
]

{ #category : #initialization }
WEBVoMongoRepository >> initialize [
	super initialize.
		
"Superklasse:	self wireProtocolEnabled: true.
	self ensuringCurrentOnSave: false.
	self ensuringCurrentReferencesOnQueries: false.
	self lazySynchronize: false."

	"Damit wir ein rereadFromDatabase machen können"
"	self ensuringCurrentReferencesOnQueries: true.
	self lazySynchronize: false."

]
