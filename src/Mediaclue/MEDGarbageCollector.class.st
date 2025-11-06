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

	mediaSets := MEDMediaSet selectMany: [ :each | each owner = nil ].
"better alike?	mediaSets := MEDMediaSet selectMany: [ :each | each at: 'owner.__id' isNil ]."

	"Massive deletion stopper"
	mediaSets := mediaSets firstAtMost: 10.

	mediaSets do: [ :each |
		self trash: each.
		each delete.
	].

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
