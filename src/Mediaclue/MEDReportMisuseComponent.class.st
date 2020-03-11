Class {
	#name : #MEDReportMisuseComponent,
	#superclass : #MEDComponent,
	#instVars : [
		'media',
		'reporterName',
		'reporterEmail',
		'isSent',
		'reporterNote',
		'validationResult'
	],
	#category : #'Mediaclue-View'
}

{ #category : #attributes }
MEDReportMisuseComponent class >> media: aMedia [
	^self basicNew
		setMedia: aMedia;
		initialize;
		yourself
]

{ #category : #initialization }
MEDReportMisuseComponent >> initialize [
	super initialize.
	isSent := false.
	self isLoggedIn ifTrue: [
		reporterEmail := self currentUser email.
		reporterName := self currentUser fullName ].
	reporterNote := 'Ich beantrage die Löschung des Mediums mit Titel "', media title,'" (ID: ', media uuidString, ').'
]

{ #category : #accessing }
MEDReportMisuseComponent >> media [
	^ media
]

{ #category : #accessing }
MEDReportMisuseComponent >> media: anObject [
	media := anObject
]

{ #category : #rendering }
MEDReportMisuseComponent >> renderContentOn: html [
	"media owner ifNil: []"
	isSent
		ifFalse: [ self renderRequestOn: html ]
		ifTrue: [ self renderOkOn: html ].
]

{ #category : #rendering }
MEDReportMisuseComponent >> renderOkOn: html [
	html pageHeader: 'Löschung beantragt' body: [

		html paragraph: 'Ihr Löschantrag wurde gesendet. Sie erhalten per Email eine Kopie. Die Entscheidung Ihres Antrags obliegt dem Eigentümer. Die Mediendatenbank nimmt von selbst keine Löschung vor.'.
		
		html anchorButton
			callback: [ self close ];
			with: 'Schliessen']
]

{ #category : #rendering }
MEDReportMisuseComponent >> renderRequestOn: html [
	html pageHeader: 'Löschung beantragen' body: [
		html paragraph: [
			html text: 'Hiermit beantragen Sie, dass folgendes Medium gelöscht wird: '.
			html text: media displayName.
		].

		self renderValidationResultsOn: html.

		html form: [
			html pureControlGroup: [
				html label: 'Geht per Email an:'.
				html text: media owner fullName ].
			html pureControlGroup: [
				html label: 'Ihr Name:'.
				html textInput
					class: 'pure-input-1-2';
					on: #reporterName of: self ].
			html pureControlGroup: [
				html label: 'Ihre E-Mail:'.
				html textInput
					class: 'pure-input-1-2';
					on: #reporterEmail of: self ].
			html pureControlGroup: [
				html label: 'Antrag:'.
				html textArea
					class: 'pure-input-1-2';
					on: #reporterNote of: self ].
			html pureControls: [
				html submitButtonPrimary
					callback: [self reportIt];
					with: 'Löschantrag senden!']].

		html anchorButton
			callback: [ self close ];
			with: 'Abbrechen']
]

{ #category : #rendering }
MEDReportMisuseComponent >> renderValidationResultsOn: html [
	html render: validationResult
]

{ #category : #'as yet unclassified' }
MEDReportMisuseComponent >> reportIt [
	self validate.
	validationResult isValid ifTrue: [
		self ensureUserOrCaptchaThen: [
			self sendEmail ] ]
]

{ #category : #accessing }
MEDReportMisuseComponent >> reporterEmail [
	^ reporterEmail
]

{ #category : #accessing }
MEDReportMisuseComponent >> reporterEmail: anObject [
	reporterEmail := anObject
]

{ #category : #accessing }
MEDReportMisuseComponent >> reporterName [
	^ reporterName
]

{ #category : #accessing }
MEDReportMisuseComponent >> reporterName: anObject [
	reporterName := anObject
]

{ #category : #accessing }
MEDReportMisuseComponent >> reporterNote [
	^ reporterNote
]

{ #category : #accessing }
MEDReportMisuseComponent >> reporterNote: anObject [
	reporterNote := anObject
]

{ #category : #'as yet unclassified' }
MEDReportMisuseComponent >> sendEmail [
	self mailer sendMisuseReport: media from: reporterName email: reporterEmail note: reporterNote.
	isSent := true.
]

{ #category : #accessing }
MEDReportMisuseComponent >> setMedia: anObject [
	media := anObject
]

{ #category : #accessing }
MEDReportMisuseComponent >> validate [
	| validator |
	validator := MEDValidator new.
	validator object: self.
	validator validatePresence of: #reporterName.
	validator validatePresence of: #reporterEmail.
	validator validatePresence of: #reporterNote.

	validationResult := validator validationResult.
	
	
]
