Class {
	#name : #MEDUserGroupEditor,
	#superclass : #MEDUserGroupComponentBase,
	#traits : 'TMEDModelEditor',
	#classTraits : 'TMEDModelEditor classTrait',
	#category : #'Mediaclue-View'
}

{ #category : #initialization }
MEDUserGroupEditor >> initialize [
	super initialize.

	self addForm withStandardSaveCancelButtons.

]

{ #category : #rendering }
MEDUserGroupEditor >> renderModelOn: html [
	html pageHeader: [
"		html iconEdit; space."
		html text: 'Gruppe "'.
		html text: model title.
		html text: '"'.
	].
	html pageBody: [
		html maGrid: #title.
		html maGrid: #users.
		html maGrid: #canUpload.
		html maGrid: #uid.

	]

]
