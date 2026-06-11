Class {
	#name : #MEDDatabase,
	#superclass : #WEBVoyageMongoDatabase,
	#category : #'Mediaclue-Database'
}

{ #category : #adding }
MEDDatabase >> addTag: aTag [
	aTag save
]

{ #category : #adding }
MEDDatabase >> addUser: aUser [
	aUser save
]

{ #category : #accessing }
MEDDatabase >> authorities [
	^ self userGroups sortedBySortKey, self users sortedBySortKey
]

{ #category : #'as yet unclassified' }
MEDDatabase >> countMediaSetsByOwner: aUser [
	^ MEDMediaSet count: [ :each | (each at: 'owner.__id' ) = aUser voyageId ]

]

{ #category : #'as yet unclassified' }
MEDDatabase >> countMediasByOwner: aUser [
	^ MEDMediaAsset count: [ :each | (each at: 'owner.__id' ) = aUser voyageId ]

]

{ #category : #'as yet unclassified' }
MEDDatabase >> countUserGroupsByUser: aUser [
	^ MEDUserGroup count: [ :each | (each at: 'users.__id' ) = aUser voyageId ]

]

{ #category : #'as yet unclassified' }
MEDDatabase >> createMongoIndexes [
	super createMongoIndexes.

	MEDUser createMongoIndexField: 'email'.
	MEDMediaAsset createMongoIndexField: 'owner.__id'.
	MEDMediaAsset createMongoIndexField: 'tagList.__id'.
	MEDMediaSet createMongoIndexField: 'owner.__id'.
	MEDMediaSet createMongoIndexField: 'tagList.__id'.

"Mongo-Text-Index macht irgendwie kein Sinn beim Suchen, weil keine Wildcards möglich
	MEDMediaAsset createMongoTextIndexFields: #(title description metaData).
	MEDMediaSet createMongoTextIndexFields: #(title description metaData)."
]

{ #category : #'as yet unclassified' }
MEDDatabase >> ensureAdminExists [
	(self db findUserByEmail: self globalConfiguration sysAdminEmailAddress) ifNil: [
		MEDUser new
			email: self globalConfiguration sysAdminEmailAddress;
			firstName: 'A.';
			lastName: 'Administrator';
			beAdmin;
			password: 'me123and', self globalConfiguration organizationShortName;
			save.
	]
]

{ #category : #'as yet unclassified' }
MEDDatabase >> findDisabledUsers [
	^ MEDUser selectMany: [ :each | each disabled = true ]
"	^ MEDMediaAsset selectMany: [ :each | (each at: 'owner.__id' ) = aUser voyageId ]"

]

{ #category : #'as yet unclassified' }
MEDDatabase >> findGalleries [
	^ MEDMediaSet selectMany: [ :each | each isGallery = true ]

]

{ #category : #'as yet unclassified' }
MEDDatabase >> findMediaByQuery: aSearchQuery [
	| result queryMedias queryMediaSets mongoQueryMedias mongoQueryMediaSets isSearchingMedias |

	isSearchingMedias := (aSearchQuery isGallery = true) not.

	result := MEDSearchResult new.
	result query: aSearchQuery copy.

	"MediaSet search"
	queryMediaSets := aSearchQuery copy.

	queryMediaSets beforeExecution.

	"IMPORTANT: Tweaks to make search sense on the splitted queries"
	queryMediaSets includeAllMedia.
	
	mongoQueryMediaSets := queryMediaSets asMongoQuery.
	
	self ifDevelopment: [
		self logInfo: mongoQueryMediaSets asJavascript.
	].

	result mediaSets: (MEDMediaSet selectMany: mongoQueryMediaSets limit: aSearchQuery limit).

	"Wenn wir eine Limite haben, dann müssen wir die tatsächliche Anzahl explizit berechnen lassen"
	aSearchQuery hasLimit ifTrue: [ 
		result mediaSetsCount: (MEDMediaSet count: mongoQueryMediaSets)
	] ifFalse: [ 
		result mediaSetsCount: result mediaSets size.
	].
	

	"Optional search media (most cases yes)"
	isSearchingMedias ifTrue: [	
		queryMedias := aSearchQuery copy.

		queryMedias beforeExecution.

		"IMPORTANT: Tweaks to make search sense on the splitted queries"
		queryMedias isGallery: nil.
		
		mongoQueryMedias := queryMedias asMongoQuery.
		
		self ifDevelopment: [
			self logInfo: mongoQueryMedias asJavascript.
		].

		result medias: (MEDMediaAsset selectMany: mongoQueryMedias limit: aSearchQuery limit).

		"Wenn wir eine Limite haben, dann müssen wir die tatsächliche Anzahl explizit berechnen lassen"
		aSearchQuery hasLimit ifTrue: [ 
			result mediasCount: (MEDMediaAsset count: mongoQueryMedias).
		] ifFalse: [ 
			result mediasCount: result medias size.
		].
		
	].
	
	
	^ result
]

{ #category : #'as yet unclassified' }
MEDDatabase >> findMediaForUser: aUser query: aSearchQuery [
	| searchResult query |
	query := aSearchQuery copy.
	
	query allowedUser: aUser.
	
	searchResult := (self findMediaByQuery: query).
"	select: [ :eachMediaOrSet |
		eachMediaOrSet canView: aUser ]."
	
"	aSearchQuery hasLimit ifTrue: [
		searchResult := medias firstAtMost: aSearchQuery limit ]."
		
	^ searchResult
]

{ #category : #'as yet unclassified' }
MEDDatabase >> findMediaSetsByOwner: aUser [
	^ MEDMediaSet selectMany: [ :each | (each at: 'owner.__id' ) = aUser voyageId ]

]

{ #category : #'as yet unclassified' }
MEDDatabase >> findMediaSetsIncludingMedia: aMediaAsset [
	^ MEDMediaSet selectMany: [ :each | (each at: 'medias.__id' ) = aMediaAsset voyageId ]

]

{ #category : #'as yet unclassified' }
MEDDatabase >> findMediasByOwner: aUser [
	^ MEDMediaAsset selectMany: [ :each | (each at: 'owner.__id' ) = aUser voyageId ]

]

{ #category : #'as yet unclassified' }
MEDDatabase >> findOrCreateTagByTitle: aString [
	^(self findTagByTitle: aString) ifNil: [
		| tag |
		
		(MEDTag validateTitle: aString) ifFalse: [ nil ] ifTrue: [
			tag := MEDTag new.
			tag title: aString capitalized trimBoth.
			self addTag: tag.
			tag]]
]

{ #category : #'as yet unclassified' }
MEDDatabase >> findPublicGalleries [
	^ MEDMediaSet selectMany: [ :each |
		each isGallery = true &
		(each permissionType = 'public') ]

]

{ #category : #'as yet unclassified' }
MEDDatabase >> findPublicMediaSetByUuid: aString [
	^ MEDMediaSet selectOne: [ :each | each permissionType = 'public' & (each uuid = aString) ]
]

{ #category : #'as yet unclassified' }
MEDDatabase >> findPublicMediaSets [
	^ MEDMediaSet selectMany: [ :each | each permissionType = 'public' ]

]

{ #category : #'as yet unclassified' }
MEDDatabase >> findTagByTitle: aString [
	| lowercase |
	lowercase := aString asLowercase trimBoth.
	^self tags detect: [ :each | each title asLowercase = lowercase ] ifNone: [ nil ]
]

{ #category : #testing }
MEDDatabase >> findTaggablesByTag: aTag [
	| query result |
	query := MEDSearchQuery new.
	query addTag: aTag.
	
	result := self findMediaByQuery: query.
	^ result allObjects
]

{ #category : #'as yet unclassified' }
MEDDatabase >> findUnusedTags [
	^ self db tags select: [ :each |
		| hasOne |
		hasOne :=	(
			(MEDMediaAsset selectOne: [ :e |
				((e at: 'tagList.__id') = each voyageId) ]) notNil
		) or: [
			(MEDMediaSet selectOne: [ :e |
				((e at: 'tagList.__id') = each voyageId) ]) notNil
		].
	
		hasOne not
	]
]

{ #category : #finders }
MEDDatabase >> findUserByEmail: aString [
	^ MEDUser selectOne: [ :each | each email = aString ]
]

{ #category : #finders }
MEDDatabase >> findUserByLdapUid: aString [
	| lowercase |
	aString ifBlank: [ ^ nil ].
	
	lowercase := aString asLowercase trimBoth.
	
	^ MEDUser selectOne: [ :each | each ldapUid = lowercase ]

"DOES NOT WORK, no full regexp allowed	^ MEDUser selectOne: [ :each | each ldapUid matchesRegex: ('/^', lowercase, '$/i') ]"
]

{ #category : #finders }
MEDDatabase >> findUserByUsername: aString [
	^ self findUserByEmail: aString
]

{ #category : #'as yet unclassified' }
MEDDatabase >> findUserGroupsByUser: aUser [
	^ MEDUserGroup selectMany: [ :each | (each at: 'users.__id' ) = aUser voyageId ]

]

{ #category : #testing }
MEDDatabase >> isTagInUse: aTag [
	| query result |
	query := MEDSearchQuery new.
	query addTag: aTag.
	
	result := self findMediaByQuery: query.
	^ result isEmpty not
]

{ #category : #accessing }
MEDDatabase >> mediaSets [
	^MEDMediaSet selectAll
]

{ #category : #'as yet unclassified' }
MEDDatabase >> schoolSubjectTags [
	^ MEDTag selectMany: [ :each | each isSchoolSubject = true ]
]

{ #category : #accessing }
MEDDatabase >> tags [
	^MEDTag selectAll
]

{ #category : #'as yet unclassified' }
MEDDatabase >> tagsWithUsage [
	| data |
	data := OrderedCollection new.
	
	self tags do: [ :tag |
		| usageCount |
		usageCount := MEDMediaAsset count: [ :each |
			((each at: 'tagList.__id') = tag voyageId) ].
		usageCount := usageCount + (MEDMediaSet count: [ :each |
			((each at: 'tagList.__id') = tag voyageId) ]).

		usageCount > 0 ifTrue: [
			data add: { tag. usageCount } ]
	].

	^data
]

{ #category : #'as yet unclassified' }
MEDDatabase >> tagsWithUsageBy: aUser [
	| data |
	data := OrderedCollection new.
	self tags do: [ :tag |
		| usageCount |
		usageCount := MEDMediaAsset count: [ :each |
			((each at: 'tagList.__id') = tag voyageId) & ((each at: 'owner.__id') = aUser voyageId) ].
		usageCount := usageCount + (MEDMediaSet count: [ :each |
			((each at: 'tagList.__id') = tag voyageId) & ((each at: 'owner.__id') = aUser voyageId) ]).

		usageCount > 0 ifTrue: [
			data add: { tag. usageCount } ]
	].

	^ data

]

{ #category : #'as yet unclassified' }
MEDDatabase >> topTags: aSize [
	^ self topTags: aSize excluding: #()
]

{ #category : #'as yet unclassified' }
MEDDatabase >> topTags: aSize by: aUser [
	^ self topTags: aSize excluding: #() by: aUser
]

{ #category : #'as yet unclassified' }
MEDDatabase >> topTags: aSize excluding: aCollection [
	^ (((self tagsWithUsage sortedReversedBy: [ :each | each second ])
	collect: #first)
	copyWithoutAll: aCollection)
	firstAtMost: aSize

]

{ #category : #'as yet unclassified' }
MEDDatabase >> topTags: aSize excluding: aCollection by: aUser [
	^ ((((self tagsWithUsageBy: aUser)
	sortedReversedBy: [ :each | each second ])
	collect: #first)
	copyWithoutAll: aCollection)
	firstAtMost: aSize
]

{ #category : #accessing }
MEDDatabase >> userGroups [
	^ MEDUserGroup selectAll
]

{ #category : #accessing }
MEDDatabase >> users [
	^MEDUser selectAll
]
