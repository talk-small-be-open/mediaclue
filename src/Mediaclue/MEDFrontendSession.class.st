Class {
	#name : #MEDFrontendSession,
	#superclass : #WEBFrontendSession,
	#instVars : [
		'topTags',
		'myTopTags',
		'schoolSubjectTags',
		'myMediaSets',
		'canUpload'
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
MEDFrontendSession >> myMediaSets [
	^ myMediaSets ifNil: [ myMediaSets := self user portfolio mediaSets ]
]

{ #category : #accessing }
MEDFrontendSession >> myTopTags [
	^ myTopTags
]

{ #category : #'as yet unclassified' }
MEDFrontendSession >> refreshCaches [
	schoolSubjectTags := self db schoolSubjectTags sortedBySortKey.
	topTags := self db topTags: 10 excluding: schoolSubjectTags.
	myTopTags := self db topTags: 10 excluding: schoolSubjectTags by: self user.
	myMediaSets := nil.
	canUpload := nil.
]

{ #category : #accessing }
MEDFrontendSession >> schoolSubjectTags [
	^ schoolSubjectTags
]

{ #category : #accessing }
MEDFrontendSession >> topTags [
	^ topTags
]
