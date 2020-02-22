Class {
	#name : #WEBVoyageMongoDatabase,
	#superclass : #WEBDatabase,
	#category : #'Webbase-VoyageMongo'
}

{ #category : #'as yet unclassified' }
WEBVoyageMongoDatabase class >> useDatabase: aDatabase [
	super useDatabase: aDatabase.
	Current setUpVoyageConnection.
"zu früh bei Installation	Current setUpCouchDbConnection."
]

{ #category : #'as yet unclassified' }
WEBVoyageMongoDatabase >> createMongoIndexes [
	"subclasses"
]

{ #category : #initialization }
WEBVoyageMongoDatabase >> initializeGlobalConfiguration [
	super initializeGlobalConfiguration.
	globalConfiguration save
]

{ #category : #initialization }
WEBVoyageMongoDatabase >> setUpVoyageConnection [
	| repository |

	"WICHTIG: Wegen bootstrapping hier die GlobalConfiguration nicht verwenden,
	weil die ja in der MonoDB selbst drin ist. Stattdessen nur ProjectInfo oder anderes"

	self isDevelopment ifTrue: [
		repository := WEBVoMongoRepository 
			host: 'localhost' 
			database: self pi projectCode.
	]. 

	self isTesting ifTrue: [
		repository := WEBVoTestMongoRepository 
			host: 'localhost' 
			database: (self pi projectCode, '-testing').
	].

	self isProductionOrAlike ifTrue: [
		repository := WEBVoMongoRepository 
			host: 'localhost' 
			database: self pi projectCode
			username: self pi projectCode
			password: self pi mongoDbPassword.
	].
	
	repository
		enableSingleton.
		
	self voyageDbReady
]

{ #category : #'as yet unclassified' }
WEBVoyageMongoDatabase >> voyageDbReady [
	self initializeGlobalConfiguration.
	self createMongoIndexes.
]
