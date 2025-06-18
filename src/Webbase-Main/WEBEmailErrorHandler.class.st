Class {
	#name : #WEBEmailErrorHandler,
	#superclass : #WAErrorHandler,
	#traits : 'TWEBGlobalHelpers',
	#classTraits : 'TWEBGlobalHelpers classTrait',
	#category : #'Webbase-Main-View'
}

{ #category : #'as yet unclassified' }
WEBEmailErrorHandler >> bodyFor: anError [
	^ WAStringEmailBody string: (String streamContents: [ :stream | 
		stream nextPutAll: 'Benutzer: '.
		stream nextPutAll: self session userLabel.
		stream crlf; crlf.
		stream nextPutAll: anError description.
		stream crlf; crlf.
		anError signalerContext errorReportOn: stream ]) lineLength: 80
]

{ #category : #private }
WEBEmailErrorHandler >> from [
	"ansers the WAEmailAddress instance used as a sender addresst"
	| domain |
	domain := self globalConfiguration emailDomain ifBlank: 'localhost'.
	^WAEmailAddress address: ('webapp.error@', domain)
]

{ #category : #actions }
WEBEmailErrorHandler >> handleDefault: anException [
	
	[
		self logError: ('Exception on Frontend. User ', self session userLabel, ' has seen error information: ', anException description).
		self sendFailFor: anException.
	] ifError: [:description |
		Transcript
			show: 'ERROR: Error while logging/emailing an exception! ';
			show: description;
			show: ' Original error was: ';
			show: anException description; 
			cr.].


	"Shows a HTML error message"
	self requestContext respond: [ :response |
		response
			internalError;
			contentType: WAMimeType textHtml;
			nextPutAll: (WAHtmlCanvas builder
				fullDocument: true;
				rootBlock: [ :root | self updateHtmlRoot: root forException: anException ];
				render: [ :html | self renderContentForException: anException on: html ]) ]
]

{ #category : #'as yet unclassified' }
WEBEmailErrorHandler >> renderContentForException: anException on: html [
	html div style: 'width:500px;margin:50px auto'; with: [
		html heading level1; with: 'Ups, ein Fehler!'.
		html paragraph: 'In der Applikation ist ein Fehler aufgetreten. Dies wurde bereits per E-Mail weitergemeldet.'.
		html paragraph: 'Verwenden Sie den Zurück-Knopf, um wieder zur Applikation zu gelangen.'.
		html paragraph style: ((anException isKindOf: WEBError) ifTrue: ['color:red'] ifFalse: ['color:silver']); with: [
			html text: 'Fehlermeldung:'.
			html break.
			html text: anException messageText].
		html break; break; break.
		html anchor
			url: '#';
			onClick: 'window.history.back();return false';
			with: 'Zurück zur Applikation ...'.

	]
]

{ #category : #private }
WEBEmailErrorHandler >> sendFailFor: anError [
	| message |
	message := WAEmailMessage
		from: self from
		to: self to
		subject: (self subjectFor: anError).
	message body: (self bodyFor: anError).
	message send
]

{ #category : #private }
WEBEmailErrorHandler >> subjectFor: anError [
	^ anError signalerContext printString
]

{ #category : #private }
WEBEmailErrorHandler >> to [
	"ansers the WAEmailAddress instance to which the error mail should be sent"

	^WAEmailAddress address: self globalConfiguration sysAdminEmailAddress
]

{ #category : #'as yet unclassified' }
WEBEmailErrorHandler >> updateHtmlRoot: anHtmlRoot forException: anException [
	anHtmlRoot title: 'Fehler in Applikation'.
	
	anHtmlRoot htmlAttributes
		at: 'lang' put: 'de'.
		
	anHtmlRoot meta
		charset: 'utf-8'.
		
	"Viewport"
	anHtmlRoot meta
		name: 'viewport';
		content: 'width=device-width, initial-scale=1, maximum-scale=1'.
]
