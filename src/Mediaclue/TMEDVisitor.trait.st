Trait {
	#name : #TMEDVisitor,
	#category : #'Mediaclue-Traits'
}

{ #category : #visiting }
TMEDVisitor >> visitAudioAsset: anObject [
	^ self visitMediaAsset: anObject
]

{ #category : #visiting }
TMEDVisitor >> visitDocumentAsset: anObject [
	^ self visitMediaAsset: anObject
]

{ #category : #visiting }
TMEDVisitor >> visitImageAsset: anObject [
	^ self visitMediaAsset: anObject
]

{ #category : #visiting }
TMEDVisitor >> visitMediaAsset: anObject [
	self subclassResponsibility
]

{ #category : #visiting }
TMEDVisitor >> visitVideoAsset: anObject [
	^ self visitMediaAsset: anObject
]
