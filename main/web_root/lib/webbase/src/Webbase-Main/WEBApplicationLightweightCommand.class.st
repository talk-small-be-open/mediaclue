"
I am the base class for all lightweight commands. My subclasses can not be stored and need to be instantiated and initialized solely through the URL
"
Class {
	#name : #WEBApplicationLightweightCommand,
	#superclass : #WEBApplicationCommand,
	#category : #'Webbase-Main-Core'
}

{ #category : #initialization }
WEBApplicationLightweightCommand >> initialize [
	super initialize.
	self beLoginNotRequired.
	self beUnlimitedExecutable
]

{ #category : #'as yet unclassified' }
WEBApplicationLightweightCommand >> store [
	self shouldNotImplement
]

{ #category : #'as yet unclassified' }
WEBApplicationLightweightCommand >> url [
	self subclassResponsibility
]
