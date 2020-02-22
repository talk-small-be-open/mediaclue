Class {
	#name : #WEBMailer,
	#superclass : #WEBObject,
	#instVars : [
		'enabled'
	],
	#category : #'Webbase-Main-Misc'
}

{ #category : #protected }
WEBMailer >> defaultSender [
	^WAEmailAddress address: self returnPath
]

{ #category : #protected }
WEBMailer >> defaultSignature [
	^'--
The Application
'
]

{ #category : #'as yet unclassified' }
WEBMailer >> enabled [
	^enabled
]

{ #category : #'as yet unclassified' }
WEBMailer >> enabled: aValue [
	enabled := aValue
]

{ #category : #helpers }
WEBMailer >> encodeForEmailHeader: aString [
	"Encodiert spezielle Zeichen für die Verwendung in Email-Headers"

	^WEBHelper asMimeEncodedWord: aString

	"^'=?utf-8?B?', aString base64Encoded, '?='"
	
"Fehler bei UTF8:	^RFC2047MimeConverter new encodeWord: aString"
	
	"Auch evt: iso-8859-1"

]

{ #category : #initialization }
WEBMailer >> initialize [

	super initialize.

	enabled := true
]

{ #category : #'as yet unclassified' }
WEBMailer >> returnPath [
	^ 'mediaclue@', self globalConfiguration emailDomain
]

{ #category : #delivery }
WEBMailer >> sendMailTo: aToCollection cc: aCcCollection bcc: aBccCollection subject: subject body: body replyTo: aReplyEmailString sender: aWAEmailAddress [
	| email to cc bcc sender fileName |
	
	self enabled ifFalse: [ ^ nil ].
	
	email := WAEmailMessage new
		headerAt: 'Return-path' put: self returnPath;
		headerAt: 'Content-Type' put: 'text/plain; charset=UTF-8';
		headerAt: 'Content-Transfer-Encoding' put: '8bit';
		yourself.
		
	
	"Allenfalls reale Empfänger verhindern"
"	self globalConfiguration disableRealEmailRecipients
		ifTrue: [
			clone instVarNamed: 'to' put: OrderedCollection new.
			clone instVarNamed: 'cc' put: OrderedCollection new.
			clone instVarNamed: 'bcc' put: OrderedCollection new.
			clone addTo: (WAEmailAddress address: 'andreas.brodbeck@mindclue.ch')]."

	sender := aWAEmailAddress ifNil: [ self defaultSender ].

	email
		subject: (self encodeForEmailHeader: subject);
		body: (WEBHelper toUtf8: body);
		from: sender.

	to := aToCollection asOrderedCollection copyWithoutBlanks.
	cc := aCcCollection asOrderedCollection copyWithoutBlanks.
	bcc := aBccCollection asOrderedCollection copyWithoutBlanks.
	
	"Spezialfall, alle Empfänger leer (durch Fehler!): Mail nicht erzeugen"
	((to isEmpty and: [cc isEmpty]) and: [bcc isEmpty]) ifTrue: [ ^ nil ].

"	isLogging ifTrue: [
		self logInfo: 'Email prepared to: ', (to joinUsing: ', ')]."
	
	to do: [:each | email addTo: (WAEmailAddress address: each)].
	cc do: [:each | email addCc: (WAEmailAddress address: each)].
	bcc do: [:each | email addBcc: (WAEmailAddress address: each)].

	"Allenfalls BCC hinzufügen, um Emailverkehr zu loggen"
	self globalConfiguration loggingEmailAddress ifNotBlank: [:string |
		email addBcc: (WAEmailAddress address: string)].

	aReplyEmailString isNil
"		ifTrue: [email headerAt: 'Reply-To' put: (self defaultSender greaseString)]"
		ifFalse: [email headerAt: 'Reply-To' put: aReplyEmailString].

	"Versendete Emails auf Server loggen"
	
	fileName := 'email_', (WEBHelper filenameDateAndTimeStringFor: DateAndTime now), '.log'.
	GRPlatform current write: (WEBHelper toUtf8: email plainMessage) toFile: fileName inFolder: WEBHelper appLogFolder pathString.

	self ifDevelopment: [
		Transcript show: 'Sending email:'; cr.
		Transcript show: email plainMessage ].
	
	self isProductionOrAlike ifTrue: [	
		email send ].
	
	^email
]

{ #category : #delivery }
WEBMailer >> sendMailTo: aToCollection subject: subject body:  body [
	^self sendMailTo: aToCollection cc: nil bcc: nil subject: subject body: body replyTo: nil sender: nil

]

{ #category : #mails }
WEBMailer >> sendTestEmailTo: aString [
	| to body subject |
	to := Array with: aString.

	subject := 'Web-App Email-Test'.
	body := String streamContents: [:stream |
		stream nextPutAll: 'TEST TEST TEST'.
		stream crlf; crlf.
		stream nextPutAll: '============================================='.
		stream crlf; crlf.
		stream crlf; nextPutAll: self defaultSignature].


	^self sendMailTo: to subject: subject body: body
]

{ #category : #'as yet unclassified' }
WEBMailer >> subjectPrefix [
	^ '[', self pi projectShortName, ']'
]
