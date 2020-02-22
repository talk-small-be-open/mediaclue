Class {
	#name : #WEBBackgroundJobIndicatorComponent,
	#superclass : #WEBBackgroundJobComponentBase,
	#instVars : [
		'containerId',
		'isVanished'
	],
	#category : #'Webbase-Main-Offloading'
}

{ #category : #actions }
WEBBackgroundJobIndicatorComponent >> close [
	super close.
	self vanish
]

{ #category : #initialization }
WEBBackgroundJobIndicatorComponent >> initialize [

	super initialize.

	isVanished := job isNil.
	isAutoClose := true.

]

{ #category : #rendering }
WEBBackgroundJobIndicatorComponent >> renderContentOn: html [
	isVanished ifTrue: [ ^self ].
	
	containerId := html nextId.
	html div id: containerId; with: [self renderCoreContentOn: html]
]

{ #category : #rendering }
WEBBackgroundJobIndicatorComponent >> renderCoreContentOn: html [

	self isGenerating
		ifTrue: [
			html script: ((
				(html jQuery id: containerId) load
					html: [:h | self renderCoreContentOn: h]
				) addDecoration: (JSTimeout duration: 2000)).

			html span
				class: 'indicator bg-info';
				with: [
					html iconWait; space.
					html span: self jobTitle].
		]
		ifFalse: [
			job isSuccess ifTrue: [
"				self vanish.
				html script: ((
					html jQuery ajax
					callback: [self checkIfFinished]
				) timeout: 2000)."
				
				html span
					class: 'indicator bg-success';
					with: [
					html iconTick; space.
					html text: 'OK'.
					html space.
					html span class: 'text-muted'; with: job stopTimestamp germanString]].
			job isError ifTrue: [
				html span
					class: 'indicator bg-danger';
					with: 'FEHLER'.
				html comment: job errorDescription].
"			html bsAnchorButton
				callback: [self close];
				with: 'Vorgang fertig. Schliessen.'"
		].

]

{ #category : #'as yet unclassified' }
WEBBackgroundJobIndicatorComponent >> vanish [
	isVanished := true
]
