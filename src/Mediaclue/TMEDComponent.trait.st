Trait {
	#name : #TMEDComponent,
	#category : #'Mediaclue-Traits'
}

{ #category : #'as yet unclassified' }
TMEDComponent >> beWithSideMenu [
	self addContainerClass: 'withSideMenu'

]

{ #category : #'as yet unclassified' }
TMEDComponent >> currentPortfolio [
	^self currentUser portfolio
]

{ #category : #actions }
TMEDComponent >> delete: aModel [
	self delete: aModel then: nil
]

{ #category : #actions }
TMEDComponent >> delete: aModel then: aBlock [
	self confirmYesNo: 'Wirklich löschen?' ifYes: [
		aModel delete.
		aBlock ifNotNil: aBlock ]
]

{ #category : #actions }
TMEDComponent >> edit: aModel [
	| editor |
	editor := aModel asComponent
		addValidatedForm;
		yourself.
		
	self show: editor
]

{ #category : #actions }
TMEDComponent >> edit: aModel afterSave: aBlock [
	| editor |
	editor := aModel asComponent
		addValidatedForm;
		yourself.
		
	self show: editor onAnswer: [ :answer |
		answer ifNotNil: [
			aModel save.
			aBlock ifNotNil: [ aBlock value ] ] ]
]

{ #category : #actions }
TMEDComponent >> editAndSave: aModel [
	self edit: aModel afterSave: nil
]

{ #category : #actions }
TMEDComponent >> showMedia: aMedia [
	self show: (MEDMediaViewer for: aMedia) addBackButton.
]

{ #category : #'as yet unclassified' }
TMEDComponent >> showMediaSet: aMediaSet [
	self show: ((MEDMediaSetViewer mediaSet: aMediaSet) addBackButton; yourself).
]

{ #category : #'as yet unclassified' }
TMEDComponent >> showMediaSet: aMediaSet onAnswer: aBlock [
	self show: ((MEDMediaSetViewer mediaSet: aMediaSet) addBackButton; yourself) onAnswer: aBlock
]
