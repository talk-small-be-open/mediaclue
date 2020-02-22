Class {
	#name : #WEBJobsOffloader,
	#superclass : #WEBObject,
	#instVars : [
		'offloadProcess',
		'jobs',
		'currentJob',
		'executedJobs',
		'mutex',
		'maxJobs'
	],
	#category : #'Webbase-Main-Offloading'
}

{ #category : #fuel }
WEBJobsOffloader class >> fuelIgnoredInstanceVariableNames [
	"Indicates which variables have to be ignored during serialization."

	^#(offloadProcess jobs currentJob executedJobs)
]

{ #category : #adding }
WEBJobsOffloader >> addJob: aJob [

	maxJobs ifNotNil: [
		(self jobsCount >= maxJobs) ifTrue: [
			WEBError signal: 'Jobs offloader overload!']].
	
	jobs nextPut: aJob.

	"Autostart"
	self autostart.
	
	^aJob

]

{ #category : #'as yet unclassified' }
WEBJobsOffloader >> autostart [
	mutex critical: [self isBusy ifFalse: [
			self hasWaitingJobs ifTrue: [
				self startProcessing]
		]
	]
]

{ #category : #'as yet unclassified' }
WEBJobsOffloader >> cancelAllJobs [
	self removeAllJobs.
	self terminateCurrentJob.
]

{ #category : #'as yet unclassified' }
WEBJobsOffloader >> cancelJob: aJob [
	self removeJob: aJob.
	currentJob = aJob ifTrue: [self terminateCurrentJob]
]

{ #category : #accessing }
WEBJobsOffloader >> cleanup [
	| deadline |
	deadline := DateAndTime now - 1 hours.
	executedJobs removeAllSuchThat: [:each | each stopTimestamp < deadline].
	executedJobs do: #shrink
]

{ #category : #'as yet unclassified' }
WEBJobsOffloader >> executedJobSummaries [
	^self executedJobs collect: #summaryLabel
]

{ #category : #'as yet unclassified' }
WEBJobsOffloader >> executedJobs [
	^executedJobs
]

{ #category : #fuel }
WEBJobsOffloader >> fuelAfterMaterialization [
	super fuelAfterMaterialization.

	jobs := WEBSharedQueue new.
	executedJobs := OrderedCollection new.
]

{ #category : #testing }
WEBJobsOffloader >> hasWaitingJobs [
	^jobs isEmpty not
]

{ #category : #initialization }
WEBJobsOffloader >> initialize [
	super initialize.

	jobs := WEBSharedQueue new.
	executedJobs := OrderedCollection new.
	mutex := WAMutex new.

]

{ #category : #testing }
WEBJobsOffloader >> isBusy [
	^offloadProcess notNil and: [offloadProcess isTerminated not]
]

{ #category : #'as yet unclassified' }
WEBJobsOffloader >> jobTitles [
	^self jobs collect: #title
]

{ #category : #'as yet unclassified' }
WEBJobsOffloader >> jobs [
	| allJobs |
	allJobs := OrderedCollection new.
	
	self isBusy ifTrue: [allJobs add: currentJob].
	
	allJobs addAll: jobs items.
	^allJobs copyWithoutNils
]

{ #category : #'as yet unclassified' }
WEBJobsOffloader >> jobsCount [
	^self jobs size
]

{ #category : #accessing }
WEBJobsOffloader >> lastJobNamed: aString [
	^(self executedJobs, self jobs) reversed detect: [ :each | each title = aString] ifNone: [ nil ]
]

{ #category : #accessing }
WEBJobsOffloader >> maxJobs [
	^ maxJobs
]

{ #category : #accessing }
WEBJobsOffloader >> maxJobs: anObject [
	maxJobs := anObject
]

{ #category : #'as yet unclassified' }
WEBJobsOffloader >> offloadBlock: aBlock [
	| job |
	job := WEBBackgroundBlockJob new.
	job block: aBlock.
	^self addJob: job
]

{ #category : #'as yet unclassified' }
WEBJobsOffloader >> offloadNextUntilEmpty [
	
	offloadProcess := [
	
	[currentJob := jobs nextOrNil] whileNotNil: [
		currentJob execute.
		currentJob shrink. "Speicherverbrauch minimieren"
		executedJobs add: currentJob.
"		self refresh."
	]
	
	] forkAt: Processor systemBackgroundPriority named: 'Web-App Jobs Offloader'.
]

{ #category : #'as yet unclassified' }
WEBJobsOffloader >> readdJob: aJob [
	"Fügt einen Job ein, welcher allenfalls schon drin ist. Der bestehende Job wird gelöscht.
	Anhand gleichen Job-Titels"
	self removeJobsNamed: aJob title.
	^self addJob: aJob.

]

{ #category : #accessing }
WEBJobsOffloader >> removeAllExecutedJobs [
	executedJobs do: #shrink.
	executedJobs removeAll.
]

{ #category : #'as yet unclassified' }
WEBJobsOffloader >> removeAllJobs [
	jobs removeAll
]

{ #category : #'as yet unclassified' }
WEBJobsOffloader >> removeJob: aJob [
	jobs remove: aJob
]

{ #category : #'as yet unclassified' }
WEBJobsOffloader >> removeJobsNamed: aString [
	jobs flushAllSuchThat: [:each | each title = aString]
]

{ #category : #'as yet unclassified' }
WEBJobsOffloader >> startProcessing [
	self offloadNextUntilEmpty
]

{ #category : #'as yet unclassified' }
WEBJobsOffloader >> terminateCurrentJob [
	self isBusy ifTrue: [
		| job |
		job := currentJob.

		offloadProcess terminate.
		offloadProcess := nil.

		job shrink. "Speicherverbrauch minimieren"
		executedJobs add: job.
		job beTerminated.

		]
]

{ #category : #'as yet unclassified' }
WEBJobsOffloader >> terminateCurrentJobIfLongerThanSecs: anInteger [
	| job |
	self isBusy ifFalse: [ ^self ].
	job := currentJob.

	(job duration > anInteger seconds) ifTrue: [
		self cancelJob: job.
		job beTerminatedCause: 'To long running'
	]
]

{ #category : #'as yet unclassified' }
WEBJobsOffloader >> waitingJobs [
	^jobs items
]
