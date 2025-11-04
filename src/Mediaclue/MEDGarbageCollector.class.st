Class {
	#name : #MEDGarbageCollector,
	#superclass : #WEBGarbageCollector,
	#category : #'Mediaclue-Database'
}

{ #category : #'as yet unclassified' }
MEDGarbageCollector >> gcAll [
	self gcUsers.
	self gcMediaSetsWithNoOwner.
]

{ #category : #'as yet unclassified' }
MEDGarbageCollector >> gcMediaSetsWithNoOwner [
	| mediaSets |

	mediaSets := MEDMediaSet selectMany: [ :each | each owner isNil ].
"better alike?	mediaSets := MEDMediaSet selectMany: [ :each | each at: 'owner.__id' isNil ]."

"TODO: activate. Dangerous.	mediaSets do: [ :each |
		self trash: each.
		each delete.
	]."

	^ mediaSets 
]

{ #category : #'as yet unclassified' }
MEDGarbageCollector >> gcUsers [
	| nonsenseUsers |

	nonsenseUsers := self db users select: [ :each |
		each lastName isBlank and: [ each firstName isBlank and: [ each ldapUid isBlank and: [ each email isBlank ] ] ]
	].

	nonsenseUsers do: [ :each |
		self trash: each.
		each delete.
	].

	^ nonsenseUsers 
]
