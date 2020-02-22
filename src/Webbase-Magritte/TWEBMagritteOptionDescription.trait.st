Trait {
	#name : #TWEBMagritteOptionDescription,
	#category : #'Webbase-Magritte'
}

{ #category : #'as yet unclassified' }
TWEBMagritteOptionDescription >> beNotCachingOptions [
	self propertyAt: #isCachingOptions put: false
]

{ #category : #'as yet unclassified' }
TWEBMagritteOptionDescription >> favorites [
	^self propertyAt: #favorites
]

{ #category : #'as yet unclassified' }
TWEBMagritteOptionDescription >> favorites: aCollection [
	self propertyAt: #favorites put: aCollection
]

{ #category : #'as yet unclassified' }
TWEBMagritteOptionDescription >> hasFavorites [
	^self favorites notBlank
]

{ #category : #'as yet unclassified' }
TWEBMagritteOptionDescription >> options [
	| optionCollection isCachingOptions |
	"So, dass wir auch einen Block als Options angeben können, besser für Performance"
	
	optionCollection := super options.
	
	isCachingOptions := self propertyAt: #isCachingOptions ifAbsent: [true].
	
	"Einmaliges umwandeln von Block in Collection"
	optionCollection isBlock ifTrue: [
		| evaluatedBlock |
		evaluatedBlock := optionCollection value.
		isCachingOptions
			ifTrue: [
				optionCollection := evaluatedBlock.
				self options: optionCollection]
			ifFalse: [
				^evaluatedBlock]
	].
	
	^optionCollection
]

{ #category : #'as yet unclassified' }
TWEBMagritteOptionDescription >> optionsBlock: aBlock [
	self options: aBlock.
	self beNotCachingOptions.
]
