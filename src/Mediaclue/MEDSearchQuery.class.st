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
		'includeDocument',
		'allowedUser',
		'isGallery',
		'permissionType'
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

{ #category : #accessing }
MEDSearchQuery >> allowedUser [
	^ allowedUser
]

{ #category : #accessing }
MEDSearchQuery >> allowedUser: anObject [
	allowedUser := anObject
]

{ #category : #converting }
MEDSearchQuery >> asMongoQuery [
	| mongoQuery andConditions |

	mongoQuery := Dictionary new.

	andConditions := OrderedCollection new.
	
"	self hasLimit ifTrue: [ mongoQuery at: '$limit' put: self limit ]."

	"Volltext"
	self text ifNotBlank: [
		self isRegexpSearch
			ifTrue: [
				| regexps |
				regexps := self regexpsFromSearchString.
				regexps do: [ :eachRegexp |
					| orConditions |
					orConditions := OrderedCollection new.
					#('title' 'description' 'tagTitleList') do: [ :eachField |
						orConditions add: { eachField->{
							'$regex'->eachRegexp.
							'$options'->'i'.
						} asD } asD ].
					andConditions add: {'$or'->orConditions} asD.
				].
			]
			ifFalse: [
				"Wir nehmen den sprachbasierten Volltext-Index von Mongo.
				Sucht aber nur ganze Wörter"
				"Zur Zeit inaktiv weil keine wildcards möglich, deshalb sinnlos"
"				mongoQuery at: '$text' put:
					{'$search'->t} asD."
			].
	].

	"Tags"
	self tags ifNotBlank: [ :collection |
		| titles |
		titles := collection collect: #title.
		mongoQuery at: 'tagTitleList' put: {
			'$all'->titles.
		} asD.
	].


	"Permissions and user-specific checks"
	self allowedUser ifNotNil: [ :user |
		| permissionConditions userGroupIds userGroupAndMeIds |

		"my own stuff only"
		self myMediaOnly ifTrue: [ 
			andConditions add: { 'owner.__id' -> user voyageId } asD
		].
		
		"Permissions"
		"Dont check if Admin"
		user isAdmin
			ifTrue: [ 
				permissionType ifNotNil: [ 
					permissionConditions := { 'permissionType' -> permissionType } asD.
					andConditions add: permissionConditions.
				]
			]
			ifFalse: [
				userGroupIds := user userGroups collect: [ :each | each voyageId ].
				userGroupAndMeIds := userGroupIds copyWith: user voyageId.
				
				permissionConditions := { '$or' -> { 
						{ 'permissionType' -> 'dontcheck' } asD.
						{ 'permissionType' -> 'public' } asD.
						{ 'owner.__id' -> user voyageId } asD.
						{ '$and' -> {
							{ 'permissionType' -> 'all' } asD.
							{ 'owner.#instanceOf' -> 'MEDUser' } asD } } asD.
						{ '$and' -> {
							{ 'permissionType' -> 'groups' } asD.
							{ '$or' -> {
								{ 'readPermittedAuthorities.__id' -> { '$in' -> userGroupAndMeIds } asD } asD.
	"							{ 'writePermittedAuthorities.__id' -> { '$in' -> userGroupAndMeIds } asD } asD."
								} } asD } } asD.						
						{ 'writePermittedAuthorities.__id' -> { '$in' -> userGroupAndMeIds } asD } asD.
					} } asD.
				andConditions add: permissionConditions.
			]
	].	

	"Medientyp für Medien-Query"
	self isMediaTypeFiltered ifTrue: [
		mongoQuery at: '#instanceOf' put: {
			'$in'->(self mediaTypes collect: [:each | each name ]).
		} asD.
	].

	isGallery ifNotNil: [ 
		andConditions add: { 'isGallery' -> isGallery } asD
	].
	
	andConditions ifNotEmpty: [ 
		mongoQuery at: '$and' put: andConditions ].

	
	^ mongoQuery
]

{ #category : #'as yet unclassified' }
MEDSearchQuery >> beforeExecution [
	self sanitizeQuery
]

{ #category : #initialization }
MEDSearchQuery >> clearFilter [
	text := nil.
	tags := OrderedCollection new.
	myMediaOnly := false.
	includeAudio := true.
	includeVideo := true.
	includeImage := true.
	includeDocument := true.
	isGallery := nil.
	permissionType := nil.
"DONT	allowedUser := nil."
]

{ #category : #initialization }
MEDSearchQuery >> clearSearch [
	self clearFilter.
	limit := nil.

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

{ #category : #accessing }
MEDSearchQuery >> isGallery [
	^ isGallery
]

{ #category : #accessing }
MEDSearchQuery >> isGallery: anObject [
	isGallery := anObject
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

{ #category : #testing }
MEDSearchQuery >> isSearchTextFiltered [
	^ text notBlank
]

{ #category : #testing }
MEDSearchQuery >> isTagsFiltered [
	^ tags notBlank
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
	limit := anObject ifNotNil: #asInteger
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
	^ myMediaOnly = true
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

{ #category : #accessing }
MEDSearchQuery >> permissionType [
	^ permissionType
]

{ #category : #accessing }
MEDSearchQuery >> permissionType: anObject [
	permissionType := anObject
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
		ifTrue: [ self includeAllMedia ].
		
	allowedUser ifNil: [ myMediaOnly := false ]
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
