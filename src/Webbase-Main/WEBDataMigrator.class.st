Class {
	#name : #WEBDataMigrator,
	#superclass : #WEBObject,
	#classVars : [
		'DoneMigrations'
	],
	#category : #'Webbase-Main-Database'
}

{ #category : #actions }
WEBDataMigrator class >> afterMigrate [
	"subclasses"
]

{ #category : #'as yet unclassified' }
WEBDataMigrator class >> beAllDone [
	DoneMigrations := Set new.
	DoneMigrations addAll: self migrationNames
]

{ #category : #'as yet unclassified' }
WEBDataMigrator class >> doMigration: aString [
	^self new doMigrationByName: aString
]

{ #category : #'as yet unclassified' }
WEBDataMigrator class >> doMigrationNumbered: anInteger [
	^self new doMigrationByNumber: anInteger
]

{ #category : #'as yet unclassified' }
WEBDataMigrator class >> doneMigration: aString [
	DoneMigrations ifNil: [ DoneMigrations := Set new ].

	DoneMigrations add: aString asString
]

{ #category : #initialization }
WEBDataMigrator class >> initialize [
	super initialize.
	self beAllDone.
]

{ #category : #testing }
WEBDataMigrator class >> isAllDone [
	^self undoneMigrations isEmpty
]

{ #category : #testing }
WEBDataMigrator class >> isMigrationDone: aNameString [
	^DoneMigrations includes: aNameString asString
]

{ #category : #actions }
WEBDataMigrator class >> migrate [
	"Do all undone migrations"
	"Ist bereits sortiert."
	self isAllDone ifFalse: [
		self undoneMigrations do: [ :each | self doMigration: each ].
		self afterMigrate.
	]
]

{ #category : #'as yet unclassified' }
WEBDataMigrator class >> migrationNames [
	| names |
	names := (self selectors select: [ :each | each matchesRegex: '^m\d\d\d.*$' ])
		collect: [ :each | each asString copyWithoutFirst ].
		
	^names sortedBy: [ :each | each asLowercase ]
]

{ #category : #actions }
WEBDataMigrator class >> showUndoneMigrations [
	self undoneMigrations inspect
	
	
]

{ #category : #actions }
WEBDataMigrator class >> undoneMigrations [
	^self migrationNames reject: [ :each | self isMigrationDone: each ].
	
	
]

{ #category : #helpers }
WEBDataMigrator >> doMigrationByName: aNumberAndTitleString [
	| migrationSelector |
	
	migrationSelector := ('m', aNumberAndTitleString) asSymbol.
	
	self perform: migrationSelector.

	Transcript
		cr;
		show: ('Migration: ', aNumberAndTitleString).
		
	self doneMigration: aNumberAndTitleString.
	
	Smalltalk garbageCollect.
]

{ #category : #helpers }
WEBDataMigrator >> doMigrationByNumber: aNumber [
	| migrationName prefix |
	
	prefix := (aNumber printPaddedWith: $0 to: 3).
	migrationName := self class migrationNames detect: [ :each | each beginsWith: prefix ].
	
	self doMigrationByName: migrationName

]

{ #category : #helpers }
WEBDataMigrator >> doneMigration: aString [
	self class doneMigration: aString
]
