Class {
	#name : #MEDTagEditor,
	#superclass : #MEDTagComponentBase,
	#traits : 'TMEDModelEditor',
	#classTraits : 'TMEDModelEditor classTrait',
	#category : #'Mediaclue-View'
}

{ #category : #initialization }
MEDTagEditor >> initialize [
	super initialize.

	self addForm withStandardSaveCancelButtons.

]

{ #category : #rendering }
MEDTagEditor >> renderModelOn: html [
	html pageHeader: [
		html text: 'Schlagwort "'.
		html text: model title.
		html text: '"'.
	].
	html pageBody: [

		html table class: 'bottomBuffer'; with: [ 
			html tableRow: [ 
				html tableHeading: 'Anzahl Verwendung'.
				html tableData: model usageCount asString ].
		].
		
		html maGrid: #title.
"obsolete?		html maGrid: #category."
		html maGrid: #isSchoolSubject.
	]

]
