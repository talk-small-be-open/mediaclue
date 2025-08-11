Class {
	#name : #MEDMaPermissionTypeComponent,
	#superclass : #MEDMaSelectListComponent,
	#category : #'Mediaclue-Magritte'
}

{ #category : #rendering }
MEDMaPermissionTypeComponent >> renderEditorForUngroupedOn: html [
	| select detailsGridJs |
	
	detailsGridJs := [ (html jQuery this closest: 'div.grid') nextAll: 'div.grid.permissionTypeDetails' ].
	
	select := html select
		id: self labelId;
		list: self options;
		selected: self value;
		callback: [ :value | self value: value ];
		labels: [ :value | self labelForOption: value ];
		onChange: (
			(detailsGridJs value show)
				condition: ((html jQuery this find: 'option:selected') text isEqual: (self labelForOption: #groups))
				else: (detailsGridJs value hide)
		);
		yourself.

	self value ~= #groups ifTrue: [
		select script: (detailsGridJs value hide) ]
]
