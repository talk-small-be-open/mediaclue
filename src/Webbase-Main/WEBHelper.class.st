Class {
	#name : #WEBHelper,
	#superclass : #WEBObject,
	#category : #'Webbase-Main-Misc'
}

{ #category : #folders }
WEBHelper class >> appLogFolder [
	^self appMainFolder / 'log'
]

{ #category : #folders }
WEBHelper class >> appMainFolder [
	^self installationBaseFolder / 'main'
]

{ #category : #folders }
WEBHelper class >> appMiscFolder [
	^self appMainFolder / 'misc'
]

{ #category : #folders }
WEBHelper class >> appTempFolder [
	^self appMainFolder / 'tmp'
]

{ #category : #folders }
WEBHelper class >> appWebRootFolder [
	^self appMainFolder / 'web_root'
]

{ #category : #converting }
WEBHelper class >> asMimeEncodedChar: aChar on: aStream [
	aChar = Character space
		ifTrue: [^aStream nextPut: $_].

	((aChar asciiValue between: 32 and: 127) and: [('?=_' includes: aChar) not])
		ifTrue: [^aStream nextPut: aChar].

	aStream nextPut: $=;
		nextPut: (Character digitValue: aChar asciiValue // 16);
		nextPut: (Character digitValue: aChar asciiValue \\ 16)
]

{ #category : #converting }
WEBHelper class >> asMimeEncodedWord: aString [
	| utf8 |

	(aString allSatisfy: [:c | c asciiValue < 128])
		ifTrue: [^aString].

	utf8 := (GRCodec forEncoding: 'utf-8') encode: aString.
		
	^String streamContents: [:stream |
		stream nextPutAll: '=?utf-8?Q?'.
		utf8 do: [:c |
			self asMimeEncodedChar: c on: stream.
		].
		stream nextPutAll: '?=']
]

{ #category : #folders }
WEBHelper class >> cliToolsFolder [
	^self appMainFolder / 'cli_tools'
]

{ #category : #compiling }
WEBHelper class >> compileSmalltalk: aString [
	| compiler |
	compiler := OpalCompiler new.
	compiler
		source: aString.
"		context: thisContext;
		receiver: self;"
"		failBlock: [^ #failedDoit]."

	^compiler evaluate "oder parse oder compile ?"
]

{ #category : #file }
WEBHelper class >> filenameDateAndTimeStringFor: aDateAndTime [
	aDateAndTime ifNil: [^''].
	
	^String streamContents: [:stream |
		stream
			nextPutAll: aDateAndTime year asString;
			nextPut: $-;
			nextPutAll: (aDateAndTime monthIndex asTwoCharacterString);
			nextPut: $-;
			nextPutAll: (aDateAndTime dayOfMonth asTwoCharacterString);
			nextPut: $_;
			nextPutAll: (aDateAndTime hours asTwoCharacterString);
			nextPut: $-;
			nextPutAll: (aDateAndTime minutes asTwoCharacterString).
			]
]

{ #category : #file }
WEBHelper class >> filenameDateStringFor: aDate [
	aDate ifNil: [^''].
	
	^String streamContents: [:stream |
		stream
			nextPutAll: aDate year asString;
			nextPut: $-;
			nextPutAll: (aDate monthIndex asTwoCharacterString);
			nextPut: $-;
			nextPutAll: (aDate dayOfMonth asTwoCharacterString)
	]
]

{ #category : #file }
WEBHelper class >> filenameFor: aString [
	| map sanitized |
	"Konvertiert einen String in einen String passend für Filenamen"
	
	map := {
		$* asInteger -> $_ asInteger.
		$/ asInteger -> $_ asInteger.
	} asDictionary.
	
	sanitized := aString copyWithout: $".
	
	^(self translateString: sanitized map: map) asFileName asDromedaryCase.
]

{ #category : #'as yet unclassified' }
WEBHelper class >> fromUtf8: aString [
	^(GRCodec forEncoding: 'utf8') decode: aString
]

{ #category : #'as yet unclassified' }
WEBHelper class >> generatePasswordHash: aPlaintextPassword [
	^aPlaintextPassword isEmptyOrNil
		ifTrue: [nil]
		ifFalse: [
			| hash |
			hash := GRPlatform current secureHashFor: ((GRCodec forEncoding: 'utf8') encode: aPlaintextPassword).
			hash asArray]
]

{ #category : #'as yet unclassified' }
WEBHelper class >> germanDateAndTimeStringFor: aDateAndTime [
	aDateAndTime ifNil: [^''].
	^String streamContents: [:stream |
		stream
			nextPutAll: (aDateAndTime dayOfMonth asString padLeftTo: 2 with: $0);
			nextPut: $.;
			nextPutAll: (aDateAndTime monthIndex asString padLeftTo: 2 with: $0);
			nextPut: $.;
			nextPutAll: aDateAndTime year asString;
			space;
			nextPutAll: (aDateAndTime hours asString padLeftTo: 2 with: $0);
			nextPut: $:;
			nextPutAll: (aDateAndTime minutes asString padLeftTo: 2 with: $0).
			]
]

{ #category : #'as yet unclassified' }
WEBHelper class >> germanDateStringFor: aDate [
	aDate ifNil: [^''].
	
	^String streamContents: [:stream |
		stream
			nextPutAll: (aDate dayOfMonth asString padLeftTo: 2 with: $0);
			nextPut: $.;
			nextPutAll: (aDate monthIndex asString padLeftTo: 2 with: $0);
			nextPut: $.;
			nextPutAll: aDate year asString]
]

{ #category : #folders }
WEBHelper class >> installationBaseFolder [
"	'dfdfd' asFileReference."
	^FileSystem workingDirectory parent
]

{ #category : #parsing }
WEBHelper class >> parseGermanDate: aDateString [
	| matcher |
	^aDateString isEmptyOrNil
		ifTrue: [nil]
		ifFalse: [
			matcher := RxMatcher forString: '^(\d\d?)\.(\d\d?)\.(\d\d(\d\d)?)$'.
			(matcher matches: aDateString)
				ifTrue: [
					| year |
					year := (matcher subexpression: 4) greaseInteger.
					(year < 100) ifTrue: [year := 2000 + year].
					
					[Date
						year: year
						month: (matcher subexpression: 3) greaseInteger
						day: (matcher subexpression: 2) greaseInteger] ifError: [nil]
				]
				ifFalse: [nil. "PPLError signal: 'could not parse german date'"]].
]

{ #category : #parsing }
WEBHelper class >> parseGermanDateAndTime: aString [
	| parts date time |
	parts := aString findTokens: Character space.
	
	date := self parseGermanDate: parts first.
	time := (parts at: 2 ifAbsent: [ nil ])
		ifNil: [ Time noon ]
		ifNotNil: [:text | self parseGermanTime: text ].
	
	time ifNil: [ time := Time noon ].
	
	^date notNil
		ifTrue: [ DateAndTime date: date time: time ]
		ifFalse: [ nil ]
]

{ #category : #parsing }
WEBHelper class >> parseGermanMonth: aDateString [
	"Mär 2013 oder 2014 Feb"
	| matcher |
	aDateString ifBlank: [^nil].

	"Mär 2013"
	matcher := RxMatcher forString: '^(\w\w\w*)\s(\d\d\d\d)$'.
	(matcher matches: aDateString)
		ifTrue: [
			| year monthName month |
			year := (matcher subexpression: 3) greaseInteger.
			monthName := (matcher subexpression: 2).
			month := Month findFirst: [:each | each matches: (monthName, '*')].
			month = 0 ifTrue: [WEBFormatError signal: 'Invalid month name.'].
			^Month month: month year: year].

	"2013 Mär"
	matcher := RxMatcher forString: '^(\d\d\d\d)\s(\w\w\w*)$'.
	(matcher matches: aDateString)
		ifTrue: [
			| year month monthName |
			year := (matcher subexpression: 2) greaseInteger.
			monthName := (matcher subexpression: 3).
			month := Date monthNames findFirst: [:each | each matches: (monthName, '*')].
			month = 0 ifTrue: [WEBFormatError signal: 'Invalid month name.'].
			^Month month: month year: year].

	"Format nicht erkannt"
	WEBFormatError signal: 'Wrong month format.'
]

{ #category : #parsing }
WEBHelper class >> parseGermanTime: aTimeString [
	| matcher |
	^aTimeString isEmptyOrNil
		ifTrue: [nil]
		ifFalse: [
			matcher := RxMatcher forString: '^(\d\d?)[.:-](\d\d)([.:-](\d\d))?$'.
			(matcher matches: aTimeString)
				ifTrue: [
					Time
						hour: (matcher subexpression: 2) greaseInteger
						minute: (matcher subexpression: 3) greaseInteger
						second: ((matcher subexpression: 5) ifNil: 0 ifNotNil: [:string | string greaseInteger])]
				ifFalse: [nil. "PPLError signal: 'could not parse german date'"]].
]

{ #category : #'as yet unclassified' }
WEBHelper class >> readContentTypeOfFile: aPath [
	| output |
	output := WEBSystemCommand fetch: 'file -b --mime-type "', aPath, '"'.
	^output trimBoth
]

{ #category : #regexp }
WEBHelper class >> regexpEmail [
	^ '^[a-z0-9._%-]+@[a-z0-9.-]+\.[a-z][a-z][a-z]?[a-z]?$'
]

{ #category : #'as yet unclassified' }
WEBHelper class >> toUtf8: aString [
	^(GRCodec forEncoding: 'utf8') encode: aString
]

{ #category : #printing }
WEBHelper class >> translateString: aString map: aDictionary [
	| translated |
	translated := aString copy.
	translated withIndexDo: [:char :index |
		aDictionary at: char asInteger ifPresent: [:normalizedInteger |
			translated at: index put: normalizedInteger asCharacter]].
	
	^translated
]

{ #category : #writing }
WEBHelper class >> writeComponent: aComponent toHtmlFile: aFilename folder: aFolder [
	| builder xhtmlString fakeRequestContext fakeSession |

	fakeRequestContext := WARequestContext request: WARequest new response: WABufferedResponse new codec: (GRCodec forEncoding: 'utf8').

	fakeSession := WEBSession new.

	fakeRequestContext
		push: fakeSession
		during: [
			builder := self pi defaultHtmlCanvasClass builder
				codec: (GRCodec forEncoding: 'utf-8');
				fullDocument: true;
		"		resourceUrl: ('file://', (self globalConfiguration webRootPath), '/files');"
				rootBlock: [:root |
					"Minimale Default HTML Einstellungen"
					root title: 'Applikation'.
					root beHtml5.
					"aComponent updateRoot: root."
					
					(WAVisiblePresenterGuide client:
						(WAUpdateRootVisitor root: root))
						start: aComponent
				];
				yourself.

			"xhtmlString := (GRCodec forEncoding: 'utf-8') encode: (builder render: aComponent)."
			xhtmlString := builder render: [:html |
						html render: aComponent]

		].

	GRPlatform current write: xhtmlString toFile: aFilename inFolder: aFolder
]
