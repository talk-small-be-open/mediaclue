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
MEDDatabase >> findMediaByQuery: aSearchQuery [
	| result mongoQuery mongoQueryMedias mongoQueryMediaSets |

	aSearchQuery beforeExecution.

	result := MEDSearchResult new.
	result query: aSearchQuery copy.
	
	mongoQuery := Dictionary new.

	"Volltext"
	aSearchQuery text ifNotBlank: [ :t |
		aSearchQuery isRegexpSearch
			ifTrue: [
				| andConditions regexps |
				regexps := aSearchQuery regexpsFromSearchString.
				andConditions := OrderedCollection new.
				regexps do: [ :eachRegexp |
					| orConditions |
					orConditions := OrderedCollection new.
					#('title' 'description' 'tagTitleList') do: [ :eachField |
						orConditions add: {eachField->{
							'$regex'->eachRegexp.
							'$options'->'i'.
						} asD } asD ].
					andConditions add: {'$or'->orConditions} asD.
				].

				mongoQuery at: '$and' put: andConditions.

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
	aSearchQuery tags ifNotBlank: [ :tags |
		| titles |
		titles := tags collect: #title.
		mongoQuery at: 'tagTitleList' put: {
			'$all'->titles.
		} asD.
	].

	self ifDevelopment: [
		self logInfo: mongoQuery asJavascript.
	].

	mongoQueryMedias := mongoQuery copy.
	
	"Medientyp für Medien-Query"
	aSearchQuery isMediaTypeFiltered ifTrue: [
		mongoQueryMedias at: '#instanceOf' put: {
			'$in'->(aSearchQuery mediaTypes collect: [:each | each name ]).
		} asD.
	].
	
	mongoQueryMediaSets := mongoQuery copy.

	result medias: (MEDMediaAsset selectMany: mongoQueryMedias).
	result mediaSets: (MEDMediaSet selectMany: mongoQueryMediaSets).
	
	^ result
]

{ #category : #'as yet unclassified' }
MEDDatabase >> findMediaForUser: aUser query: aSearchQuery [
	| searchResult |
	searchResult := (self findMediaByQuery: aSearchQuery) select: [ :eachMediaOrSet |
		eachMediaOrSet canView: aUser ].
	
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

{ #category : #finders }
MEDDatabase >> findUserByEmail: aString [
	^ MEDUser selectOne: [ :each | each email = aString ]
]

{ #category : #finders }
MEDDatabase >> findUserByLdapUid: aString [
	aString ifBlank: [ ^ nil ].
	
	^ MEDUser selectOne: [ :each | each ldapUid = aString ]
]

{ #category : #finders }
MEDDatabase >> findUserByUsername: aString [
	^ self findUserByEmail: aString
]

{ #category : #'as yet unclassified' }
MEDDatabase >> findUserGroupsByUser: aUser [
	^ MEDUserGroup selectMany: [ :each | (each at: 'users.__id' ) = aUser voyageId ]

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
