Trait {
	#name : #TWEBComponentHelpers,
	#traits : 'TWEBGlobalHelpers',
	#classTraits : 'TWEBGlobalHelpers classTrait',
	#category : #'Webbase-Main-Traits'
}

{ #category : #'helpers-ui' }
TWEBComponentHelpers classSide >> afterPasswordDo: aBlock [
	^self requestPassword ifTrue: aBlock
]

{ #category : #'as yet unclassified' }
TWEBComponentHelpers classSide >> currentUser [
	^self session user
]

{ #category : #'helpers-ui' }
TWEBComponentHelpers classSide >> requestPassword [
	^self window: 'Passwortabfrage' with: WEBPasswordComponent new
]

{ #category : #'seaside-missing' }
TWEBComponentHelpers classSide >> session [
	"Answer the current seaside session, instance of WASesssion or a subclass."
	
	^ self requestContext session
]

{ #category : #decorations }
TWEBComponentHelpers >> addBackButton [
	self addDecoration: WEBBackButtonDecoration new

]

{ #category : #decorations }
TWEBComponentHelpers >> addBackButton: aLabelKey [
	self addDecoration: ((WEBBackButtonDecoration new)
		label: aLabelKey;
		yourself)

]

{ #category : #decorations }
TWEBComponentHelpers >> addContainerDiv [
	| css classes |

	"Add a standard wrapping container div with the name of the component class"
	classes := OrderedCollection new
		add: self class;
		yourself.
		
	(self isKindOf: WEBComponent) ifTrue: [
		classes addAll: (self class allSuperclasses copyUpTo: WEBComponent).
	].
		
	css := (classes collect: [:each | each name asString]) joinUsing: ' '.

	^ self addContainerDiv: css

]

{ #category : #decorations }
TWEBComponentHelpers >> addContainerDiv: aCssClassString [
	"Add a standard wrapping container div"
	^ self addDecoration: ((WEBDivDecoration cssClass: (aCssClassString))
		beLocal;
		yourself)
]

{ #category : #decorations }
TWEBComponentHelpers >> addForm [
	self removeForm.
	self formDecoration: WEBFormDecoration new.
	self addDecoration: self formDecoration.
	^self formDecoration
]

{ #category : #decorations }
TWEBComponentHelpers >> addForm: aButtonsCollection [
	^self addForm
		buttons: aButtonsCollection;
		beDirtyChecked;
		yourself
]

{ #category : #enumerating }
TWEBComponentHelpers >> afterCaptchaDo: aBlock [
	^self requestCaptcha ifTrue: aBlock
]

{ #category : #decorations }
TWEBComponentHelpers >> beKeepaliveSession [
	self addDecoration: WEBKeepaliveSessionDecoration new

]

{ #category : #decorations }
TWEBComponentHelpers >> beRestoringScrollPosition [
	self addDecoration: WEBRestoreScrollPositionDecoration new

]

{ #category : #actions }
TWEBComponentHelpers >> cancel [
	"Standard implementation for the form decoration DAZFormDecoration to work out of the box"
	self answer: nil
]

{ #category : #'helpers-dialog' }
TWEBComponentHelpers >> chooseFrom: aCollection [
	^self chooseFrom: aCollection caption: 'Bitte wählen Sie einen Eintrag aus der Liste aus:' default: nil
]

{ #category : #'helpers-dialog' }
TWEBComponentHelpers >> chooseFrom: aCollection caption: aText [
	^self chooseFrom: aCollection caption: aText default: nil
]

{ #category : #'helpers-dialog' }
TWEBComponentHelpers >> chooseFrom: aCollection caption: aText default: anObject [
	^self chooseFrom: aCollection labels: nil caption: aText default: anObject
]

{ #category : #'helpers-dialog' }
TWEBComponentHelpers >> chooseFrom: aCollection labels: aLabelBlock caption: aText default: anObject [
	^self chooseFrom: aCollection labels: aLabelBlock caption: aText multi: false default: anObject
]

{ #category : #'helpers-dialog' }
TWEBComponentHelpers >> chooseFrom: aCollection labels: aLabelBlock caption: aText multi: aMultiBoolean default: anObject [
	| dialog |

	"Autochoose if no option"
	(aCollection isBlank) ifTrue: [
		^aMultiBoolean
			ifFalse: [nil]
			ifTrue: [aCollection copyEmpty]].

	"Autochoose if only one option"
	(aCollection size = 1) ifTrue: [
		^aMultiBoolean
			ifFalse: [aCollection anyOne]
			ifTrue: [aCollection copy]].

	dialog := (WEBChoiceDialog new
			messageText: aText;
			options: aCollection;
			selection: anObject;
			yourself).
	
	"TODO"
	aMultiBoolean ifTrue: [dialog beMultiselect].

	"Falls ein eigener Labeling-Block angegeben wurde, dann nehmen wir an, dass wir danach sortieren"
	aLabelBlock ifNotNil: [
		dialog 
			labelBlock: aLabelBlock;
			beLabelSorted].
			
	^self window: 'Auswahl' with: dialog
]

{ #category : #'helpers-dialog' }
TWEBComponentHelpers >> chooseMultipleFrom: aCollection caption: aText [
	^self chooseMultipleFrom: aCollection caption: aText default: nil
]

{ #category : #'helpers-dialog' }
TWEBComponentHelpers >> chooseMultipleFrom: aCollection caption: aText default: aDefaultCollection [
	^self chooseFrom: aCollection labels: nil caption: aText multi: true default: aDefaultCollection

]

{ #category : #actions }
TWEBComponentHelpers >> close [
	"Standard implementation for the form decoration DAZFormDecoration to work out of the box"
	self answer
]

{ #category : #'helpers-dialog' }
TWEBComponentHelpers >> confirm: aText [
	^self confirm: aText title: 'Bestätigung' buttonText: 'OK'
]

{ #category : #'helpers-dialog' }
TWEBComponentHelpers >> confirm: aText title: aTitleString buttonText: aButtonString [
	^self confirm: aText title: aTitleString buttonText: aButtonString cancelText: nil
]

{ #category : #'helpers-dialog' }
TWEBComponentHelpers >> confirm: aText title: aTitleString buttonText: aButtonString cancelText: aCancelString [
	| answerValue |
	answerValue := self window: aTitleString with: (WEBConfirmationComponent new
			confirmationText: aButtonString;
			cancelText: aCancelString;
			message: aText;
			yourself).

	^answerValue = true
]

{ #category : #'helpers-dialog' }
TWEBComponentHelpers >> confirmYesNo: aText [
	^self confirm: aText title: 'Bestätigung' buttonText: 'Ja' cancelText: 'Nein'
]

{ #category : #'helpers-dialog' }
TWEBComponentHelpers >> confirmYesNo: aText ifNo: aBlock [
	^(self confirmYesNo: aText) ifFalse: aBlock
]

{ #category : #'helpers-dialog' }
TWEBComponentHelpers >> confirmYesNo: aText ifYes: aBlock [
	^(self confirmYesNo: aText) ifTrue: aBlock
]

{ #category : #'helpers-dialog' }
TWEBComponentHelpers >> confirmYesNo: aText ifYes: aBlock ifNo: aNoBlock [
	^(self confirmYesNo: aText) ifTrue: aBlock ifFalse: aNoBlock
]

{ #category : #helpers }
TWEBComponentHelpers >> currentUser [
	^self session user
]

{ #category : #'as yet unclassified' }
TWEBComponentHelpers >> ensureUserOrCaptchaThen: aBlock [
	self isLoggedIn ifTrue: aBlock ifFalse: [ 
		self afterCaptchaDo: aBlock ]
]

{ #category : #'helpers-ui' }
TWEBComponentHelpers >> flashErrorMessage: aMessageString [
	^self session addFlashErrorMessage: aMessageString
]

{ #category : #'as yet unclassified' }
TWEBComponentHelpers >> flashMessage: aMessageString [
	^self session addFlashMessage: aMessageString
]

{ #category : #'as yet unclassified' }
TWEBComponentHelpers >> formDecoration [
	self shouldBeImplemented
]

{ #category : #'as yet unclassified' }
TWEBComponentHelpers >> formDecoration: aDecoration [
	self shouldBeImplemented
]

{ #category : #'helpers-dialog' }
TWEBComponentHelpers >> inform: aText [
	^self inform: aText title: 'Information'
]

{ #category : #'helpers-dialog' }
TWEBComponentHelpers >> inform: aText title: aTitleString [
	^ self window: aTitleString with: (WEBInformationComponent new
			message: aText;
			yourself)
]

{ #category : #testing }
TWEBComponentHelpers >> isLoggedIn [
	^self session isLoggedIn
]

{ #category : #'helpers-dialog' }
TWEBComponentHelpers >> largeWindow: aText with: aComponent [
	^self lightbox: aComponent title: aText showClose: false large: true
]

{ #category : #'helpers-dialog' }
TWEBComponentHelpers >> lightbox: aComponent [
	self lightbox: aComponent title: nil
]

{ #category : #'helpers-dialog' }
TWEBComponentHelpers >> lightbox: aComponent title: aTitleText [
	^self lightbox: aComponent title: aTitleText showClose: false
]

{ #category : #'helpers-dialog' }
TWEBComponentHelpers >> lightbox: aComponent title: aTitleText showClose: aBoolean [
	^self lightbox: aComponent title: aTitleText showClose: aBoolean large: false
]

{ #category : #'helpers-dialog' }
TWEBComponentHelpers >> lightbox: aComponent title: aTitleText showClose: aBoolean large: aBooleanLarge [
	"Display aComponent within a lightbox of the receiver. Note, that this does a full refresh displaying the lightbox. Also note, that this only works well, if you sent to the root component of your application."
	
	^ self wait: [ :cc | 
		self 
			show: aComponent
			onAnswer: cc
			delegation: (self pi defaultLightboxClass new
				delegate: aComponent;
				title: aTitleText;
				showCloseButton: aBoolean;
				isLarge: aBooleanLarge;
				yourself).
		WARenderNotification signal ]
]

{ #category : #'as yet unclassified' }
TWEBComponentHelpers >> offerDownload: aFilePath named: aFilename mime: aMimeString message: aMessageString [
	| downloader |

	downloader := WEBDownloadDocumentComponent named: aFilename action: [
		self sendFileToBrowser: aFilePath mime: aMimeString named: aFilename
	].

	downloader textMessage: aMessageString.
	
	self window: 'Download' with: downloader
]

{ #category : #'as yet unclassified' }
TWEBComponentHelpers >> offerDownloadFile: aWebLocalFileReference [
	^ self
		offerDownload: aWebLocalFileReference filePath
		named: aWebLocalFileReference title
		mime: aWebLocalFileReference contentType
		message: nil
]

{ #category : #'as yet unclassified' }
TWEBComponentHelpers >> offloadDownloadWork: aBlock [
	"aBlock muss die Datei als WEBLocalFileReference liefern"
	| component jobId |
	
	jobId := self currentUser displayName, ' (', self currentUser uuidString, '): Download-Dokument erzeugen'.

	component := WEBBackgroundJobComponent
		jobTitle: jobId
		named: 'Ihre gewünschte Datei wird erzeugt.'
		block: aBlock.

	component beAutoClose.
	
	self show: component onAnswer: [:job |
		job ifSuccess: [
			| file |
			file := job executionResult. "WEBLocalFileReference"
			self offerDownloadFile: file]]
]

{ #category : #actions }
TWEBComponentHelpers >> ok [
	"Standard implementation for the form decoration PPLFormDecoration to work out of the box"
	self answer
]

{ #category : #decorations }
TWEBComponentHelpers >> removeForm [
	self formDecoration ifNotNil: [
		self removeDecoration: self formDecoration.
		self formDecoration: nil]
]

{ #category : #rendering }
TWEBComponentHelpers >> renderFormButtonsOn: html [
	"Um die Buttons der Form-Decoration noch explizit an anderen Stellen platzieren zu können"
	self formDecoration renderButtonsOn: html
]

{ #category : #rendering }
TWEBComponentHelpers >> rendererClass [
	^self pi defaultHtmlCanvasClass 
]

{ #category : #'helpers-dialog' }
TWEBComponentHelpers >> request: aText [
	^ self request: aText default: nil
]

{ #category : #'helpers-dialog' }
TWEBComponentHelpers >> request: aQuestionText default: aDefaultText [
	^self request: aQuestionText title: 'Eingabe' default: aDefaultText

]

{ #category : #'helpers-dialog' }
TWEBComponentHelpers >> request: aQuestionText default: aDefaultText validation: aBlock [
	| isValid newValue |
	newValue := aDefaultText.
	
	[
		newValue := self request: aQuestionText default: newValue.
		
		"Handle cancel"
		newValue ifNil: [^nil].
			
		isValid := aBlock isNil or: [(aBlock value: newValue) = true]. "Robustheit, es könnte non boolean kommen"
		isValid ifFalse: [
			self inform: 'Ungültige Eingabe, bitte erneut versuchen.'
		].
		
		] doWhileFalse: [isValid].
		
	^newValue
]

{ #category : #'helpers-dialog' }
TWEBComponentHelpers >> request: aQuestionText title: aTitleString [
	^self request: aQuestionText title: aTitleString default: nil
]

{ #category : #'helpers-dialog' }
TWEBComponentHelpers >> request: aQuestionText title: aTitleString default: aDefaultText [
	^ self window: aTitleString with: (WEBInputDialog new
		default: aDefaultText;
		messageText: aQuestionText;
		yourself)
]

{ #category : #'helpers-dialog' }
TWEBComponentHelpers >> request: aQuestionText validation: aBlock [
	^self request: aQuestionText default: nil validation: aBlock
]

{ #category : #'as yet unclassified' }
TWEBComponentHelpers >> requestCaptcha [
	| answer |
	answer := self window: 'Captcha Code (Anti-Robot Sicherheitsabfrage)' with: WEBFigletCaptchaComponent new.

	^answer = true
]

{ #category : #'helpers-dialog' }
TWEBComponentHelpers >> requestMasked: aQuestionText [
	^ self window: 'Eingabe' with: (WEBInputDialog new
		beMasked;
		messageText: aQuestionText;
		yourself)
]

{ #category : #'helpers-dialog' }
TWEBComponentHelpers >> requestMultiline: aQuestionText [
	^self requestMultiline: aQuestionText default: nil
]

{ #category : #'helpers-dialog' }
TWEBComponentHelpers >> requestMultiline: aQuestionText default: aDefaultText [
	^ self window: 'Eingabe' with: (WEBInputDialog new
		beMultiline;
		default: aDefaultText;
		messageText: aQuestionText;
		yourself)
]

{ #category : #'as yet unclassified' }
TWEBComponentHelpers >> restoreScrollPositionId [
	^self identityHash greaseString
]

{ #category : #helpers }
TWEBComponentHelpers >> sendFileToBrowser: aFilePath mime: aMimeTypeString named: aString [
	"Sends the file to the browser"
	
	self requestContext respond: [ :response |
		response
			contentType: aMimeTypeString asString; "'application/pdf'"
			doNotCache;
			headerAt: 'X-Sendfile' put: aFilePath; "Apache"
			headerAt: 'X-Accel-Redirect' put: aFilePath; "nginx"
			attachmentWithFileName: aString ]
]

{ #category : #helpers }
TWEBComponentHelpers >> sendPdfToBrowser: aFilePath named: aString [
	self sendFileToBrowser: aFilePath mime: 'application/pdf' named: aString
]

{ #category : #'as yet unclassified' }
TWEBComponentHelpers >> showWithBack: aComponent [
	self show: (aComponent addBackButton; yourself)
]

{ #category : #'helpers-dialog' }
TWEBComponentHelpers >> warn: aText [
	^self warn: aText title: 'Wichtige Information'
]

{ #category : #'helpers-dialog' }
TWEBComponentHelpers >> warn: aText title: aTitleString [
	^ self window: aTitleString with: (WEBInformationComponent new
		beWarning;
		message: aText;
		yourself)
]

{ #category : #'helpers-dialog' }
TWEBComponentHelpers >> window: aComponent [
	^self window: nil with: aComponent
]

{ #category : #'helpers-dialog' }
TWEBComponentHelpers >> window: aText with: aComponent [
	^self window: aText with: aComponent showClose: false

]

{ #category : #'helpers-dialog' }
TWEBComponentHelpers >> window: aText with: aComponent showClose: showClose [
	^self lightbox: aComponent title: aText showClose: showClose

]
