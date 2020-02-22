Extension { #name : #SequenceableCollection }

{ #category : #'*Webbase-Main' }
SequenceableCollection >> findFirst: aBlock startingAt: anIndex [
	| index |
	index := anIndex - 1.
	[(index := index + 1) <= self size] whileTrue:
		[(aBlock value: (self at: index)) ifTrue: [^index]].
	^ 0
]

{ #category : #'*Webbase-Main' }
SequenceableCollection >> firstAtMost: anInteger [
	^ self first: (self size min: anInteger)
]

{ #category : #'*Webbase-Main' }
SequenceableCollection >> firstOrNil [
	^self ifEmpty: [nil] ifNotEmpty: [:me | me first]
]

{ #category : #'*Webbase-Main' }
SequenceableCollection >> groupsOfMax: n atATimeDo: aBlock [ 
	"Variant of groupsOf: atATimeDo: but with the residual group. We are fiddling with index calculations. "
	| size |
	size := self size.
	n
		to: size + (n-1)
		by: n
		do: [:index |
			| args upperIndex | 
			upperIndex := index min: size.
			args := (self copyFrom: index - n + 1 to: upperIndex) asArray.
			aBlock value: args ].
]

{ #category : #'*Webbase-Main' }
SequenceableCollection >> identityIncludes: anObject [
	"Answer whether anObject is one of the receiver's elements."

	^ (self identityIndexOf: anObject) ~= 0
]

{ #category : #'*Webbase-Main' }
SequenceableCollection >> isUniqueValues [
	^self asSet size = self size
]

{ #category : #'*Webbase-Main' }
SequenceableCollection >> lastAtMost: anInteger [
	^ self last: (self size min: anInteger)
]

{ #category : #'*Webbase-Main' }
SequenceableCollection >> lastOrNil [
	^self ifEmpty: [nil] ifNotEmpty: [:me | me last]
]

{ #category : #'*Webbase-Main' }
SequenceableCollection >> replace: anObject by: anotherObject [
	| index |
	index := self indexOf: anObject.
	index > 0 ifTrue: [
		self at: index put: anotherObject
	]
]

{ #category : #'*Webbase-Main' }
SequenceableCollection >> select: aBlock atMost: anInteger [
	| each |
	^ self class new: self size streamContents: [ :stream|
		1 to: self size do: [ :index |
			stream size >= anInteger ifFalse: [
			(aBlock value: (each := self at: index))
				ifTrue: [ stream nextPut: each ]]]]
]
