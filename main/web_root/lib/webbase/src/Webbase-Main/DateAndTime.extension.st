Extension { #name : #DateAndTime }

{ #category : #'*Webbase-Main' }
DateAndTime >> germanString [
	^WEBHelper germanDateAndTimeStringFor: self
]
