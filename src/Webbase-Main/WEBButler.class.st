Class {
	#name : #WEBButler,
	#superclass : #WEBObject,
	#instVars : [
		'offloader'
	],
	#category : #'Webbase-Main-Offloading'
}

{ #category : #'as yet unclassified' }
WEBButler >> cancelAllFutureJobs [
	^offloader removeAllJobs
]

{ #category : #'as yet unclassified' }
WEBButler >> cancelJob: aJob [
	^offloader cancelJob: aJob
]

{ #category : #accessing }
WEBButler >> cleanup [
	offloader cleanup
]

{ #category : #accessing }
WEBButler >> cleanupAggressive [
	offloader removeAllExecutedJobs
]

{ #category : #'as yet unclassified' }
WEBButler >> currentJobs [
	^offloader jobs
]

{ #category : #'as yet unclassified' }
WEBButler >> doBlock: aBlock [
	^self doJob: 'Butler doBlock' block: aBlock
]

{ #category : #'as yet unclassified' }
WEBButler >> doJob: aString block: aBlock [
	| job |
	job := WEBBackgroundBlockJob new.
	job
		title: aString;
		block: aBlock.
	^offloader addJob: job
]

{ #category : #'as yet unclassified' }
WEBButler >> executedJobSummaries [
	^offloader executedJobSummaries
]

{ #category : #initialization }
WEBButler >> initialize [
	super initialize.

]

{ #category : #initialization }
WEBButler >> initializeDefaultValues [
	super initializeDefaultValues.
	offloader ifNil: [
		offloader := WEBJobsOffloader new.
		offloader maxJobs: 50]
]

{ #category : #'as yet unclassified' }
WEBButler >> jobTitles [
	^offloader jobTitles
]

{ #category : #'as yet unclassified' }
WEBButler >> jobsCount [
	^offloader jobsCount
]

{ #category : #'as yet unclassified' }
WEBButler >> redoJob: aString block: aBlock [
	| job |
	job := WEBBackgroundBlockJob new.
	job
		title: aString;
		block: aBlock.
	^offloader readdJob: job
]

{ #category : #'as yet unclassified' }
WEBButler >> restartOffloaderIfTerminated [
	offloader autostart
]

{ #category : #'as yet unclassified' }
WEBButler >> terminateStalledOffloads [
	offloader terminateCurrentJobIfLongerThanSecs: 180
]

{ #category : #'as yet unclassified' }
WEBButler >> wakeup [
	"Periodisch zu überprüfendes machen und autonom handeln. Kommt z.B. im 5-Minutentakt"
	self terminateStalledOffloads.
	self restartOffloaderIfTerminated.
]
