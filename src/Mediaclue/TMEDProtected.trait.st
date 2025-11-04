Trait {
	#name : #TMEDProtected,
	#category : #'Mediaclue-Traits'
}

{ #category : #testing }
TMEDProtected >> canEdit: aUser [
	
	"Anonym hat NIE Schreibrechte"
	aUser ifNil: [ ^ false ].
	
	^ self owner = aUser or: [
		(self writePermittedAuthorities anySatisfy: [ :each | each containsUser: aUser ])
		or: [ aUser isAdmin ]
	]
]

{ #category : #testing }
TMEDProtected >> canView: aUser [
	| pt |

	pt := self permissionType.

	pt = #dontcheck ifTrue: [ ^ true ].

	pt = #public ifTrue: [ ^ true ].

	"Ab hier, darf der User nicht mehr anonym sein"
	aUser ifNil: [ ^ false ].

	"Owner kann immer"
	self owner = aUser ifTrue: [ ^ true ].

	pt = #all ifTrue: [ ^ aUser isKindOf: MEDUser "TODO simply true?" ].
	
	"Logisch nicht explizit nötig	pt = 'owner' ifTrue: [ ^ self owner = aUser ]."

	pt = #groups ifTrue: [
		(self readPermittedAuthorities anySatisfy: [ :each | each containsUser: aUser ]) ifTrue: [ ^ true ].
	].

	"Mit Schreibrechten kann immer"
	(self canEdit: aUser) ifTrue: [ ^ true ].
  
	^false

]

{ #category : #magritte }
TMEDProtected >> descriptionPermissionType [
	| map |
	<magritteDescription>
	
	map := MEDHelper permissionTypeList.
	
	^ MEDMaSingleOptionDescription new
		accessor: #permissionType;
		optionsAndLabels: map;
		label: 'Sichtbarkeit';
		beRequired;
		componentClass: MEDMaPermissionTypeComponent;
"		display: [ :each | map at: each ];"
		yourself
]

{ #category : #magritte }
TMEDProtected >> descriptionReadPermittedAuthorities [
	<magritteDescription>
	
	^ MEDMaMultipleOptionDescription new
		accessor: #readPermittedAuthorities;
		optionsBlock: [self db authorities];
		cssClass: 'permissionTypeDetails';
		label: 'Sichtbar auch für';
		yourself
]

{ #category : #magritte }
TMEDProtected >> descriptionWritePermittedAuthorities [
	<magritteDescription>
	
	^ MEDMaMultipleOptionDescription new
		accessor: #writePermittedAuthorities;
		optionsBlock: [self db authorities];
		label: 'Bearbeitbar auch für';
		yourself
]

{ #category : #testing }
TMEDProtected >> isPublic [
	^ self permissionType = #public
]

{ #category : #'as yet unclassified' }
TMEDProtected >> owner [
	self subclassResponsibility
]

{ #category : #accessing }
TMEDProtected >> permissionType [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
TMEDProtected >> permitReadFor: anAuthority [
	self readPermittedAuthorities add: anAuthority
]

{ #category : #'as yet unclassified' }
TMEDProtected >> permitWriteFor: anAuthority [
	self writePermittedAuthorities add: anAuthority
]

{ #category : #'as yet unclassified' }
TMEDProtected >> readPermittedAuthorities [
	^ #()
]

{ #category : #'as yet unclassified' }
TMEDProtected >> writePermittedAuthorities [
	^ #()
]
