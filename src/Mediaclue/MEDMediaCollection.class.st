Class {
	#name : #MEDMediaCollection,
	#superclass : #MEDModelObject,
	#traits : 'TMEDProtected',
	#classTraits : 'TMEDProtected classTrait',
	#instVars : [
		'medias',
		'title'
	],
	#category : #'Mediaclue-Models'
}

{ #category : #testing }
MEDMediaCollection class >> isVoyageRoot [
	^false
]

{ #category : #accessing }
MEDMediaCollection class >> medias: aCollection [
	^self basicNew
		setMedias: aCollection asOrderedCollection;
		initialize;
		yourself
]

{ #category : #adding }
MEDMediaCollection >> add: aMediaAsset [
	medias add: aMediaAsset
]

{ #category : #adding }
MEDMediaCollection >> addAll: aCollection [
	medias addAll: aCollection
]

{ #category : #converting }
MEDMediaCollection >> asMediaCollection [
	^ self
]

{ #category : #accessing }
MEDMediaCollection >> audios [
	^ self select: [ :each | each isAudio ]
]

{ #category : #enumerating }
MEDMediaCollection >> collect: aBlock [
	^ self medias collect: aBlock
]

{ #category : #accessing }
MEDMediaCollection >> description [
	^nil
]

{ #category : #magritte }
MEDMediaCollection >> descriptionTitle [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #title;
		label: 'Titel';
		beRequired;
		yourself
]

{ #category : #'as yet unclassified' }
MEDMediaCollection >> displayName [
	^self title ifBlank: [ 'Unbenannt' ]
]

{ #category : #enumerating }
MEDMediaCollection >> do: aBlock [
	self medias do: aBlock
]

{ #category : #origins }
MEDMediaCollection >> documents [
	^ self select: [ :each | each isDocument ]
]

{ #category : #accessing }
MEDMediaCollection >> images [
	^self select: [ :each | each isImage ]
]

{ #category : #accessing }
MEDMediaCollection >> imagesCount [
	^ self images size
]

{ #category : #testing }
MEDMediaCollection >> includes: aMedia [
	^ self medias includes: aMedia
]

{ #category : #initialization }
MEDMediaCollection >> initialize [
	super initialize.
	medias ifNil: [
		medias := OrderedCollection new].
]

{ #category : #testing }
MEDMediaCollection >> isEmpty [
	^ self medias isEmpty
]

{ #category : #accessing }
MEDMediaCollection >> medias [
	^ medias copy
]

{ #category : #accessing }
MEDMediaCollection >> medias: anObject [
	medias := anObject copy
]

{ #category : #enumerating }
MEDMediaCollection >> mediasAsSet [
	^ MEDMediaList medias: self medias
]

{ #category : #accessing }
MEDMediaCollection >> mediasCount [
	^ self medias size
]

{ #category : #'as yet unclassified' }
MEDMediaCollection >> mediasForUserAsEditor: aUser [
	^ self select: [ :each | each canEdit: aUser ]
]

{ #category : #'as yet unclassified' }
MEDMediaCollection >> mediasForUserAsViewer: aUser [
	^ self select: [ :each | each canView: aUser ]
]

{ #category : #accessing }
MEDMediaCollection >> permissionType [
	^ #owner
]

{ #category : #copying }
MEDMediaCollection >> postCopy [
	super postCopy.
	medias := medias copy.
]

{ #category : #adding }
MEDMediaCollection >> remove: aMediaAsset [
	medias removeIfPresent: aMediaAsset
]

{ #category : #adding }
MEDMediaCollection >> removeAll [
	medias removeAll
]

{ #category : #adding }
MEDMediaCollection >> removeAll: aCollection [
	medias removeAll: aCollection
]

{ #category : #enumerating }
MEDMediaCollection >> select: aBlock [
	^ MEDMediaList medias: (self medias select: aBlock)
]

{ #category : #accessing }
MEDMediaCollection >> setMedias: anObject [
	medias := anObject
]

{ #category : #accessing }
MEDMediaCollection >> size [
	^ self mediasCount
]

{ #category : #sorting }
MEDMediaCollection >> sortMediasBy: aBlock [
	medias sortByKey: aBlock
]

{ #category : #accessing }
MEDMediaCollection >> title [
	^ title
]

{ #category : #accessing }
MEDMediaCollection >> title: anObject [
	title := anObject
]

{ #category : #accessing }
MEDMediaCollection >> videos [
	^ self select: [ :each | each isVideo ]
]

{ #category : #enumerating }
MEDMediaCollection >> withIndexDo: aBlock [
	self medias withIndexDo: aBlock
]
