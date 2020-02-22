Extension { #name : #WEBProjectInfo }

{ #category : #'*Webbase-Magritte' }
WEBProjectInfo >> defaultMaStringReader [
	^ self concreteClassOf: WEBMaStringReader
]

{ #category : #'*Webbase-Magritte' }
WEBProjectInfo >> defaultMaStringWriter [
	^ self concreteClassOf: WEBMaStringWriter
]
