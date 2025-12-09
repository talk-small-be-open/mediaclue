Class {
	#name : #MEDUserGroupViewer,
	#superclass : #MEDUserGroupComponentBase,
	#category : #'Mediaclue-View'
}

{ #category : #'as yet unclassified' }
MEDUserGroupViewer >> editMyself [
	self show: (MEDUserGroupEditor model: model) onAnswer: [ self refresh ]
]

{ #category : #rendering }
MEDUserGroupViewer >> renderModelOn: html [
	html pageHeader: [
"		html iconEdit; space."
		html text: 'Gruppe "'.
		html text: model title.
		html text: '"'.
	].
	html pageBody: [
		html anchorButton
			callback: [ self editMyself ];
			with: 'Bearbeiten'.
				
		html maGrid: #title.
		html maGrid: #usersSorted.
		html maGrid: #canUpload.
		html maGrid: #uid.
	]

]
