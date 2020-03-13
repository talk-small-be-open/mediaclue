Class {
	#name : #MEDMyAccountComponent,
	#superclass : #MEDComponent,
	#category : #'Mediaclue-View'
}

{ #category : #rendering }
MEDMyAccountComponent >> renderContentOn: html [
	html pageHeader: 'Mein Konto'.
	html pageBody: [
		html paragraph: [
			html text: 'Name: ', self currentUser displayName.
			html space.
			self currentUser isAdmin ifTrue: [ html labelWarning: 'Administrator' ].
		].
		html pageSubheader: 'Meine Gruppen-Mitgliedschaften'.
		html paragraph: [
			self currentUser userGroups do: [ :each |
				html div: [
					html text: 'Gruppe '.
					html text: each displayName ] ] ] ]
]
