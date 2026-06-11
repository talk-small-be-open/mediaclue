Class {
	#name : #MEDUserGroup,
	#superclass : #MEDModelObject,
	#traits : 'TMEDAuthority',
	#classTraits : 'TMEDAuthority classTrait',
	#instVars : [
		'title',
		'users',
		'canUpload',
		'uid'
	],
	#category : #'Mediaclue-Models'
}

{ #category : #testing }
MEDUserGroup class >> isVoyageRoot [
	^true
]

{ #category : #adding }
MEDUserGroup >> addUser: aUser [
	users add: aUser
]

{ #category : #accessing }
MEDUserGroup >> canUpload [
	^ canUpload = true
]

{ #category : #accessing }
MEDUserGroup >> canUpload: anObject [
	canUpload := anObject
]

{ #category : #'as yet unclassified' }
MEDUserGroup >> containsUser: aUser [
	^ self isMember: aUser
]

{ #category : #'submorphs-add/remove' }
MEDUserGroup >> delete [
	self remove
]

{ #category : #magritte }
MEDUserGroup >> descriptionCanUpload [
	<magritteDescription>
	^ MABooleanDescription new
		accessor: #canUpload;
		label: 'Kann hochladen';
		priority: 30;
		yourself 
]

{ #category : #magritte }
MEDUserGroup >> descriptionTitle [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #title;
		label: 'Titel';
		beRequired;
		priority: 10;
		yourself
]

{ #category : #magritte }
MEDUserGroup >> descriptionUid [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #uid;
		label: 'uid';
		priority: 50;
		yourself
]

{ #category : #magritte }
MEDUserGroup >> descriptionUsers [
	<magritteDescription>
	^ MEDMaMultipleOptionDescription new
		accessor: #users;
		label: 'Users';
		optionsBlock: [ self db users sortedBySortKey ];
		priority: 20;
		yourself
]

{ #category : #magritte }
MEDUserGroup >> descriptionUsersSorted [
	<magritteDescription>
	^ MEDMaMultipleOptionDescription new
		accessor: #usersSorted;
		label: 'Users, alphabetisch';
"		optionsBlock: [ self db users sortedBySortKey ];"
		priority: 20;
		beReadonly;
		yourself
]

{ #category : #accessing }
MEDUserGroup >> displayName [
	^ self title
]

{ #category : #initialization }
MEDUserGroup >> initialize [
	super initialize.
	users := OrderedCollection new
]

{ #category : #testing }
MEDUserGroup >> isMember: aUser [
	^ users includes: aUser
]

{ #category : #adding }
MEDUserGroup >> removeUser: aUser [
	users removeIfPresent: aUser
]

{ #category : #accessing }
MEDUserGroup >> title [
	^ title
]

{ #category : #accessing }
MEDUserGroup >> title: anObject [
	title := anObject
]

{ #category : #accessing }
MEDUserGroup >> uid [
	^ uid
]

{ #category : #accessing }
MEDUserGroup >> uid: anObject [
	uid := anObject
]

{ #category : #accessing }
MEDUserGroup >> users [
	^ users
]

{ #category : #accessing }
MEDUserGroup >> users: aCollection [
	users removeAll.
	users addAll: aCollection
]

{ #category : #'as yet unclassified' }
MEDUserGroup >> usersCount [
	^ users size
]

{ #category : #accessing }
MEDUserGroup >> usersSorted [
	^ users sortedBySortKey
]

{ #category : #accessing }
MEDUserGroup >> usersSorted: aCollection [
	"Convenience, Magritte accessor"
	^ self users: aCollection
]
