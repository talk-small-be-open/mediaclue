Class {
	#name : #MEDClipboardViewer,
	#superclass : #MEDComponent,
	#instVars : [
		'clipboardMediaSet'
	],
	#category : #'Mediaclue-View'
}

{ #category : #initialization }
MEDClipboardViewer >> initialize [
	super initialize.

	clipboardMediaSet := self currentPortfolio clipboard
]

{ #category : #testing }
MEDClipboardViewer >> isEmpty [
	^ clipboardMediaSet isEmpty
]

{ #category : #rendering }
MEDClipboardViewer >> renderContentOn: html [
	html div class: 'clipboardArea'; with: [ 
"		html div class: 'title'; with: 'Zwischenablage'."
		clipboardMediaSet isEmpty
			ifTrue: [ html paragraph: 'leer' ]
			ifFalse: [
				html grid: [ 
					clipboardMediaSet do: [ :each |
						html gridUnitFraction: 1/4 with: [ 
							html thumbnail: each ]
					 ] ] ] ]
]
