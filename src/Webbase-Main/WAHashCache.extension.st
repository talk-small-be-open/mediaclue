Extension { #name : #WAHashCache }

{ #category : #'*Webbase-Main' }
WAHashCache >> timeToLive: aSessionKey [
	| keyHash index entry  |
	
	keyHash := aSessionKey hash.
	index := (keyHash \\ keyTable size) + 1.
	entry := self findEntryOrNilWithKey: aSessionKey hash: keyHash index: index.

	^ entry isNil
		ifTrue: [ 0 ]
		ifFalse: [
			maximumRelativeAge - (Time totalSeconds - entry byAccessListEntry time) ]
]
