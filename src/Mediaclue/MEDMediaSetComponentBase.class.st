Class {
	#name : #MEDMediaSetComponentBase,
	#superclass : #MEDModelComponentBase,
	#category : #'Mediaclue-View'
}

{ #category : #'as yet unclassified' }
MEDMediaSetComponentBase class >> mediaSet: aMediaSet [
	^ self basicNew
		setModel: aMediaSet;
		initialize;
		yourself	
]
