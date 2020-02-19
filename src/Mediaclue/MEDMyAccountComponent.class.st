Class {
	#name : #MEDMyAccountComponent,
	#superclass : #MEDComponent,
	#category : #'Mediaclue-View'
}

{ #category : #rendering }
MEDMyAccountComponent >> renderContentOn: html [
	html pageHeader: 'Mein Konto'.
	html pageBody: [
		html pageSubheader: 'Meine Mitgliedschaften'.
		html paragraph: [
			self currentUser userGroups do: [ :each |
				html text: 'Gruppe '.
				html text: each displayName ] ] ]
]
