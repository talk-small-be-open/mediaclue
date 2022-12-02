Class {
	#name : #MEDPortfolio,
	#superclass : #MEDModelObject,
	#instVars : [
		'user',
		'uploading',
		'clipboard',
		'allMyMedias',
		'searchQueries',
		'lastSearchQuery'
	],
	#category : #'Mediaclue-Models'
}

{ #category : #testing }
MEDPortfolio class >> isVoyageRoot [
	^false
]

{ #category : #accessing }
MEDPortfolio class >> user: aUser [
	^ self basicNew
		setUser: aUser;
		initialize;
		yourself
]

{ #category : #adding }
MEDPortfolio >> addSearchQuery: aSearchQuery [
	searchQueries add: aSearchQuery copy
]

{ #category : #accessing }
MEDPortfolio >> allMyMedias [
	^ allMyMedias
]

{ #category : #accessing }
MEDPortfolio >> cleanup [

	allMyMedias refresh.
	
	"Touch the uploading set, to maybe lazy generate"
	self uploading.
]

{ #category : #accessing }
MEDPortfolio >> clipboard [
	^ clipboard
]

{ #category : #initialization }
MEDPortfolio >> initialize [
	super initialize.

	clipboard := MEDClipboard new.
	allMyMedias := MEDMyMediasSet new user: user; yourself.
	searchQueries := OrderedCollection new.
	
	self newUploading
]

{ #category : #accessing }
MEDPortfolio >> lastSearchQuery [
	lastSearchQuery ifNil: [ lastSearchQuery := MEDSearchQuery new ].
	^ lastSearchQuery
]

{ #category : #accessing }
MEDPortfolio >> lastSearchQuery: anObject [
	lastSearchQuery := anObject
]

{ #category : #accessing }
MEDPortfolio >> mediaSets [
	^ (self db findMediaSetsByOwner: user) copyWithout: self uploading
]

{ #category : #'instance creation' }
MEDPortfolio >> newUploading [
	uploading := MEDMediaSet new
		title: 'Aktuelle Hochladekollektion';
		owner: user;
		yourself.
		
	self save.
]

{ #category : #adding }
MEDPortfolio >> removeSearchQuery: aSearchQuery [
	searchQueries remove: aSearchQuery
]

{ #category : #actions }
MEDPortfolio >> save [
	user save
]

{ #category : #accessing }
MEDPortfolio >> searchQueries [
	^ searchQueries
]

{ #category : #initialization }
MEDPortfolio >> setUser: aUser [
	user := aUser
]

{ #category : #accessing }
MEDPortfolio >> uploading [
	"Careful! ifNil: would not be useful with VOMissingContent objects. More robust to use isNil."
	uploading isNil ifTrue: [ self newUploading ].
	
	^ uploading
]
