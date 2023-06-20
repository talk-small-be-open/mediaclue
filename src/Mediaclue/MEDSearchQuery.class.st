Class {
	#name : #MEDSearchQuery,
	#superclass : #MEDModelObject,
	#instVars : [
		'title',
		'text',
		'tags',
		'myMediaOnly',
		'notificationsEnabled',
		'lastNotificationDatetime',
		'limit',
		'includeImage',
		'includeAudio',
		'includeVideo',
		'includeDocument'
	],
	#category : #'Mediaclue-Models'
}

{ #category : #testing }
MEDSearchQuery class >> isVoyageRoot [
	^false
]

{ #category : #adding }
MEDSearchQuery >> addTag: aTag [
	tags addIfNotPresent: aTag
]

{ #category : #'as yet unclassified' }
MEDSearchQuery >> beforeExecution [
	self sanitizeQuery
]

{ #category : #initialization }
MEDSearchQuery >> clearSearch [
	text := nil.
	tags := OrderedCollection new.
	myMediaOnly := false.
	limit := 20.
	includeAudio := true.
	includeVideo := true.
	includeImage := true.
	includeDocument := true.
]

{ #category : #accessing }
MEDSearchQuery >> displayName [
	^self title ifBlank: [ 'Unbenannte Abfrage' ]
]

{ #category : #testing }
MEDSearchQuery >> hasLimit [
	^ limit notNil and: [ limit > 0 ]
]

{ #category : #'as yet unclassified' }
MEDSearchQuery >> includeAllMedia [
	includeAudio := true.
	includeVideo := true.
	includeDocument := true.
	includeImage := true
]

{ #category : #accessing }
MEDSearchQuery >> includeAudio [
	^ includeAudio
]

{ #category : #accessing }
MEDSearchQuery >> includeAudio: anObject [
	includeAudio := anObject
]

{ #category : #accessing }
MEDSearchQuery >> includeDocument [
	^ includeDocument
]

{ #category : #accessing }
MEDSearchQuery >> includeDocument: anObject [
	includeDocument := anObject
]

{ #category : #accessing }
MEDSearchQuery >> includeImage [
	^ includeImage
]

{ #category : #accessing }
MEDSearchQuery >> includeImage: anObject [
	includeImage := anObject
]

{ #category : #accessing }
MEDSearchQuery >> includeVideo [
	^ includeVideo
]

{ #category : #accessing }
MEDSearchQuery >> includeVideo: anObject [
	includeVideo := anObject
]

{ #category : #initialization }
MEDSearchQuery >> initialize [
	super initialize.
	title := nil.
	notificationsEnabled := false.

	self clearSearch
]

{ #category : #testing }
MEDSearchQuery >> isMediaTypeFiltered [
	"Wenn eine der Flags false ist, dann wird gefiltert. Alle false gibts nicht, siehe sanitize..."
	^{includeAudio. includeVideo. includeDocument. includeImage} anySatisfy: [ :each | each = false ]
]

{ #category : #testing }
MEDSearchQuery >> isRegexpSearch [
	"Im Moment gibt es nur die Suche nach Regexps. Evt. Mongo-Text-Index mal in Zukunft
	aber der ist nicht wildcardfähig leider"
	^ true
]

{ #category : #accessing }
MEDSearchQuery >> lastNotificationDatetime [
	^ lastNotificationDatetime
]

{ #category : #accessing }
MEDSearchQuery >> lastNotificationDatetime: anObject [
	lastNotificationDatetime := anObject
]

{ #category : #accessing }
MEDSearchQuery >> limit [
	^ limit
]

{ #category : #accessing }
MEDSearchQuery >> limit: anObject [
	limit := anObject
]

{ #category : #'as yet unclassified' }
MEDSearchQuery >> mediaTypes [
	^ OrderedCollection new
		add: MEDAudioAsset if: includeAudio;
		add: MEDVideoAsset if: includeVideo;
		add: MEDDocumentAsset if: includeDocument;
		add: MEDImageAsset if: includeImage;
		yourself.
]

{ #category : #accessing }
MEDSearchQuery >> myMediaOnly [
	^ myMediaOnly
]

{ #category : #accessing }
MEDSearchQuery >> myMediaOnly: anObject [
	myMediaOnly := anObject
]

{ #category : #accessing }
MEDSearchQuery >> notificationsEnabled [
	^ notificationsEnabled
]

{ #category : #accessing }
MEDSearchQuery >> notificationsEnabled: anObject [
	notificationsEnabled := anObject
]

{ #category : #copying }
MEDSearchQuery >> postCopy [
	super postCopy.
	tags := tags copy.
]

{ #category : #testing }
MEDSearchQuery >> regexpsFromSearchString [
	^((text trimBoth copyReplaceAll: '*' with: '.*') findTokens: Character space)
		collect: [ :each | '.*', each, '.*' ]
]

{ #category : #adding }
MEDSearchQuery >> removeTag: aTag [
	tags remove: aTag
]

{ #category : #'as yet unclassified' }
MEDSearchQuery >> sanitizeQuery [
	({includeAudio. includeVideo. includeDocument. includeImage} allSatisfy: [ :each | each = false ])
		ifTrue: [ self includeAllMedia ]
]

{ #category : #accessing }
MEDSearchQuery >> tags [
	^ tags
]

{ #category : #accessing }
MEDSearchQuery >> tags: anObject [
	tags := anObject
]

{ #category : #'as yet unclassified' }
MEDSearchQuery >> text [
	^ text
]

{ #category : #accessing }
MEDSearchQuery >> text: anObject [
	text := anObject
]

{ #category : #accessing }
MEDSearchQuery >> title [
	^ title
]

{ #category : #accessing }
MEDSearchQuery >> title: anObject [
	title := anObject
]

{ #category : #'as yet unclassified' }
MEDSearchQuery >> toggleNotifications [
	notificationsEnabled := notificationsEnabled not
]
