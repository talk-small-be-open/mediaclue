Class {
	#name : #WEBLightbox,
	#superclass : #WEBComponentDecoration,
	#instVars : [
		'delegate',
		'title',
		'showClose',
		'isLarge'
	],
	#category : #'Webbase-Main-View'
}

{ #category : #'as yet unclassified' }
WEBLightbox >> beLarge [
	isLarge := true
]

{ #category : #'as yet unclassified' }
WEBLightbox >> children [
	^ super children copyWith: self delegate
]

{ #category : #'as yet unclassified' }
WEBLightbox >> close [
	self delegate answer: nil
]

{ #category : #accessing }
WEBLightbox >> delegate [
	^ delegate
]

{ #category : #accessing }
WEBLightbox >> delegate: anObject [
	delegate := anObject
]

{ #category : #initialization }
WEBLightbox >> initialize [
	super initialize.
	showClose := false.
	isLarge := false.
]

{ #category : #'as yet unclassified' }
WEBLightbox >> isDelegation [
	^ true
]

{ #category : #accessing }
WEBLightbox >> isLarge [
	^ isLarge
]

{ #category : #accessing }
WEBLightbox >> isLarge: anObject [
	isLarge := anObject
]

{ #category : #rendering }
WEBLightbox >> renderContentOn: html [
	"subclasses should define the real modal lightbox dialog"
	self renderNextOn: html.
	
	html div
		class: 'WEBLightbox';
		style: 'position: fixed; top: 0; right: 0; left: 0; bottom: 0; background-color: rgba(100,100,100, 0.8); padding: 20%; z-index: 999999999';
		tabIndex: -1;
		with: [
			html div style: 'background-color: white; padding: 1em;'; with: [
				(title notBlank or: showClose) ifTrue: [
					html heading level4; with: title.
					showClose ifTrue: [
						html anchor
							callback: [ self close ];
							with: 'Schliessen'].
				].
				html render: delegate]]
]

{ #category : #'as yet unclassified' }
WEBLightbox >> showCloseButton: aBoolean [
	showClose := aBoolean
]

{ #category : #accessing }
WEBLightbox >> title [
	^ title
]

{ #category : #accessing }
WEBLightbox >> title: anObject [
	title := anObject
]
