Class {
	#name : #MEDMediaAssetValidator,
	#superclass : #MEDValidator,
	#category : #'Mediaclue-Validation'
}

{ #category : #'as yet unclassified' }
MEDMediaAssetValidator >> default [
	self validatePresence of: #title
]
