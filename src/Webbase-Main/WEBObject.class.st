"
This is the main base object of a WEB-project
"
Class {
	#name : #WEBObject,
	#superclass : #Object,
	#traits : 'TWEBGlobalHelpers',
	#classTraits : 'TWEBGlobalHelpers classTrait',
	#category : #'Webbase-Main-Core'
}

{ #category : #accessing }
WEBObject class >> displayName [
	^ self name asString
]

{ #category : #accessing }
WEBObject >> classDisplayName [
	^self class displayName
]

{ #category : #accessing }
WEBObject >> displayName [
	^self asString
]

{ #category : #initialization }
WEBObject >> initialize [

	super initialize.
	self initializeDefaultValues.

]

{ #category : #initialization }
WEBObject >> initializeDefaultValues [
]

{ #category : #accessing }
WEBObject >> sortKey [
	^self displayName asLowercase
]
