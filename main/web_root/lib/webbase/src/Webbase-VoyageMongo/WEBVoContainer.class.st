Class {
	#name : #WEBVoContainer,
	#superclass : #VOContainer,
	#category : #'Webbase-VoyageMongo'
}

{ #category : #accessing }
WEBVoContainer class >> defaultAllowMissingContent [
	"TODO: Evt. nur bei Development?"
	Transcript show: 'Voyage MISSING CONTENT requested!'; cr.

	WEBDatabase current isDevelopment ifTrue: [
		"Weil wir einen Garbage Collector haben"
		^true
	].

	^true
]
