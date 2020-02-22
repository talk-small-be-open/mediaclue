Extension { #name : #Object }

{ #category : #'*Webbase-Main' }
Object >> ifBlank: aBlock [
	^self isBlank
		ifTrue: aBlock
		ifFalse: [self]
]

{ #category : #'*Webbase-Main' }
Object >> ifBlank: aTrueBlock ifNotBlank: aFalseBlock [
	^self isBlank
		ifTrue: aTrueBlock
		ifFalse: [aFalseBlock cull: self]
]

{ #category : #'*Webbase-Main' }
Object >> ifNotBlank: aBlock [
	^self isBlank
		ifTrue: [self]
		ifFalse: [aBlock cull: self]
]

{ #category : #'*Webbase-Main' }
Object >> ifNotBlank: aFalseBlock ifBlank: aTrueBlock [
	^self isBlank
		ifTrue: aTrueBlock
		ifFalse: [aFalseBlock cull: self]
]

{ #category : #'*Webbase-Main' }
Object >> isBlank [
	^false
]

{ #category : #'*Webbase-Main' }
Object >> notBlank [
	^self isBlank not
]
