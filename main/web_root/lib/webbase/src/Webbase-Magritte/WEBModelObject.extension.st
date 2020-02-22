Extension { #name : #WEBModelObject }

{ #category : #'*Webbase-Magritte' }
WEBModelObject >> descriptionUuidString [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #uuidString;
		label: 'UUID';
		beReadonly;
		beHidden;
		yourself
]
