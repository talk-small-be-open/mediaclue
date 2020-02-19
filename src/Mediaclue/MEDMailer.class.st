Class {
	#name : #MEDMailer,
	#superclass : #WEBMailer,
	#category : #'Mediaclue-Misc'
}

{ #category : #'as yet unclassified' }
MEDMailer >> dearUser: aUser [
	^ 'Geschätzte(r) ', aUser fullName
]

{ #category : #protected }
MEDMailer >> defaultSignature [
	^'--
Mediendatenbank ', self globalConfiguration organizationName
]

{ #category : #'as yet unclassified' }
MEDMailer >> sendMisuseReport: aMedia from: aName email: anEmail note: aNoteString [
	| to body subject owner |
	owner := aMedia owner.
	to := Array with: owner email.

	subject := self subjectPrefix, ' Antrag auf Löschung!'.
	body := String streamContents: [:stream |
		stream << (self dearUser: owner).
		stream crlf; crlf.
		stream << 'Für eines Ihrer Medien wurde ein Löschantrag gestellt.
Bitte beantworten Sie diese Email (geht an den Antragssteller)
und löschen Sie das Medium, sofern Sie den Antrag gutheissen können.
'.
		stream crlf; crlf.
		stream << 'MEDIUM'.
		stream crlf.
		stream << aMedia displayName.

		stream crlf; crlf.
		stream << 'ANTRAGSTELLER'.
		stream crlf.
		stream << aName.
		stream crlf.
		stream << anEmail.
	
		stream crlf; crlf.
		stream << 'ANTRAG'.
		stream crlf.
		stream << aNoteString.
		stream crlf; crlf.
		stream crlf; nextPutAll: self defaultSignature].

	^ self sendMailTo: to cc: { anEmail } bcc: nil subject: subject body: body replyTo: anEmail sender: nil

]

{ #category : #'as yet unclassified' }
MEDMailer >> subjectPrefix [
	^ '[', self globalConfiguration organizationShortName, ' MDB]'
]
