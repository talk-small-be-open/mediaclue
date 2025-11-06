Class {
	#name : #MEDTagsMergeComponent,
	#superclass : #MEDComponent,
	#instVars : [
		'sourceTag',
		'targetTag',
		'allTags',
		'sourceUsedCount',
		'targetUsedCount'
	],
	#category : #'Mediaclue-View'
}

{ #category : #'instance creation' }
MEDTagsMergeComponent class >> source: aSourceTag target: aTargetTag [
	^ self basicNew
		sourceTag: aSourceTag;
		targetTag: aTargetTag;
		initialize;
		yourself
]

{ #category : #initialization }
MEDTagsMergeComponent >> initialize [
	super initialize.
	allTags := self db tags sortedBySortKey.
]

{ #category : #testing }
MEDTagsMergeComponent >> isReadyToMerge [
	| no |
	no := [ ^ false ].
	
	sourceTag ifNil: no.

	targetTag ifNil: no.
	
	targetTag = sourceTag ifTrue: no.
	
	^ true
]

{ #category : #'as yet unclassified' }
MEDTagsMergeComponent >> mergeNow [
	
	| component question |
	
	question := '"', sourceTag title, '" übertragen auf "', targetTag title, '"?'.
	
	self confirmYesNo: question ifYes: [ 
		
		component := WEBBackgroundJobComponent
			jobTitle: 'mergetags'
			named: 'Schlagworte zusammenführen'
			block: [ self offloadedMerge ].

		component beAutoClose.
		
		self show: component onAnswer: [
			self close.
			self flashMessage: 'Zusammenführung abgeschlossen' ] ]
]

{ #category : #'as yet unclassified' }
MEDTagsMergeComponent >> offloadedMerge [
	"Do NOT use seaside component code in here, there is no request context, since it is offloaded"

	"1. Get all media by tag and exchange"
	| medias mediaSets |
	medias := MEDMediaAsset selectMany: [ :each |
"geht nicht mit objekten		each tagList includes: sourceTag"
		(each at: 'tagList.__id') includes: sourceTag voyageId
	].

	mediaSets := MEDMediaSet selectMany: [ :each |
		(each at: 'tagList.__id') includes: sourceTag voyageId
	].

	
"	medias inspect.
	mediaSets inspect."
	
	(medias, mediaSets) do: [ :each |
		each removeTag: sourceTag.
		each addTag: targetTag.
		each save.
	].

	"doublec check before deletion"
	sourceTag deleteIfPossible
]

{ #category : #actions }
MEDTagsMergeComponent >> preview [
	"Calculate some numbers"
	sourceUsedCount := 1.
	targetUsedCount := 1.
]

{ #category : #rendering }
MEDTagsMergeComponent >> renderContentOn: html [

	html pageHeader: 'Schlagworte zusammenführen' body: [

		html form class: 'bottomBuffer'; with: [
			html div class: 'bottomBuffer'; with: [
				html div: 'Altes Schlagwort (wird gelöscht):'.
				html selectizeSelect
					list: (allTags copyWithout: targetTag);
					labels: [ :each | each title ];
					beOptional;
					on: #sourceTag of: self.

				sourceTag ifNotNil: [
					html div: [
						html text: sourceTag usageCount asString.
						html text: ' mal verwendet' ]
				].
			].
		
			html div class: 'bottomBuffer'; with: [ 		
				html div: '... wird übertragen auf bestehendes Schlagwort:'.

				html selectizeSelect
					list: (allTags copyWithout: sourceTag);
					labels: [ :each | each title ];
					beOptional;
					on: #targetTag of: self.

				targetTag ifNotNil: [
					html div: [
						html text: targetTag usageCount asString.
						html text: ' mal verwendet' ]
				].
			].
		
			html submitButton
				callback: [ self preview ];
				with: 'Aktualisieren'
		].


		self isReadyToMerge ifTrue: [	
			html anchorButton
				callback: [ self mergeNow ];
				with: 'Jetzt zusammenführen!' ].
	]
]

{ #category : #accessing }
MEDTagsMergeComponent >> sourceTag [
	^ sourceTag
]

{ #category : #accessing }
MEDTagsMergeComponent >> sourceTag: anObject [
	sourceTag := anObject
]

{ #category : #accessing }
MEDTagsMergeComponent >> targetTag [
	^ targetTag
]

{ #category : #accessing }
MEDTagsMergeComponent >> targetTag: anObject [
	targetTag := anObject
]
