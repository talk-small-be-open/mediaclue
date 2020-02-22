Extension { #name : #String }

{ #category : #'*Webbase-Main' }
String >> asDromedaryCase [

	"Wie asCamelCase aber der erste unverändert"
	^ self class streamContents: [:stream |
		| strings |
		strings := self substrings.
		strings size <= 1 ifTrue: [ ^self ].
		
		stream nextPutAll: strings first.
		strings allButFirstDo: [:sub |
			stream nextPutAll: sub capitalized]]
]

{ #category : #'*Webbase-Main' }
String >> onlyDigits [
	"answer the receiver with only digits"
	^ self select: [:each | each isDigit]
]

{ #category : #'*Webbase-Main' }
String >> withoutSeparators [
	^ self reject: [:each | each isSeparator]
]
