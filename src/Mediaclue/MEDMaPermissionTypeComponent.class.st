Class {
	#name : #MEDMaPermissionTypeComponent,
	#superclass : #MEDMaSelectListComponent,
	#category : #'Mediaclue-Magritte'
}

{ #category : #rendering }
MEDMaPermissionTypeComponent >> renderEditorForUngroupedOn: html [
	| select |
	
	select := html select
		id: self labelId;
		list: self options;
		selected: self value;
		callback: [ :value | self value: value ];
		labels: [ :value | self labelForOption: value ];
		onChange: (
			(((html jQuery this closest: 'div.grid') next: 'div.grid') show)
				condition: ((html jQuery this find: 'option:selected') text isEqual: (self labelForOption: #groups))
				else: (((html jQuery this closest: 'div.grid') next: 'div.grid') hide)
		);
		yourself.

	self value ~= #groups ifTrue: [
		select script: (((html jQuery this closest: 'div.grid') next: 'div.grid') hide) ]
]
