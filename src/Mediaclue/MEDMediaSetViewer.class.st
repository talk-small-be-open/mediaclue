Class {
	#name : #MEDMediaSetViewer,
	#superclass : #MEDMediaSetComponentBase,
	#instVars : [
		'mediaRenderer',
		'clipboardViewer'
	],
	#category : #'Mediaclue-View'
}

{ #category : #hooks }
MEDMediaSetViewer >> children [
	^Array with: clipboardViewer
]

{ #category : #actions }
MEDMediaSetViewer >> clearSelection [
	mediaRenderer clearSelection
]

{ #category : #actions }
MEDMediaSetViewer >> clipboardAddAll [
	model
		addAll: self currentPortfolio clipboard medias;
		save
]

{ #category : #actions }
MEDMediaSetViewer >> clipboardClear [
	self currentPortfolio clipboard clear; save.
]

{ #category : #actions }
MEDMediaSetViewer >> clipboardSaveAsNew [
	| mediaSet |
	mediaSet := self currentPortfolio clipboard createNewMediaSet.
	mediaSet owner: self currentUser.

	self show: (MEDMediaSetEditor mediaSet: mediaSet) onAnswer: [:answer |
		answer ifNotNil: [
			mediaSet save.
			self session announceDataChange ]]
]

{ #category : #actions }
MEDMediaSetViewer >> copySelectedToClipboard [
	self currentPortfolio clipboard addAll: self selectedMedia
]

{ #category : #actions }
MEDMediaSetViewer >> createPreviews [
	model do: [ :each |
		each createPreviewsOffloaded ].
	self inform: 'Die Vorschauen werden nun im Hintergrund laufend erstellt. Dies kann einige Zeit in Anspruch nehmen.'
]

{ #category : #'submorphs-add/remove' }
MEDMediaSetViewer >> delete [
	(self confirm: 'Diese Kollektion löschen? (Die enthaltenen Medien werden nicht gelöscht)' title: 'Löschen?' buttonText: 'Ja, jetzt löschen' cancelText: 'Abbrechen') ifTrue: [
		model delete.
		self session announceDataChange.
		self close
	 ]
]

{ #category : #'submorphs-add/remove' }
MEDMediaSetViewer >> deleteSelected [

	self ensureSelectionThen: [
		| mediasToDelete |

		mediasToDelete := self selectedMedia select: [ :each | each canEdit: self currentUser ].
		
		(self confirm: ('Die selektierten ', mediasToDelete size asString, ' Medien dauerhaft (!) löschen?') title: 'Löschen?' buttonText: 'Ja, jetzt löschen!' cancelText: 'Abbrechen') ifTrue: [

			mediasToDelete do: [ :each | each delete ].

"			model removeAll: mediasToDelete.
			model save."

			self clearSelection.

			self session announceDataChange.
			
			self flashMessage: 'Medien gelöscht'
		 ]
	]

]

{ #category : #'submorphs-add/remove' }
MEDMediaSetViewer >> deleteWithMedias [
	(self confirm: 'Diese Kollektion UND ALLE enthaltenen Medien (!) löschen?' title: 'Löschen?' buttonText: 'Ja, jetzt löschen' cancelText: 'Abbrechen') ifTrue: [
		(model mediasForUserAsEditor: self currentUser) do: [ :each | each delete ].
		model delete.
		self session announceDataChange.
		self close
	 ]
]

{ #category : #actions }
MEDMediaSetViewer >> downloadArchiveZip [
	| user |
	user := self currentUser.
	self offloadDownloadWork: [
		WEBZipGenerator generateFromMedias: (model mediasForUserAsViewer: user) named: 'Medien.zip'.
	]
]

{ #category : #actions }
MEDMediaSetViewer >> downloadImagesPdf [
	| user |
	user := self currentUser.
	self offloadDownloadWork: [
		self pi defaultPdfGeneratorClass
			generateImagesForPrint: (model imagesForUserAsViewer: user)
			title: model title
			fileNamed: ('Bilder ', (MEDHelper filenameFor: model title), '.pdf')
	]
]

{ #category : #actions }
MEDMediaSetViewer >> edit [
	self show: (MEDMediaSetEditor mediaSet: model) onAnswer: [
		self session announceDataChange.
		self refresh
	]
]

{ #category : #actions }
MEDMediaSetViewer >> editWithMedias [
	self
		show: ((MEDMediaSetEditor mediaSet: model)
			beWithMedias;
			beWithBulkOperations;
			yourself)
		onAnswer: [
			self session announceDataChange.
			self refresh
		]
]

{ #category : #actions }
MEDMediaSetViewer >> ensureSelectionThen: aBlock [
	self selectedMedia ifBlank: [ self inform: 'Sie haben keine Auswahl getroffen!'. ^ self ].

	aBlock cull: self selectedMedia 
]

{ #category : #initialization }
MEDMediaSetViewer >> initialize [
	super initialize.
	self beRestoringScrollPosition.
	self beWithSideMenu.
		
	mediaRenderer := MEDMediaRenderer component: self.
	mediaRenderer onClickMedia: [ :each | self showMedia: each ].
	
	clipboardViewer := MEDClipboardViewer new

]

{ #category : #actions }
MEDMediaSetViewer >> moveSelectedToClipboard [
	self copySelectedToClipboard.
	self removeSelected
]

{ #category : #actions }
MEDMediaSetViewer >> removeSelected [
	self ensureSelectionThen: [
		self confirmYesNo: 'Medien aus Kollektion entfernen?' ifYes: [
			model removeAll: self selectedMedia.
			model save.
			self clearSelection.
	]]
]

{ #category : #rendering }
MEDMediaSetViewer >> renderMedia: aMedia on: html [
	mediaRenderer renderBigCard: aMedia on: html.
"	mediaRenderer renderOneliner: aMedia on: html"
]

{ #category : #rendering }
MEDMediaSetViewer >> renderMediasOn: html [

	html div class: 'bulkSelection'; with: [
"		html checkbox
			value: self hasSelection."
		html anchor
			callback: [ self toggleSelectAll ];
			with: 'Alle auswählen'
	].
	html grid class: 'medias'; with: [
		model do: [ :each |
			html gridUnit: [
				self renderMedia: each on: html
			]
		]
	].

]

{ #category : #rendering }
MEDMediaSetViewer >> renderMenuOn: html [
	html sideMenu: [
			html menuHeading with: 'Kollektion'.

			"Class: pure-menu-selected"
			html menuList: [
				self ifCanEdit: [
					html menuEntry: [ self edit ] with: [html iconEdit; text: 'Bearbeiten'].
					html menuEntry: [ self editWithMedias ] with: [html iconEdit; text: 'Bearbeiten '; emphasis: 'mit Medien'].
					html menuEntry: [ self delete ] with: [ html iconDelete; text: 'Löschen'].
					html menuEntry: [ self deleteWithMedias ] with: [ html iconDelete; text: 'Löschen '; emphasis: 'mit Medien (!)'].
					self session canUpload ifTrue: [
						html menuEntry: [ self upload ] with: [ html iconUpload; text: 'Hierhin hochladen ...']].

					html menuEntry: [ self sortMedias ] with: [ html iconSort; text: 'Medien ordnen ...'].
					html menuDivider ].
				html menuEntry: [ self downloadArchiveZip ] with: [ html iconDownload; text: 'ZIP Download'].
				html menuEntry: [ self downloadImagesPdf ] with: [ html iconDownload; text: 'Bilder-PDF Download'].
				html menuDivider.
				html menuEntry: [ self showLighttable ] with: [ html iconPreview; text: 'Leuchtpult-Ansicht'].
				html menuEntry: [ self showStandardSlideshow ] with: [ html iconPreview; text: 'Diashow-Ansicht'].
"				html menuEntry: [ self edit ] with: 'Diashow'."
				html menuTitle: 'Selektierte Medien ...'.
				self ifCanEdit: [
					html menuEntry: [ self removeSelected ] with: [ html iconRemove; text: '... entfernen'].
				].
				html menuEntry: [ self copySelectedToClipboard ] with: [ html iconCopy; text: '... in Zw''ablage kopieren'].
				self ifCanEdit: [
					html menuEntry: [ self moveSelectedToClipboard ] with: [ html iconCopy; text: '... in Zw''ablage verschieben']].
				html menuTitle: 'Zwischenablage ...'.
				html div: clipboardViewer.
				clipboardViewer isEmpty ifFalse: [
					html menuEntry: [ self clipboardSaveAsNew ] with: '... als neue Kollektion speichern'.
					self ifCanEdit: [
						html menuEntry: [ self clipboardAddAll ] with: '... zur Kollektion hinzufügen'].
					html menuEntry: [ self clipboardClear ] with: '... leeren' ].

				self ifCanEdit: [
					html menuTitle: 'Etc.'.
					html menuEntry: [ self createPreviews ] with: 'Alle Vorschauen neu erzeugen'.
					"REMARK: Here all media will be tested individually, too"
					html menuEntry: [ self deleteSelected ] with: [ html "iconDelete;" text: 'Selektierte Medien löschen(!)'].
				].


				].

	]
]

{ #category : #rendering }
MEDMediaSetViewer >> renderModelOn: html [

	self renderMenuOn: html.

	html pageHeader: model title.

	html pageBody: [
		self renderPropertiesOn: html.

		html pageSubheader: 'Beschreibung'.
		html paragraph: [ html textOrNa: model description ].

		self renderMediasOn: html.
	]
]

{ #category : #rendering }
MEDMediaSetViewer >> renderPropertiesOn: html [
	html table class: 'properties'; with: [
		html maRow: #tagsCommaSeparated.
		html maRow: #sortPath.
		html maRow: #permissionType.
		html maRowIfNotBlank: #readPermittedAuthorities.
		html maRowIfNotBlank: #writePermittedAuthorities.
		self ifDevelopment: [ 
			html maRow: #uuidString ].
		html maRow: #owner.
		html maRow: #createdAt ].

]

{ #category : #selection }
MEDMediaSetViewer >> selectAll [
	mediaRenderer selectedMedia: (model mediasForUserAsViewer: self currentUser)
]

{ #category : #accessing }
MEDMediaSetViewer >> selectedMedia [
	^ mediaRenderer selectedMedia
]

{ #category : #accessing }
MEDMediaSetViewer >> selectedOrAll [
	^ self selectedMedia ifEmpty: [ model mediasForUserAsViewer: self currentUser ]
]

{ #category : #actions }
MEDMediaSetViewer >> showLighttable [
	self showWithBack: (MEDLighttableSlideshowComponent medias: self selectedOrAll)
]

{ #category : #actions }
MEDMediaSetViewer >> showStandardSlideshow [
	self showWithBack: (MEDStandardSlideshowComponent medias: self selectedOrAll)
]

{ #category : #actions }
MEDMediaSetViewer >> sortMedias [
	self show: (MEDMediaSetSorter mediaSet: model) onAnswer: [ self refresh ]
]

{ #category : #selection }
MEDMediaSetViewer >> toggleSelectAll [
	(mediaRenderer hasSelection)
		ifTrue: [ self unselectAll ]
		ifFalse: [ self selectAll ]
]

{ #category : #selection }
MEDMediaSetViewer >> unselectAll [
	mediaRenderer clearSelection
]

{ #category : #actions }
MEDMediaSetViewer >> upload [
	self show: (MEDUploadCockpitComponent into: model)
]
