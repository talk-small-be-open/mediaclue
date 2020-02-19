Class {
	#name : #MEDMediaSetValidator,
	#superclass : #MEDValidator,
	#category : #'Mediaclue-Validation'
}

{ #category : #'instance creation' }
MEDMediaSetValidator class >> forPublication [
	^self new
		forPublication;
		yourself
]

{ #category : #rulesets }
MEDMediaSetValidator >> default [
	self forPublication
]

{ #category : #rulesets }
MEDMediaSetValidator >> forPublication [
	self validatePresence of: #title; named: 'Titel'.

"	self validationGroup: [
		self validatePresence of: #hosts; named: #host.
		self validateLabelsAllowed].
	self validateDescriptionField"
]

{ #category : #rulesets }
MEDMediaSetValidator >> validateLabelsAllowed [
	(self validateTrue: [self object areLabelsAllowed])
		errorMessage: #validation:error:labelsNotAllowed
]

{ #category : #rulesets }
MEDMediaSetValidator >> validateLabelsArePresent [
	self validatePresence of: #labelClassification; named: #labels
]

{ #category : #rulesets }
MEDMediaSetValidator >> validateLabelsGranted [
	(self validateTrue: [ self object labelClassification isGranted ]) errorMessage: #validation:error:labelsNotGranted
]

{ #category : #rulesets }
MEDMediaSetValidator >> validateTimeframe [
	| today |
	today := Date today.
	
	self validationGroup: [  
		self validateRange
			of: #earliestStartDate;
			named: #opp:earliestStartDate;
			beNilAllowed;
"			minimum: today;"
			maximum: today + (730 days).

		self validateRange
			of: #latestEndDate;
			named: #opp:latestEndDate;
			beNilAllowed;
			minimum: [self object earliestStartDate]]
]

{ #category : #rulesets }
MEDMediaSetValidator >> validateTopicsArePresent [
	self validatePresence of: #topicClassification; named: #topics
]
