Class {
	#name : #WEBBackgroundJobComponentBase,
	#superclass : #WEBComponent,
	#instVars : [
		'job',
		'isAutoClose',
		'jobTitle'
	],
	#category : #'Webbase-Main-Offloading'
}

{ #category : #accessing }
WEBBackgroundJobComponentBase class >> job: aBackgroundJob [
	^self job: aBackgroundJob named: nil
]

{ #category : #'as yet unclassified' }
WEBBackgroundJobComponentBase class >> job: aBackgroundJob named: aString [
	^self basicNew
		setJob: aBackgroundJob;
		setJobTitle: aString;
		initialize;
		yourself
]

{ #category : #'as yet unclassified' }
WEBBackgroundJobComponentBase class >> jobTitle: aJobTitle named: aString block: aBlock [
	| job |
	
	job := self db butler redoJob: aJobTitle block: aBlock.
	
	^self basicNew
		setJob: job;
		setJobTitle: aString;
		initialize;
		yourself
]

{ #category : #'as yet unclassified' }
WEBBackgroundJobComponentBase >> abort [
	self db butler cancelJob: job
]

{ #category : #'as yet unclassified' }
WEBBackgroundJobComponentBase >> answerJob [
	self answer: job
]

{ #category : #'as yet unclassified' }
WEBBackgroundJobComponentBase >> beAutoClose [
	isAutoClose := true
]

{ #category : #'as yet unclassified' }
WEBBackgroundJobComponentBase >> checkIfFinished [
	self isGenerating ifFalse: [
		self isAutoClose ifTrue: [self close]]
]

{ #category : #actions }
WEBBackgroundJobComponentBase >> close [
	self answerJob
]

{ #category : #initialization }
WEBBackgroundJobComponentBase >> initialize [

	super initialize.

	
	isAutoClose := false.
]

{ #category : #testing }
WEBBackgroundJobComponentBase >> isAutoClose [
	^isAutoClose and: [ job isSuccess ]
]

{ #category : #'as yet unclassified' }
WEBBackgroundJobComponentBase >> isGenerating [
	^job isDone not
]

{ #category : #accessing }
WEBBackgroundJobComponentBase >> job [
	^job
]

{ #category : #accessing }
WEBBackgroundJobComponentBase >> jobTitle [
	^jobTitle ifBlank: [ job title ]
]

{ #category : #'as yet unclassified' }
WEBBackgroundJobComponentBase >> setJob: aJob [
	job := aJob
]

{ #category : #initialization }
WEBBackgroundJobComponentBase >> setJobTitle: aString [
	jobTitle := aString
]
