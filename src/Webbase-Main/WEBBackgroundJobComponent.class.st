Class {
	#name : #WEBBackgroundJobComponent,
	#superclass : #WEBBackgroundJobComponentBase,
	#category : #'Webbase-Main-Offloading'
}

{ #category : #rendering }
WEBBackgroundJobComponent >> renderContentOn: html [
	| refreshMs |
	
	refreshMs := self ifDevelopment: [ 1000 ] else: [ 5000 ].
	
	self isGenerating
		ifTrue: [
			html alertWarning
				with: [
					html h4: [
						html spinner; space; space.
						html text: 'Einen Moment bitte'
					].
					html paragraph: [
						html span: self jobTitle.
						self ifDevelopment: [
							html break.
							html anchor
								callback: [self abort];
								with: 'Abbrechen']]].
			html script: ((html javascript
				callback: [ self checkIfFinished ]) setTimeout: refreshMs).
		]
		ifFalse: [
			job isSuccess ifTrue: [html alertSuccess: 'OK'].
			job isError ifTrue: [html alertDanger: 'FEHLER ', job errorDescription].
			html anchorButton
				callback: [self close];
				with: 'Vorgang fertig. Schliessen.'
		].

]
