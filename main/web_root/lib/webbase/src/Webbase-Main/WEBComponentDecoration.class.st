Class {
	#name : #WEBComponentDecoration,
	#superclass : #WADecoration,
	#traits : 'TWEBComponentHelpers',
	#classTraits : 'TWEBComponentHelpers classTrait',
	#category : #'Webbase-Main-View'
}

{ #category : #decorations }
WEBComponentDecoration >> maxHeight: aHeightInteger [
	self addDecoration: (WEBDivDecoration cssStyle: ('max-height:', aHeightInteger greaseString, 'px'))
]

{ #category : #actions }
WEBComponentDecoration >> popupPreviewExercise: anExercise [
	| previewer |
	previewer := (WEBIframeDialog new)
		url: anExercise staticEmulatorUrl;
		width: '100%';
		height: '900px';
		yourself.

	self lightbox: previewer title: 'Vorschau' showClose: true large: true
]
