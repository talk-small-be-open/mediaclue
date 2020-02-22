"
I am a reusable flexible component, which displays simple content.
"
Class {
	#name : #WEBPluggableComponent,
	#superclass : #WEBComponent,
	#instVars : [
		'titleRenderBlock',
		'contentRenderBlock',
		'contentComponent',
		'contentText',
		'titleText',
		'panelDecoration',
		'showCloseButton',
		'onUpdateRootBlock'
	],
	#category : #'Webbase-Main-View'
}

{ #category : #'as yet unclassified' }
WEBPluggableComponent class >> blank [
	^ self newWithStyle: 'blank'
]

{ #category : #'as yet unclassified' }
WEBPluggableComponent class >> blue [
	^ self newWithStyle: 'dblue'
]

{ #category : #accessing }
WEBPluggableComponent class >> content: aBlock [
	^self new
		content: aBlock;
		yourself
]

{ #category : #'as yet unclassified' }
WEBPluggableComponent class >> green [
	^ self newWithStyle: 'green'
]

{ #category : #'as yet unclassified' }
WEBPluggableComponent class >> newWithStyle: aString [
	| decoration |
	decoration := (WEBDivDecoration cssClass: aString).
	^ self new
		addDecoration: decoration;
		yourself.
]

{ #category : #'as yet unclassified' }
WEBPluggableComponent class >> red [
	^ self newWithStyle: 'red'
]

{ #category : #accessing }
WEBPluggableComponent >> children [
	^ Array with: contentComponent
]

{ #category : #accessing }
WEBPluggableComponent >> content: aBlock [
	contentRenderBlock := aBlock.
]

{ #category : #accessing }
WEBPluggableComponent >> contentComponent: anObject [
	contentComponent := anObject.
	contentComponent onAnswer: [:value | self answer: value]
]

{ #category : #accessing }
WEBPluggableComponent >> contentText: aString [
	contentText := aString.
]

{ #category : #'initialize-release' }
WEBPluggableComponent >> initialize [
	super initialize.
	showCloseButton := false.
]

{ #category : #'as yet unclassified' }
WEBPluggableComponent >> onUpdateRoot: aBlock [
	onUpdateRootBlock := aBlock
]

{ #category : #rendering }
WEBPluggableComponent >> renderContentOn: html [
	"Renders the given content, either a pluggable block or a full component instance"

	titleRenderBlock ifNotNil: [html heading level: 2; with: [titleRenderBlock value: html]].
	titleText ifNotNil: [html heading level: 2; with: titleText].
	contentRenderBlock ifNotNil: [html div: [contentRenderBlock value: html.]].
	contentComponent ifNotNil: [html div: contentComponent].
	contentText ifNotNil: [html paragraph: contentText].
	
	showCloseButton ifTrue: [
		html anchor
			class: 'button';
			callback: [self answer];
			with: 'Schliessen']
]

{ #category : #accessing }
WEBPluggableComponent >> showCloseButton [
	^ showCloseButton
]

{ #category : #accessing }
WEBPluggableComponent >> showCloseButton: anObject [
	showCloseButton := anObject
]

{ #category : #accessing }
WEBPluggableComponent >> title: aBlock [
	titleRenderBlock := aBlock.
]

{ #category : #accessing }
WEBPluggableComponent >> titleText: aString [
	titleText := aString.
]

{ #category : #'as yet unclassified' }
WEBPluggableComponent >> updateRoot: anHtmlRoot [
	super updateRoot: anHtmlRoot.
	onUpdateRootBlock ifNotNil: [onUpdateRootBlock value: anHtmlRoot]
]
