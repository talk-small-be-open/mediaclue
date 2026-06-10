Class {
	#name : #MEDFrontendSession,
	#superclass : #WEBFrontendSession,
	#instVars : [
		'topTags',
		'myTopTags',
		'myMediaSets',
		'canUpload',
		'mainTags',
		'mainTagGroups'
	],
	#category : #'Mediaclue-View'
}

{ #category : #'as yet unclassified' }
MEDFrontendSession >> announceDataChange [
	self invalidateCaches
]

{ #category : #accessing }
MEDFrontendSession >> canUpload [
	^ canUpload ifNil: [ canUpload := self user canUpload ]
]

{ #category : #'as yet unclassified' }
MEDFrontendSession >> invalidateCaches [
	self refreshCaches
]

{ #category : #protocol }
MEDFrontendSession >> login: aUser [
	super login: aUser.

	self refreshCaches
]

{ #category : #accessing }
MEDFrontendSession >> mainTagGroups [
	^ mainTagGroups
]

{ #category : #accessing }
MEDFrontendSession >> mainTags [
	^ mainTags
]

{ #category : #accessing }
MEDFrontendSession >> myMediaSets [
	^ myMediaSets ifNil: [ myMediaSets := self user portfolio mediaSets ]
]

{ #category : #accessing }
MEDFrontendSession >> myTopTags [
	^ myTopTags
]

{ #category : #'as yet unclassified' }
MEDFrontendSession >> refreshCaches [
	self user portfolio cleanup.
	
	mainTags := self db mainTags sortedBySortKey.
	mainTagGroups := self db mainTagGroups sortedBySortKey.
	topTags := self db topTags: 10 excluding: mainTags.
	myTopTags := self db topTags: 10 excluding: mainTags by: self user.
	myMediaSets := nil.
	canUpload := nil.
]

{ #category : #accessing }
MEDFrontendSession >> topTags [
	^ topTags
]
