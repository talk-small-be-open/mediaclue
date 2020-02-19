Class {
	#name : #MEDMediaComponentBase,
	#superclass : #MEDModelComponentBase,
	#category : #'Mediaclue-View'
}

{ #category : #private }
MEDMediaComponentBase class >> classForMedia: aMedia [
	self subclassResponsibility
]

{ #category : #'instance creation' }
MEDMediaComponentBase class >> for: aMedia [
	^(self classForMedia: aMedia) basicNew
		setModel: aMedia;
		initialize;
		yourself
]
