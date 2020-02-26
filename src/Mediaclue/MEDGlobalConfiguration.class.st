Class {
	#name : #MEDGlobalConfiguration,
	#superclass : #MEDConfiguration,
	#traits : 'TWEBGlobalConfiguration',
	#classTraits : 'TWEBGlobalConfiguration classTrait',
	#category : #'Mediaclue-Models'
}

{ #category : #testing }
MEDGlobalConfiguration class >> isVoyageRoot [
	^true
]

{ #category : #actions }
MEDGlobalConfiguration >> apply [
	"persist in Mongo"
	self save.
	
	"OPTIMIZE: Maybe do that with announcements? At the moment overkill"
	self db ensureIdentityProvider.
	
	"TODO: Others: Pharo port, ..."
]

{ #category : #'as yet unclassified' }
MEDGlobalConfiguration >> assetsBasePath [
	^self at: #assetsBasePath
]

{ #category : #configs }
MEDGlobalConfiguration >> assetsBasePath: aValue [
	self at: #assetsBasePath put: aValue
]

{ #category : #'as yet unclassified' }
MEDGlobalConfiguration >> assetsUrlBasePath [
	^self at: #assetsUrlBasePath
]

{ #category : #configs }
MEDGlobalConfiguration >> assetsUrlBasePath: aValue [
	self at: #assetsUrlBasePath put: aValue
]

{ #category : #configs }
MEDGlobalConfiguration >> demoMessage [
	^ self at: #demoMessage
]

{ #category : #configs }
MEDGlobalConfiguration >> demoMessage: aValue [
	self at: #demoMessage put: aValue
]

{ #category : #'as yet unclassified' }
MEDGlobalConfiguration >> maxFileSizeBytes [
	^self at: #maxFileSizeBytes ifNil: [ 100 * (1024*1024) ] "default 100MB"
]

{ #category : #configs }
MEDGlobalConfiguration >> maxFileSizeBytes: aValue [
	self at: #maxFileSizeBytes put: aValue
]

{ #category : #'as yet unclassified' }
MEDGlobalConfiguration >> maxUploadSeriesFilesCount [
	^self at: #maxUploadSeriesFilesCount ifNil: [ 200 ] "default 100MB"
]

{ #category : #configs }
MEDGlobalConfiguration >> maxUploadSeriesFilesCount: aValue [
	self at: #maxUploadSeriesFilesCount put: aValue
]

{ #category : #'as yet unclassified' }
MEDGlobalConfiguration >> organizationName [
	^self at: #organizationName
]

{ #category : #configs }
MEDGlobalConfiguration >> organizationName: aValue [
	self at: #organizationName put: aValue
]

{ #category : #'as yet unclassified' }
MEDGlobalConfiguration >> organizationShortName [
	^self at: #organizationShortName ifNil: [ self organizationName ]
]

{ #category : #configs }
MEDGlobalConfiguration >> organizationShortName: aValue [
	self at: #organizationShortName put: aValue
]

{ #category : #'as yet unclassified' }
MEDGlobalConfiguration >> previewsBasePath [
	^self at: #previewsBasePath
]

{ #category : #configs }
MEDGlobalConfiguration >> previewsBasePath: aValue [
	self at: #previewsBasePath put: aValue
]

{ #category : #'as yet unclassified' }
MEDGlobalConfiguration >> previewsUrlBasePath [
	^self at: #previewsUrlBasePath
]

{ #category : #configs }
MEDGlobalConfiguration >> previewsUrlBasePath: aValue [
	self at: #previewsUrlBasePath put: aValue
]

{ #category : #'as yet unclassified' }
MEDGlobalConfiguration >> unwantedExifTags [
	^self at: #unwantedExifTags
]

{ #category : #'as yet unclassified' }
MEDGlobalConfiguration >> unwantedExifTags: aCollectionOfStrings [
	self at: #unwantedExifTags put: aCollectionOfStrings
]
