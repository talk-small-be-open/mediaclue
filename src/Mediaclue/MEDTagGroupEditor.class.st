Class {
	#name : #MEDTagGroupEditor,
	#superclass : #MEDTagGroupComponentBase,
	#traits : 'TMEDModelEditor',
	#classTraits : 'TMEDModelEditor classTrait',
	#category : #'Mediaclue-View'
}

{ #category : #initialization }
MEDTagGroupEditor >> initialize [
	super initialize.

	self addForm withStandardSaveCancelButtons.

]

{ #category : #rendering }
MEDTagGroupEditor >> renderModelOn: html [
	html pageHeader: [
		html text: 'Schlagwortgruppe "'.
		html text: model title.
		html text: '"'.
	].
	html pageBody: [
		
		html maGrid: #title.
		html maGrid: #isMainTagGroup.
		html maGrid: #tags.
	]

]
