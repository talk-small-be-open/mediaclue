Extension { #name : #WEBMailer }

{ #category : #'*Webbase-Ldap' }
WEBMailer >> sendLdapReportAboutUnsureNewUsers: aUsersCollection [
	| to body subject |
	to := {self globalConfiguration sysAdminEmailAddress}.

	subject := self subjectPrefix, ' Automatischer LDAP-Abgleich'.
	body := String streamContents: [:s |
		s << 'AUTOMATISCHER LDAP BENUTZER ABGLEICH'.
		s crlf; crlf.
		s << 'Die folgenden Personen wurden neu aufgrund ihrer Namensähnlichkeit mit dem LDAP verbunden, da keine ID vorhanden war. Bitte einzeln prüfen, da dies keine eindeutige Methode ist.'.
		s crlf; crlf.
		aUsersCollection do: [:each |
			s crlf.
			s << each displayName.
			s << ' LDAP-UID: '.
			s << each ldapUid
		].
		s crlf; crlf; nextPutAll: self defaultSignature].

	self sendMailTo: to subject: subject body: body
]
