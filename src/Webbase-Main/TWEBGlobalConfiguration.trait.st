Trait {
	#name : #TWEBGlobalConfiguration,
	#category : #'Webbase-Main-Traits'
}

{ #category : #configs }
TWEBGlobalConfiguration >> appDomain [
	^self at: #appDomain ifNil: [ 'webappdomain' ]
]

{ #category : #configs }
TWEBGlobalConfiguration >> appDomain: aValue [
	self at: #appDomain put: aValue
]

{ #category : #actions }
TWEBGlobalConfiguration >> apply [
	"Make the settings real. Applications can do stuff here, if any"
]

{ #category : #configs }
TWEBGlobalConfiguration >> emailDomain [
	^self at: #emailDomain ifBlank: [self webDomain]
]

{ #category : #configs }
TWEBGlobalConfiguration >> emailDomain: aValue [
	self at: #emailDomain put: aValue
]

{ #category : #configs }
TWEBGlobalConfiguration >> identityProviderType [
	^self at: #identityProviderType ifBlank: ['local']
]

{ #category : #configs }
TWEBGlobalConfiguration >> identityProviderType: aValue [
	self at: #identityProviderType put: aValue
]

{ #category : #accessing }
TWEBGlobalConfiguration >> localValueAt: aKey ifAbsent: aBlock [
	"Das führt dazu, dass wir in der global-configuration alle Werte sammeln, die
	angefordert wurden. So können wir dann im UI die defaults setzen"
	^super localValueAt: aKey ifAbsent: [
		self at: aKey put: nil.
		aBlock value]
]

{ #category : #configs }
TWEBGlobalConfiguration >> loggingEmailAddress [
	^self at: #loggingEmailAddress
]

{ #category : #configs }
TWEBGlobalConfiguration >> loggingEmailAddress: aValue [
	self at: #loggingEmailAddress put: aValue
]

{ #category : #helper }
TWEBGlobalConfiguration >> parent [
	^nil
]

{ #category : #configs }
TWEBGlobalConfiguration >> smtpPassword [
	^self at: #smtpPassword
]

{ #category : #configs }
TWEBGlobalConfiguration >> smtpPassword: aValue [
	| sanitized |
	"Falls leer müssen wir nil speichern wegen seaside Mailer"
	sanitized := aValue ifBlank: [nil].
	self at: #smtpPassword put: sanitized
]

{ #category : #configs }
TWEBGlobalConfiguration >> smtpServer [
	^self at: #smtpServer
]

{ #category : #configs }
TWEBGlobalConfiguration >> smtpServer: aValue [
	self at: #smtpServer put: aValue
]

{ #category : #configs }
TWEBGlobalConfiguration >> smtpUsername [
	^self at: #smtpUsername
]

{ #category : #configs }
TWEBGlobalConfiguration >> smtpUsername: aValue [
	| sanitized |
	"Falls leer müssen wir nil speichern wegen seaside Mailer"
	sanitized := aValue ifBlank: [nil].
	self at: #smtpUsername put: sanitized
]

{ #category : #configs }
TWEBGlobalConfiguration >> sysAdminEmailAddress [
	^self at: #sysAdminEmailAddress
]

{ #category : #configs }
TWEBGlobalConfiguration >> sysAdminEmailAddress: aValue [
	self at: #sysAdminEmailAddress put: aValue
]

{ #category : #configs }
TWEBGlobalConfiguration >> webDomain [
	^self appDomain
]

{ #category : #configs }
TWEBGlobalConfiguration >> webDomainLocal [
	^self at: #webDomainLocal ifBlank: [self webDomain]
]

{ #category : #configs }
TWEBGlobalConfiguration >> webDomainLocal: aString [
	self at: #webDomainLocal put: aString
]

{ #category : #configs }
TWEBGlobalConfiguration >> webRootPath [
	^self at: #webRootPath
]

{ #category : #configs }
TWEBGlobalConfiguration >> webRootPath: aValue [
	self at: #webRootPath put: aValue
]

{ #category : #configs }
TWEBGlobalConfiguration >> webUrl [
	^'https://', self webDomain
]

{ #category : #configs }
TWEBGlobalConfiguration >> webUrlLocal [
	^'http://', self webDomainLocal
]
