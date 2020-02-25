Class {
	#name : #MEDUserEditor,
	#superclass : #MEDUserComponentBase,
	#traits : 'TMEDModelEditor',
	#classTraits : 'TMEDModelEditor classTrait',
	#category : #'Mediaclue-View'
}

{ #category : #initialization }
MEDUserEditor >> initialize [
	super initialize.

	self addForm withStandardSaveCancelButtons.

]

{ #category : #rendering }
MEDUserEditor >> renderModelOn: html [
	html pageHeader: [
		html text: 'Benutzer "'.
		html text: model displayName.
		html text: '"'.
	].
	html pageBody: [
		html maGrid: #firstName.
		html maGrid: #lastName.
		html maGrid: #email.
		html maGrid: #ldapUid.
		html maGrid: #isAdmin.
		html maGrid: #disabled.
	]

]
