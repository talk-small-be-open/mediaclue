Extension { #name : #MAElementComponent }

{ #category : #'*Mediaclue' }
MAElementComponent >> renderViewerOn: html [
	html render: (self string ifBlank: [ MEDHelper noValueLabel ])
]
