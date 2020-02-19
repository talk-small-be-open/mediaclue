Class {
	#name : #MEDMediaEditor,
	#superclass : #MEDMediaComponentBase,
	#traits : 'TMEDModelEditor',
	#classTraits : 'TMEDModelEditor classTrait',
	#instVars : [
		'uiType'
	],
	#category : #'Mediaclue-View'
}

{ #category : #private }
MEDMediaEditor class >> classForMedia: aMedia [
	^aMedia editorClass
]

{ #category : #'as yet unclassified' }
MEDMediaEditor class >> forInline: aMedia [
	^ (self for: aMedia)
		beInline;
		removeForm;
		yourself
]

{ #category : #'as yet unclassified' }
MEDMediaEditor >> beInline [
	uiType := #inline
]

{ #category : #initialization }
MEDMediaEditor >> initialize [
	super initialize.

	self addForm withStandardSaveCancelButtons
]

{ #category : #rendering }
MEDMediaEditor >> renderModelDefaultOn: html [
	html pageHeader: [
		html iconEdit; space.
		html text: model classDisplayName.
		html text: ' bearbeiten'].
	html pageBody: [ 
		html thumbnail: model.
		html maGrid: #title.
"		html maGrid: #owner."
		html maGrid: #originDate.
		html maGrid: #description.
		html maGrid: #source.
		html maGrid: #permissionType.
		html maGrid: #readPermittedAuthorities.
		html maGrid: #writePermittedAuthorities.
		html maGrid: #tagsCommaSeparatedTrimmed
		].
]

{ #category : #rendering }
MEDMediaEditor >> renderModelInlineOn: html [
"	html pageHeader: [
		html iconEdit; space.
		html text: model classDisplayName.
		html text: ' bearbeiten']."
	html pageBody: [ 
		html thumbnail: model.
		html maGrid: #title.
"		html maGrid: #owner."
"		html maGrid: #originDate."
		html maGrid: #description.
"		html maGrid: #source."
"		html maGrid: #permissionType.
		html maGrid: #readPermittedAuthorities.
		html maGrid: #writePermittedAuthorities."
		html maGrid: #tagsCommaSeparatedTrimmed
		].
]

{ #category : #rendering }
MEDMediaEditor >> renderModelOn: html [

	uiType = #inline ifTrue: [ self renderModelInlineOn: html. ^ self ].

	self renderModelDefaultOn: html
]
