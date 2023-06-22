Class {
	#name : #MEDMyAccountComponent,
	#superclass : #MEDComponent,
	#instVars : [
		'user'
	],
	#category : #'Mediaclue-View'
}

{ #category : #'as yet unclassified' }
MEDMyAccountComponent >> editFirstname [
	| new |
	new := self request: 'Vorname?' default: user firstName.
	
	new ifNotBlank: [
		user firstName: new.
		user save.
	]
]

{ #category : #'as yet unclassified' }
MEDMyAccountComponent >> editLastname [
	| new |
	new := self request: 'Nachname?' default: user lastName.
	
	new ifNotBlank: [
		user lastName: new.
		user save.
	]
]

{ #category : #initialization }
MEDMyAccountComponent >> initialize [
	super initialize.
	user := self currentUser.
]

{ #category : #rendering }
MEDMyAccountComponent >> renderContentOn: html [
	html pageHeader: 'Mein Konto'.
	html pageBody: [
		user isAdmin ifTrue: [ html labelWarning: 'Administrator' ].

		html paragraph: [
			html text: 'Vorname: '. 
			html anchor
				callback: [ self editFirstname ];
				with: [
					html text: user firstName.
					html space.
					html iconEdit.
				].
		].
		html paragraph: [
			html text: 'Nachname: '. 
			html anchor
				callback: [ self editLastname ];
				with: [
					html text: user lastName.
					html space.
					html iconEdit.
				].
		].
		html paragraph: 'Email: ', user email.
		user ldapUid ifNotBlank: [ :l |
			html paragraph: 'LDAP: ', l ].
		html pageSubheader: 'Meine Gruppen-Mitgliedschaften'.
		html paragraph: [
			user userGroups do: [ :each |
				html div: [
					html text: 'Gruppe '.
					html text: each displayName ] ] ] ]
]
