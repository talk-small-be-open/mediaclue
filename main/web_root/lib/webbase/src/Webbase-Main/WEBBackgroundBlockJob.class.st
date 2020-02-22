Class {
	#name : #WEBBackgroundBlockJob,
	#superclass : #WEBBackgroundJob,
	#instVars : [
		'block'
	],
	#category : #'Webbase-Main-Offloading'
}

{ #category : #'as yet unclassified' }
WEBBackgroundBlockJob >> basicExecute [
	^block value
]

{ #category : #accessing }
WEBBackgroundBlockJob >> block [
	^ block
]

{ #category : #accessing }
WEBBackgroundBlockJob >> block: anObject [
	block := anObject
]

{ #category : #'as yet unclassified' }
WEBBackgroundBlockJob >> killPayload [
	super killPayload.
	
	block := nil
]
