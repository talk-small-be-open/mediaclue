Class {
	#name : #WEBModelObject,
	#superclass : #WEBObject,
	#instVars : [
		'uuid'
	],
	#category : #'Webbase-Main-Core'
}

{ #category : #accessing }
WEBModelObject class >> displayName [
	^'Model object'
]

{ #category : #accessing }
WEBModelObject >> asString [
	^self displayName
]

{ #category : #accessing }
WEBModelObject >> displayName [
	self subclassResponsibility
]

{ #category : #accessing }
WEBModelObject >> ensureUuid [
	^self uuid
]

{ #category : #copying }
WEBModelObject >> postCopy [
	super postCopy.
	uuid := nil
]

{ #category : #accessing }
WEBModelObject >> uuid [
	uuid ifNil: [uuid := UUID new asString36].

	^uuid
]

{ #category : #'as yet unclassified' }
WEBModelObject >> uuidString [
	^self uuid asString
]
