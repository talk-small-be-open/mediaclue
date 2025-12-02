Class {
	#name : #MEDMediaSetEditor,
	#superclass : #MEDMediaSetComponentBase,
	#traits : 'TMEDModelEditor',
	#classTraits : 'TMEDModelEditor classTrait',
	#instVars : [
		'isEditMedia',
		'mediaEditors',
		'bulkSource',
		'bulkTags',
		'bulkPermissions',
		'medias',
		'isWithBulkOperations'
	],
	#category : #'Mediaclue-View'
}

{ #category : #actions }
MEDMediaSetEditor >> afterSave [
	self saveSubEditors.

	isWithBulkOperations ifTrue: [
		self doBulkOperationsOnModel ].
]

{ #category : #actions }
MEDMediaSetEditor >> afterSaveAndStay [
	self initializeSubEditors
]

{ #category : #actions }
MEDMediaSetEditor >> afterTrySave [
"	self initializeSubEditors"
]

{ #category : #'as yet unclassified' }
MEDMediaSetEditor >> beOverwriteMediaProperties [
	bulkSource := 'owner'.
	bulkTags := #subjects.
	bulkPermissions := true.

]

{ #category : #'as yet unclassified' }
MEDMediaSetEditor >> beWithBulkOperations [
	isWithBulkOperations := true
]

{ #category : #'as yet unclassified' }
MEDMediaSetEditor >> beWithMedias [
	isEditMedia := true.
"	medias := model mediasForUserAsEditor: self currentUser."
	self initializeSubEditors
]

{ #category : #actions }
MEDMediaSetEditor >> beforeSave [
	isWithBulkOperations ifTrue: [
		self doBulkOperationsOnForm ].
	
	self validateSubEditors ifFalse: [ ^ false ].
"	self saveSubEditors."
	
	^true

]

{ #category : #accessing }
MEDMediaSetEditor >> bulkPermissions [
	^ bulkPermissions
]

{ #category : #accessing }
MEDMediaSetEditor >> bulkPermissions: anObject [
	bulkPermissions := anObject
]

{ #category : #accessing }
MEDMediaSetEditor >> bulkSource [
	^ bulkSource
]

{ #category : #accessing }
MEDMediaSetEditor >> bulkSource: anObject [
	bulkSource := anObject
]

{ #category : #accessing }
MEDMediaSetEditor >> bulkTags [
	^ bulkTags
]

{ #category : #accessing }
MEDMediaSetEditor >> bulkTags: anObject [
	bulkTags := anObject
]

{ #category : #hooks }
MEDMediaSetEditor >> children [
	^super children copyWithAll: (
		mediaEditors ifNil: [#()])
]

{ #category : #actions }
MEDMediaSetEditor >> doBulkOperationsOnForm [

	"Hinweis: Das sieht nach gebastel aus, aber wir kommen nicht drumherum,
	auf der Memento-Ebene zu arbeiten und nicht direkt auf den Models. Magritte-like."

	mediaEditors ifBlank: [ ^self ].

	(bulkSource isNil and: [ bulkTags = #none ])
		ifTrue: [ ^self ].

	mediaEditors do: [ :each |
		bulkSource ifNotNil: [
			(each formAt: #source) ifNil: [
				each formAt: #source write: bulkSource].
		].
	
		bulkTags = #subjects ifTrue: [
			| tags |
			tags := MEDTag tagsFromString: (self formAt: #tagsCommaSeparatedTrimmed).
			tags := tags select: [ :eachTag | eachTag isSchoolSubject ].
			tags ifNotEmpty: [
				| newTagsString |
				newTagsString := MEDTag stringFromTags: tags.
				(each formAt: #tagsCommaSeparatedTrimmed) ifNotBlank: [ :currentString |
					newTagsString := currentString, ',', newTagsString ].
				each formAt: #tagsCommaSeparatedTrimmed write: newTagsString]
		].

		bulkTags = #all ifTrue: [
			| new |
			new := (self formAt: #tagsCommaSeparatedTrimmed).
			(each formAt: #tagsCommaSeparatedTrimmed) ifNotBlank: [ :current |
				new := current, ',', new ].
			each formAt: #tagsCommaSeparatedTrimmed write: new
		].

		each save.
	]
]

{ #category : #actions }
MEDMediaSetEditor >> doBulkOperationsOnModel [

"	mediaEditors ifBlank: [ ^self ]."

	medias do: [ :each |

		"Machen wir immer nur auf Model, und nicht im Formular"
		bulkPermissions ifTrue: [
			each permissionType: model permissionType.
			each readPermittedAuthorities: model readPermittedAuthorities copy.
			each writePermittedAuthorities: model writePermittedAuthorities copy.
		].
	
		"Machen wir auf dem Model, falls wir kein inline-Form haben"
		isEditMedia ifFalse: [

			bulkSource ifNotNil: [
				each source ifNil: [
					each source: bulkSource].
			].
		
			bulkTags = #subjects ifTrue: [
				| newTags |
				newTags := model schoolSubjectTags.
				newTags ifNotEmpty: [
					each addTags: newTags]
			].

			bulkTags = #all ifTrue: [
				| newTags |
				newTags := model tags.
				newTags ifNotEmpty: [
					each addTags: newTags]
			]
		].

		each save.
	]
]

{ #category : #initialization }
MEDMediaSetEditor >> initialize [
	super initialize.
	self beRestoringScrollPosition.
	
"	isEditMedia ifNil: ["

	isEditMedia := false.
	isWithBulkOperations := false.	

	medias := model mediasForUserAsEditor: self currentUser.
	 
	self addForm withStandardSaveCancelButtons.
	
	bulkSource := nil.
	bulkTags := #none.
	bulkPermissions := false.
	
"	self initializeSubEditors"
]

{ #category : #initialization }
MEDMediaSetEditor >> initializeSubEditors [
	isEditMedia ifTrue: [
		mediaEditors := medias collect: [ :each |
			MEDMediaEditor forInline: each ]]
]

{ #category : #rendering }
MEDMediaSetEditor >> renderBulkOperationsOn: html [
	html div class: 'bulkOperations pure-form-stacked'; with: [
		html fieldSet: [
			| sources map |
			sources := MEDHelper sourceIndicationCodes.
			map := MEDHelper sourceIndicationMap.
			
			html legend: 'Schnell-Zuweisungen für alle Medien'.

			html div class: 'label'; with: 'Quelle setzen, sofern nicht gesetzt:'.
			html select
				list: sources;
				labels: [ :each | map at: each ];
				beOptional;
				on: #bulkSource of: self.

			html div class: 'label'; with: 'Berechtigungen übernehmen:'.
			html label with: [
				html checkbox on: #bulkPermissions of: self.
				html space.
				html span: 'Ja'].
			
			html div class: 'label'; with: 'Schlagworte aus Kollektion hinzufügen:'.
			html radioGroup
				selected: self bulkTags;
				callback: [ :value | self bulkTags: value ];
				with: [ :rg |
					html label class: 'pure-checkbox'; with: [
						rg radioButton value: #none.
						html span: ' Keine'].
					html label class: 'pure-checkbox'; with: [
						rg radioButton value: #subjects.
						html span: ' Nur Haupt-Schlagworte'].
					html label class: 'pure-checkbox'; with: [
						rg radioButton value: #all.
						html span: ' Alle Schlagworte'].
			]
	]].

	self renderFormButtonsOn: html
]

{ #category : #rendering }
MEDMediaSetEditor >> renderModelOn: html [
	html pageHeader: [
		html iconEdit; space.
		html text: 'Kollektion "'.
		html text: model title.
		html text: '"'.
	].
	html pageBody: [

		html maGrid: #title.
		html maGrid: #description.
		html maGrid: #tagsCommaSeparatedTrimmed.
		html maGrid: #permissionType.
		html maGrid: #readPermittedAuthorities.
		html maGrid: #writePermittedAuthorities.
		html maGrid: #sortPath.
		html maGrid: #createdAt.
		html maGrid: #isGallery.

		isWithBulkOperations ifTrue: [
			self renderBulkOperationsOn: html].

		isEditMedia
			ifFalse: [ 
				html pageSubheader: 'Medienübersicht'.
				medias do: [ :each |
					html thumbnail: each]]
			ifTrue: [
				html div class: 'inlineEditors'; with: [
					mediaEditors do: [ :each |
						html div class: 'inlineEditor'; with: each ].
				]
		]]
]

{ #category : #initialization }
MEDMediaSetEditor >> saveSubEditors [
	isEditMedia ifTrue: [
		mediaEditors do: #save]
]

{ #category : #initialization }
MEDMediaSetEditor >> validateSubEditors [
	^ isEditMedia not or: [
		mediaEditors allSatisfy: [ :each | each validateMaComponent ] ]
]
