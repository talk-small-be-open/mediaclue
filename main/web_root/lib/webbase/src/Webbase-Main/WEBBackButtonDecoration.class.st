Class {
	#name : #WEBBackButtonDecoration,
	#superclass : #WEBComponentDecoration,
	#instVars : [
		'label'
	],
	#category : #'Webbase-Main-View'
}

{ #category : #testing }
WEBBackButtonDecoration >> isGlobal [
	^false
]

{ #category : #accessing }
WEBBackButtonDecoration >> label [
	^ label ifBlank: [ 'Zurück' ]
]

{ #category : #accessing }
WEBBackButtonDecoration >> label: anObject [
	label := anObject
]

{ #category : #rendering }
WEBBackButtonDecoration >> renderContentOn: html [
	html div class: 'backButton'; with: [
		html backButtonAnchor
			useBaseUrl;
			callback: [self decoratedComponent cancel];
			with: [
				html iconBack.
				html span class: 'backButtonLabel'; with: self label]].
	self renderNextOn: html.

]
