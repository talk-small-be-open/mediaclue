Trait {
	#name : #TWEBMagritteDescription,
	#traits : 'TWEBGlobalHelpers',
	#classTraits : 'TWEBGlobalHelpers classTrait',
	#category : #'Webbase-Magritte'
}

{ #category : #'accessing-defaults' }
TWEBMagritteDescription classSide >> defaultStringReader [
	^self pi defaultMaStringReader
]

{ #category : #'accessing-defaults' }
TWEBMagritteDescription classSide >> defaultStringWriter [
	^ self pi defaultMaStringWriter
]

{ #category : #'as yet unclassified' }
TWEBMagritteDescription >> conflictErrorMessage [
	^ self propertyAt: #conflictErrorMessage ifAbsent: [ 'Dieses Attribut wurde in Zwischenzeit von einem anderen Benutzer geändert!' ]
]

{ #category : #'as yet unclassified' }
TWEBMagritteDescription >> currentCssClasses [
	^super currentCssClasses copyWith: (self className)
]

{ #category : #accessing }
TWEBMagritteDescription >> example [
	^self propertyAt: #example ifAbsent: [ nil ]
]

{ #category : #accessing }
TWEBMagritteDescription >> example: anObject [
	self propertyAt: #example put: anObject
]

{ #category : #'as yet unclassified' }
TWEBMagritteDescription >> kindErrorMessage [
	^ self propertyAt: #kindErrorMessage ifAbsent: [ 'Ungültige Angabe.' ]
]

{ #category : #'as yet unclassified' }
TWEBMagritteDescription >> multipleErrorsMessage [
	^ self propertyAt: #multipleErrorsMessage ifAbsent: [ 'Mehrere Fehler' ]
]

{ #category : #'as yet unclassified' }
TWEBMagritteDescription >> requiredErrorMessage [
	^ self propertyAt: #requiredErrorMessage ifAbsent: [ 'Die Angabe ist zwingend.' ]
]

{ #category : #'as yet unclassified' }
TWEBMagritteDescription >> validatingParser: aParserClass [
	self addCondition: [:value | aParserClass new matches: value ] labelled: 'Syntax falsch'
]
