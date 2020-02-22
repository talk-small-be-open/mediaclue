Class {
	#name : #WEBBackgroundJob,
	#superclass : #WEBObject,
	#instVars : [
		'title',
		'description',
		'executionResult',
		'startDelayMs',
		'isDone',
		'isError',
		'errorDescription',
		'startTimestamp',
		'stopTimestamp'
	],
	#category : #'Webbase-Main-Offloading'
}

{ #category : #execution }
WEBBackgroundJob >> basicExecute [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WEBBackgroundJob >> beTerminated [
	self beTerminatedCause: ''
]

{ #category : #'as yet unclassified' }
WEBBackgroundJob >> beTerminatedCause: aString [
	isError := true.
	errorDescription := 'TERMINATED: ', aString
]

{ #category : #accessing }
WEBBackgroundJob >> description [
	^ description
]

{ #category : #accessing }
WEBBackgroundJob >> description: anObject [
	description := anObject
]

{ #category : #'as yet unclassified' }
WEBBackgroundJob >> displayName [
	^self summaryLabel
]

{ #category : #accessing }
WEBBackgroundJob >> duration [
	startTimestamp ifNil: [ ^Duration zero ].
	
	stopTimestamp ifNil: [ ^(DateAndTime now - startTimestamp) asDuration ].
	
	^(stopTimestamp - startTimestamp) asDuration
]

{ #category : #accessing }
WEBBackgroundJob >> errorDescription [
	^ errorDescription
]

{ #category : #execution }
WEBBackgroundJob >> execute [
	"TODO: Zeit stoppen, Zeitstempel setzen, loggen"

	startDelayMs ifNotNil: [:ms | (Delay forMilliseconds: ms) wait].

	startTimestamp := DateAndTime now.

	[	
		[executionResult := self basicExecute] on: Error do: [:err |
			isError := true.
			errorDescription := err description.
			self ifDevelopment: [err pass].
		]
	] ensure: [
		stopTimestamp := DateAndTime now.
		isDone := true
	]
]

{ #category : #accessing }
WEBBackgroundJob >> executionResult [
	^ executionResult
]

{ #category : #testing }
WEBBackgroundJob >> ifSuccess: aBlock [
	^self isSuccess ifTrue: aBlock
]

{ #category : #initialization }
WEBBackgroundJob >> initialize [
	super initialize.
	isDone := false.
	isError := false.
]

{ #category : #testing }
WEBBackgroundJob >> isDone [
	^isDone
]

{ #category : #testing }
WEBBackgroundJob >> isError [
	^isError
]

{ #category : #testing }
WEBBackgroundJob >> isSuccess [
	^self isError not
]

{ #category : #'as yet unclassified' }
WEBBackgroundJob >> killPayload [
"Nicht, weil wir asynchron auf das Resultat zugreiffen, evt.	executionResult := nil"
]

{ #category : #'as yet unclassified' }
WEBBackgroundJob >> shrink [
	"Reduziert den Speicherverbrauch, nach dem der Job durch ist.
	Für Logzwecke behalten wir den Job, nicht aber die Ladung"
	
	self isDone ifTrue: [
		self killPayload
	]
]

{ #category : #accessing }
WEBBackgroundJob >> startDelayMs [
	^ startDelayMs
]

{ #category : #accessing }
WEBBackgroundJob >> startDelayMs: anObject [
	startDelayMs := anObject
]

{ #category : #accessing }
WEBBackgroundJob >> startTimestamp [
	^ startTimestamp
]

{ #category : #labels }
WEBBackgroundJob >> statusLabel [
	self isDone ifTrue: [
		self isSuccess ifTrue: [^'OK'].
		self isError ifTrue: [^self errorDescription]].
		
	^''
]

{ #category : #accessing }
WEBBackgroundJob >> stopTimestamp [
	^ stopTimestamp
]

{ #category : #labels }
WEBBackgroundJob >> summaryLabel [
	^self timeLabel, ' ', self title, ' (', self statusLabel, ')'
]

{ #category : #labels }
WEBBackgroundJob >> timeLabel [
	^(WEBHelper germanDateAndTimeStringFor: self startTimestamp), ' (', self duration asMilliSeconds greaseString, 'ms)'
]

{ #category : #accessing }
WEBBackgroundJob >> title [
	^ title
]

{ #category : #accessing }
WEBBackgroundJob >> title: anObject [
	title := anObject
]
