Class {
	#name : #MEDUser,
	#superclass : #MEDModelObject,
	#traits : 'TWEBUser + TMEDAuthority',
	#classTraits : 'TWEBUser classTrait + TMEDAuthority classTrait',
	#instVars : [
		'firstName',
		'lastName',
		'email',
		'hashedPassword',
		'portfolio',
		'isAdmin',
		'ldapUid',
		'disabled'
	],
	#category : #'Mediaclue-Models'
}

{ #category : #accessing }
MEDUser class >> displayName [
	^ 'Benutzer'
]

{ #category : #testing }
MEDUser class >> isVoyageRoot [
	^true
]

{ #category : #'as yet unclassified' }
MEDUser >> beAdmin [
	isAdmin := true
]

{ #category : #testing }
MEDUser >> canUpload [
	^ (self userGroups anySatisfy: [ :each | each canUpload ])
	or: [ self isAdmin ]
]

{ #category : #'as yet unclassified' }
MEDUser >> containsUser: aUser [
	^ self == aUser
]

{ #category : #'submorphs-add/remove' }
MEDUser >> delete [
"	self removeMeInAllMediaSets."
	"TODO: remove all users media?"
	self remove.
"	self cleanupAfterDeletion."

]

{ #category : #magritte }
MEDUser >> descriptionDisabled [
	<magritteDescription>
	^ MABooleanDescription new
		accessor: #disabled;
		label: 'Deaktiviert';
		priority: 50;
		yourself
]

{ #category : #magritte }
MEDUser >> descriptionEmail [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #email;
		label: 'E-Mail';
		beRequired;
		priority: 30;
		yourself
]

{ #category : #magritte }
MEDUser >> descriptionFirstName [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #firstName;
		label: 'Vorname';
		beRequired;
		priority: 10;
		yourself
]

{ #category : #magritte }
MEDUser >> descriptionIsAdmin [
	<magritteDescription>
	^ MABooleanDescription new
		accessor: #isAdmin;
		label: 'Admin';
"		beRequired;"
		priority: 40;
		yourself
]

{ #category : #magritte }
MEDUser >> descriptionLastName [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #lastName;
		label: 'Nachname';
		beRequired;
		priority: 20;
		yourself
]

{ #category : #magritte }
MEDUser >> descriptionLdapUid [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #ldapUid;
		label: 'LDAP-UID';
		priority: 100;
		yourself
]

{ #category : #magritte }
MEDUser >> descriptionPassword [
	<magritteDescription>
	^ MAPasswordDescription new
		accessor: #password;
		label: 'Passwort';
		priority: 99;
		yourself
]

{ #category : #attributes }
MEDUser >> disabled [
	^ disabled = true
]

{ #category : #attributes }
MEDUser >> disabled: aBoolean [
	disabled := aBoolean
]

{ #category : #accessing }
MEDUser >> displayName [
	^self fullNameFormal
]

{ #category : #accessing }
MEDUser >> email [
	^ email
]

{ #category : #accessing }
MEDUser >> email: anObject [
	email := anObject
]

{ #category : #accessing }
MEDUser >> firstName [
	^ firstName
]

{ #category : #accessing }
MEDUser >> firstName: anObject [
	firstName := anObject
]

{ #category : #accessing }
MEDUser >> fullName [
	^(self firstName ifBlank: ['Petrosilius']), ' ', (self lastName ifBlank: [ 'Zwackelmann'])
]

{ #category : #accessing }
MEDUser >> fullNameFormal [
	^(self lastName ifBlank: [ 'Zwackelmann']), ' ', (self firstName ifBlank: ['Petrosilius'])
]

{ #category : #'as yet unclassified' }
MEDUser >> hashedPassword [
	^hashedPassword
]

{ #category : #'as yet unclassified' }
MEDUser >> hashedPassword: aValue [
	hashedPassword := aValue
]

{ #category : #'as yet unclassified' }
MEDUser >> ifAdmin: aBlock [
	^self isAdmin ifTrue: aBlock
]

{ #category : #initialization }
MEDUser >> initialize [
	super initialize.
	portfolio := MEDPortfolio user: self.
	isAdmin := false.
	disabled := false
]

{ #category : #accessing }
MEDUser >> isAdmin [
	^isAdmin = true
]

{ #category : #accessing }
MEDUser >> isAdmin: aValue [
	isAdmin := aValue
]

{ #category : #accessing }
MEDUser >> isAuthenticateAtLdap [
	^ ldapUid notBlank
]

{ #category : #accessing }
MEDUser >> lastName [
	^ lastName
]

{ #category : #accessing }
MEDUser >> lastName: anObject [
	lastName := anObject
]

{ #category : #accessing }
MEDUser >> ldapUid [
	^ ldapUid
]

{ #category : #accessing }
MEDUser >> ldapUid: aValue [
	ldapUid := aValue
]

{ #category : #accessing }
MEDUser >> password [
	"fake Methode. Nur für Magritte-compat"
	self hasPassword ifTrue: [ ^ '****************' ].
	^nil
]

{ #category : #accessing }
MEDUser >> portfolio [
	^portfolio
]

{ #category : #'as yet unclassified' }
MEDUser >> userGroups [
	^ self db findUserGroupsByUser: self 
]

{ #category : #accessing }
MEDUser >> username [
	^email
]
