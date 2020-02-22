Class {
	#name : #WEBLdapUserMatchWizard,
	#superclass : #WEBComponent,
	#instVars : [
		'users',
		'usersData',
		'peopleWithoutUser',
		'searchByName',
		'unsureUsers',
		'connection',
		'editUserBlock',
		'saveUserBlock',
		'addUsersBlock'
	],
	#category : #'Webbase-Ldap'
}

{ #category : #actions }
WEBLdapUserMatchWizard >> addAllUsers [
	self users: self db users

]

{ #category : #actions }
WEBLdapUserMatchWizard >> addUsers [
	| usersToAdd |
	usersToAdd := addUsersBlock value.
	self addUsers: usersToAdd

]

{ #category : #actions }
WEBLdapUserMatchWizard >> addUsers: aCollection [
	self users: (users copyWithAll: aCollection)
]

{ #category : #actions }
WEBLdapUserMatchWizard >> addUsersWithLdap [
	| usersWithLdap |
	usersWithLdap := self db users select: [:each | each ldapUid notBlank].
	self users: usersWithLdap
]

{ #category : #actions }
WEBLdapUserMatchWizard >> addUsersWithoutEmail [
	| incompleteUsers |
	incompleteUsers := self db users select: [ :each | each email isBlank ].
	self users: incompleteUsers
]

{ #category : #actions }
WEBLdapUserMatchWizard >> addUsersWithoutLdap [
	| usersWithoutLdap |
	usersWithoutLdap := self db users select: [:each | each ldapUid isBlank].
	self users: usersWithoutLdap
]

{ #category : #'as yet unclassified' }
WEBLdapUserMatchWizard >> attribute: aSymbol forUser: aUser [
	^usersData at: aUser ifPresent: [:ud | ud at: aSymbol ifAbsent: ''] ifAbsent: ''
]

{ #category : #'non-ui' }
WEBLdapUserMatchWizard >> autoLinkWithLdap [
	"Ohne UI, für Task. Verbindet neue User ohne LDAP-UID automatisch"
	self clear.
	self beSearchByName. 
	self addUsersWithoutLdap.
	self removeDeactivatedUsers.
	self reduceUsersToMax: 500. "Just a random barrier, to prevent explosion"
	self searchLdapNoUi.
	self importLdapUidNoUi.
	
	"Die unsicheren Users müssen wir melden"
	self notifyAboutUnsureUsers.
]

{ #category : #'non-ui' }
WEBLdapUserMatchWizard >> autoUpdateUsersFromLdap [
	"Ohne UI, für Task. Updated/Deaktiviert Users"
	self clear.

	self addUsersWithLdap.
	self searchLdapNoUi.
	self importLdapDataNoUi.

]

{ #category : #'as yet unclassified' }
WEBLdapUserMatchWizard >> beNotSearchByName [
	searchByName := false
]

{ #category : #'as yet unclassified' }
WEBLdapUserMatchWizard >> beSearchByName [
	searchByName := true
]

{ #category : #actions }
WEBLdapUserMatchWizard >> blankUsersData [
	usersData := IdentityDictionary new.
	unsureUsers := OrderedCollection new.
]

{ #category : #actions }
WEBLdapUserMatchWizard >> clear [
	self users: OrderedCollection new.

]

{ #category : #actions }
WEBLdapUserMatchWizard >> clearUsersData [
	usersData := nil.
	unsureUsers := nil.
]

{ #category : #actions }
WEBLdapUserMatchWizard >> editUser: aUser [
	editUserBlock value: aUser
]

{ #category : #'as yet unclassified' }
WEBLdapUserMatchWizard >> emailForUser: aUser [
	^self attribute: #email forUser: aUser
]

{ #category : #'as yet unclassified' }
WEBLdapUserMatchWizard >> fuzzyLdapSearchUser: aUser [
	| result |
	
	"- Probieren mit direkt angegebener UID"
	aUser ldapCustomUid ifNotBlank: [ :id |
		result := self searchByCustomUid: id.
		result ifNotNil: [ ^ result ] ].

	"- Probieren mit direkt angegebenem ldapUid (typischerweise = Username)"
	aUser ldapUid ifNotBlank: [ :uid |
		result := self searchByUid: uid.
		result ifNotNil: [ ^ result ] ].

	"- Probieren mit Email"
	aUser email ifNotBlank: [ :email |
		result := self searchByEmail: email.
		result ifNotNil: [ ^ result ] ].

	"- Probieren mit cn Namenssuche"
	searchByName ifTrue: [
		result := self searchByFirstName: aUser firstName lastName: aUser lastName.
		result ifNotEmpty: [
			unsureUsers add: aUser.
			^result first ] ].

	^nil
]

{ #category : #'as yet unclassified' }
WEBLdapUserMatchWizard >> handleInitialImportUser: eachUser [
	"Bei der Erstzuweisung zu LDAP aktivieren wir einen allfällig deaktivierten User"
	eachUser disabled: false.

]

{ #category : #testing }
WEBLdapUserMatchWizard >> hasDataForUser: aUser [
	usersData ifNil: [ ^ false ].

	^usersData includesKey: aUser
]

{ #category : #testing }
WEBLdapUserMatchWizard >> hasLdapData [
	^usersData notNil
]

{ #category : #obsolete }
WEBLdapUserMatchWizard >> idStringForUser: aUser [
	^self attribute: #idString forUser: aUser
]

{ #category : #actions }
WEBLdapUserMatchWizard >> importAllLdapData [
	self importLdapDataNoUi.
	self importLdapUidNoUi.
	self flashMessage: 'Daten aus LDAP gespeichert'
]

{ #category : #actions }
WEBLdapUserMatchWizard >> importLdapData [
	self importLdapDataNoUi.
	self flashMessage: 'Daten aus LDAP gespeichert'
]

{ #category : #'non-ui' }
WEBLdapUserMatchWizard >> importLdapDataNoUi [
	"Übernimmt für jeden User Daten aus dem LDAP"

	users do: [:eachUser |
		(self hasDataForUser: eachUser)
			ifTrue: [
				"Attribute nicht überschreiben!"
				
"Username ist nur noch für lokales Login ein Thema				(self usernameForUser: eachUser) ifNotBlank: [:value |
					eachUser username ifBlank: [eachUser username: value]]."
				(self emailForUser: eachUser) ifNotBlank: [ :value |
					eachUser email ifBlank: [eachUser email: value] ].
				
				self saveUser: eachUser.
			]
			ifFalse: [
				"Keine Daten im LDAP gefunden, also deaktivieren wir den User,
				sofern er kein lokaler User ist"
				(self willBeDeactivated: eachUser) ifTrue: [
					eachUser disabled: true.
					self saveUser: eachUser.
				] 
			]
	]
]

{ #category : #'non-ui' }
WEBLdapUserMatchWizard >> importLdapUidNoUi [
	| initialUsers |
	initialUsers := OrderedCollection new.
	
	"Übernimmt für jeden User die eindeutige LDAP-ID aus dem LDAP"
	users do: [:eachUser |
		(self hasDataForUser: eachUser)
			ifTrue: [
				(self ldapUidForUser: eachUser) ifNotBlank: [:value |
					eachUser ldapUid ifBlank: [
						initialUsers add: eachUser.
					].

					eachUser ldapUid: value.
				].

				self saveUser: eachUser.

			]
			ifFalse: [
				"Keine Daten im LDAP gefunden, also deaktivieren wir den User, sofern er kein lokaler User ist"
				(self willBeDeactivated: eachUser) ifTrue: [
					eachUser disabled: true.
					self saveUser: eachUser.
				]
			]
	].

	"Die Erstlinge behandeln"
	initialUsers do: [ :each |
		self handleInitialImportUser: each]
]

{ #category : #initialization }
WEBLdapUserMatchWizard >> initialize [
	super initialize.
	self beSearchByName.
	self clear.
	self addForm removeButtons.
	self beRestoringScrollPosition
]

{ #category : #'as yet unclassified' }
WEBLdapUserMatchWizard >> ldapCustomUidForUser: aUser [
	^self attribute: #ldapCustomUid forUser: aUser
]

{ #category : #'as yet unclassified' }
WEBLdapUserMatchWizard >> ldapStandardAttributes [
	^{self globalConfiguration ldapUidField. 'mail'. self globalConfiguration ldapCustomUidField} copyWithoutBlanks
]

{ #category : #'as yet unclassified' }
WEBLdapUserMatchWizard >> ldapUidForUser: aUser [
	^self attribute: #ldapUid forUser: aUser
]

{ #category : #'as yet unclassified' }
WEBLdapUserMatchWizard >> notifyAboutUnsureUsers [
	unsureUsers ifNotBlank: [
		self mailer sendLdapReportAboutUnsureNewUsers: unsureUsers
	]
]

{ #category : #actions }
WEBLdapUserMatchWizard >> onAddUsers: aBlock [
	addUsersBlock := aBlock
]

{ #category : #actions }
WEBLdapUserMatchWizard >> onEditUser: aBlock [
	editUserBlock := aBlock
]

{ #category : #actions }
WEBLdapUserMatchWizard >> onSaveUser: aBlock [
	saveUserBlock := aBlock
]

{ #category : #'as yet unclassified' }
WEBLdapUserMatchWizard >> reduceUsersToMax: anInteger [
	self users: (users firstAtMost: anInteger)
]

{ #category : #'as yet unclassified' }
WEBLdapUserMatchWizard >> removeDeactivatedUsers [
	self users: (users select: [ :each | each isEnabled ])
]

{ #category : #actions }
WEBLdapUserMatchWizard >> removeUser: aUser [
	users remove: aUser.
	usersData ifNotNil: [
		usersData removeKey: aUser ifAbsent: [] ]
]

{ #category : #rendering }
WEBLdapUserMatchWizard >> renderButtonBarOn: html [
	html heading level4; with: '1. Personen für den LDAP-Abgleich wählen:'.
	html buttonToolbar: [
		html buttonGroup: [
			html anchorButton
				callback: [self addAllUsers];
				with: 'Alle Personen'.
			addUsersBlock ifNotNil: [
				html anchorButton
					callback: [self addUsers];
					with: 'Personen ...'.
			].
			html anchorButton
				callback: [self addUsersWithoutEmail];
				with: 'Personen ohne Email'.
			html anchorButton
				callback: [self addUsersWithoutLdap];
				with: 'Personen ohne LDAP'.
			html anchorButton
				callback: [self addUsersWithLdap];
				with: 'Personen mit LDAP'.
			html anchorButton
				callback: [self clear];
				with: 'Liste leeren']].
	html heading level4;
		class: 'text-muted' if: users isEmpty;
		with: '2. Abfrage an LDAP-Server:'.
	html buttonToolbar: [
		html buttonGroup: [
			html submitButton
				disabled: users isEmpty;
				callback: [self searchLdap];
				with: 'Mit LDAP vergleichen'.
			html submitButton
				disabled: self hasLdapData not;
				callback: [self importAllLdapData];
				with: 'LDAP-Werte übernehmen'
			]].
]

{ #category : #rendering }
WEBLdapUserMatchWizard >> renderCompareAttribute: aSymbol user: aUser on: html [
	| fromLdap fromHere |
	
	self hasLdapData ifFalse: [ ^ self ].
	
	fromLdap := (self attribute: aSymbol forUser: aUser).
	fromHere := aUser perform: aSymbol.
	
	fromLdap
		ifBlank: [html span: '---']
		ifNotBlank: [
			fromHere
				ifBlank: [html labelWarning: fromLdap]
				ifNotBlank: [
					(fromLdap = fromHere)
						ifTrue: [
							html labelSuccess: fromLdap; space.
							html iconOk]
						ifFalse: [
							html labelWarning: fromLdap.
							html space.
							html text: ('alt: ', fromHere)]
				]]
]

{ #category : #rendering }
WEBLdapUserMatchWizard >> renderContentOn: html [
	html heading level1; with: 'LDAP Personen Abgleich'.

"	html paragraph: 'Erklärung: Wählen Sie zuerst die Personen, welche Sie mit dem LDAP abgleichen wollen. '."
	
	self renderButtonBarOn: html.

	html heading level3; with: 'Personen Vergleichstabelle'.

	users
		ifBlank: [ html paragraph: 'Keine Personen' ]
		ifNotBlank: [ self renderUsersOn: html ].

]

{ #category : #rendering }
WEBLdapUserMatchWizard >> renderTableBodyOn: html [
	html tableBody: [
		users
			ifBlank: [
				html tableRow: [
					html tableData colSpan: 5; with: 'Keine Personen']]
			ifNotBlank: [
				users do: [:eachUser |
					html tableRow: [
						html tableData: [
							html checkbox
								class: 'selectedUser';
								onTrue: [] onFalse: [self removeUser: eachUser];
								value: true.
							].
						html tableData: [
							html text: eachUser displayName.
							eachUser isDisabled
								ifTrue: [html space; labelDanger: 'DEAKTIVIERT']
								ifFalse: [
									(self willBeDeactivated: eachUser) ifTrue: [
										html space; labelWarning: 'WIRD DEAKTIVIERT']]
						].
"							html tableData: [self renderCompareAttribute: #idString user: eachUser on: html]."
						html tableData: [self renderCompareAttribute: #ldapUid user: eachUser on: html].
						html tableData: [self renderCompareAttribute: #email user: eachUser on: html].
						html tableData: [self renderCompareAttribute: #ldapCustomUid user: eachUser on: html].
						html tableData: [
							editUserBlock ifNotNil: [
								html anchor
									callback: [self editUser: eachUser];
									with: 'User bearbeiten ...'
								]
						]
						]]]]
]

{ #category : #rendering }
WEBLdapUserMatchWizard >> renderUsersOn: html [
	html paragraph: [
		html text: users size asString.
		html text: ' Personen'.
		
		#(100 500 1000) do: [ :each |
			users size > each ifTrue: [
				html space: 3.
				html anchor
					callback: [ self reduceUsersToMax: each ];
					with: 'Reduziere auf ', each asString.
			]
		]
	].
	html buttonGroup: [
		html submitButton
			callback: [];
			with: 'Nicht gewählte entfernen'.
		html anchorButton
			callback: [ self removeDeactivatedUsers ];
			with: 'Deaktivierte entfernen'.
	].

	html paragraph class: 'pull-right'; with: [
		html text: 'Legende: '.
		html labelSuccess: 'Werte stimmen überein'; space.
		html labelWarning: 'Neuer Wert'; space; space.
		html text: '*= speichert nur falls leer'
"			html bsLabelInfo: 'Alter Wert'; space."
		].

	html table class: 'table'; with: [
		html tableHead: [
			html tableRow: [
				html tableHeading: [
					html checkbox
						onClick: (
							((html jQuery this closest: 'form') find: ':checkbox.selectedUser')
								propertyAt: 'checked' put: (html jQuery this propertyAt: 'checked'));
						value: true.
				].
				html tableHeading: 'Person'.
	"			html tableHeading: 'ID'."
				html tableHeading: 'LDAP-ID*'.
				html tableHeading: 'Email*'.
				html tableHeading: '(2. LDAP-ID)'.
				html tableHeading.
			].
			html tableRow: [
				html tableHeading.
				html tableHeading.
				html tableHeading: self globalConfiguration ldapUidField.
				html tableHeading.
				html tableHeading: self globalConfiguration ldapCustomUidField.
				html tableHeading.
			]
		].
		self renderTableBodyOn: html ]

]

{ #category : #actions }
WEBLdapUserMatchWizard >> saveUser: aUser [
	saveUserBlock ifNil: [ ^self ].
	saveUserBlock value: aUser
]

{ #category : #'as yet unclassified' }
WEBLdapUserMatchWizard >> searchByCustomUid: aString [
	| request result |

	request := connection
		newSearch: (self globalConfiguration ldapBaseDn)
		scope: (LDAPConnection wholeSubtree)
		deref: (LDAPConnection derefNever)
		filter: (LDAPFilter with: self globalConfiguration ldapCustomUidField equalTo: aString)
		attrs: self ldapStandardAttributes
		wantAttrsOnly: false.
	
	result := request result at: 1 ifAbsent: [^nil].
	result isReference ifTrue: [ ^nil ].
	
	^result
]

{ #category : #'as yet unclassified' }
WEBLdapUserMatchWizard >> searchByEmail: aString [
	| request result |

	request := connection
		newSearch: (self globalConfiguration ldapBaseDn)
		scope: (LDAPConnection wholeSubtree)
		deref: (LDAPConnection derefNever)
		filter: (LDAPFilter with: 'mail' equalTo: aString)
		attrs: self ldapStandardAttributes
		wantAttrsOnly: false.
	
	result := request result at: 1 ifAbsent: [^nil].
	result isReference ifTrue: [ ^nil ].
	
	^result
]

{ #category : #'as yet unclassified' }
WEBLdapUserMatchWizard >> searchByFirstName: aFirstName lastName: aLastName [
	| request result totalFilter filters first nothingFound |

	nothingFound := [ ^ #() ].
	
	(aFirstName isBlank and: [ aLastName isBlank ]) ifTrue: nothingFound.

	filters := OrderedCollection new.

	aFirstName ifNotBlank: [filters add: (LDAPFilter containing: aFirstName atAnywhereOf: 'givenName')].
	aLastName ifNotBlank: [filters add: (LDAPFilter containing: aLastName atAnywhereOf: 'sn')].
	
	totalFilter := (filters size > 1)
		ifTrue: [LDAPFilter andOf: filters]
		ifFalse: [filters first].

	request := connection
		newSearch: (self globalConfiguration ldapBaseDn)
		scope: (LDAPConnection wholeSubtree)
		deref: (LDAPConnection derefNever)
"		filter: (LDAPFilter andOf: {LDAPFilter with: 'givenName' equalTo: aFirstName. LDAPFilter with: 'sn' equalTo: aLastName})"
		filter: totalFilter
		attrs: self ldapStandardAttributes
		wantAttrsOnly: false.

	result := request result.
	first := result at: 1 ifAbsent: nothingFound.
	first isReference ifTrue: nothingFound.
	
	^result
]

{ #category : #'as yet unclassified' }
WEBLdapUserMatchWizard >> searchByUid: aString [
	| request result |

	request := connection
		newSearch: (self globalConfiguration ldapBaseDn)
		scope: (LDAPConnection wholeSubtree)
		deref: (LDAPConnection derefNever)
		filter: (LDAPFilter with: self globalConfiguration ldapUidField equalTo: aString)
		attrs: self ldapStandardAttributes
		wantAttrsOnly: false.
	
	result := request result at: 1 ifAbsent: [^nil].
	result isReference ifTrue: [ ^nil ].
	
	^result
]

{ #category : #actions }
WEBLdapUserMatchWizard >> searchLdap [

	[self searchLdapNoUi] on: Error do: [:ex | self flashErrorMessage: 'LDAP-Fehler bei Abfrage: ', ex description]
]

{ #category : #'non-ui' }
WEBLdapUserMatchWizard >> searchLdapNoUi [

	self clearUsersData.

	connection := LDAPConnection to: self globalConfiguration ldapMainServer.

	self globalConfiguration ldapUser ifNotBlank: [ :user |
		connection bindAs: user credentials: self globalConfiguration ldapPassword].

	[
		self blankUsersData.

		users do: [:eachUser |
			| result userData |
			
			result := self fuzzyLdapSearchUser: eachUser.
			
			result ifNotNil: [
				userData := {
					#ldapUid -> (result attrAt: self globalConfiguration ldapUidField).
					#email -> (result attrAt: 'mail').
				} asDictionary.
				
				self globalConfiguration ldapCustomUidField ifNotBlank: [ :field |
					userData at: #ldapCustomUid put: (result attrAt: field)
				].

				usersData at: eachUser put: userData]
		].
	]
	ensure: [connection disconnect]
]

{ #category : #'as yet unclassified' }
WEBLdapUserMatchWizard >> users: aCollection [
	users := aCollection sortedBySortKey asOrderedCollection.
	
	"OPTIMIZE: Grenze von 2000 ist willkürlich, einfach dass es nicht explodiert"
"	users := (users shuffle firstAtMost: 2000) sortedBySortKey."
	
	self clearUsersData
]

{ #category : #testing }
WEBLdapUserMatchWizard >> willBeDeactivated: aUser [
	^ self db identityProvider isPrimaryUserSource and: [
		self hasLdapData and: [
			(self hasDataForUser: aUser) not]]

]
