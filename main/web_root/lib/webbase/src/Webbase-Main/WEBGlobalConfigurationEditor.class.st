Class {
	#name : #WEBGlobalConfigurationEditor,
	#superclass : #WEBComponent,
	#category : #'Webbase-Main-View'
}

{ #category : #installation }
WEBGlobalConfigurationEditor >> installSmtpConfig [
	WEBApplicationManager installSmtpConfig
]

{ #category : #rendering }
WEBGlobalConfigurationEditor >> renderCheckboxLabel: aString value: aValue callback: aBlock on: html [
	html tableRow: [
		html tableData: [html text: aString; text: ': '].
		html tableData: [
			html checkbox
				callback: aBlock;
				value: aValue]]
]

{ #category : #rendering }
WEBGlobalConfigurationEditor >> renderContentOn: html [

	"TODO: KEys manuell löschen, einfügen"
	self renderKeyToolsOn: html.
	self renderSettingsOn: html.
	self renderToolsOn: html.
]

{ #category : #rendering }
WEBGlobalConfigurationEditor >> renderKeyToolsOn: html [
	html form: [
		html strong: 'Key erstellen: '.
		html textInput
			callback: [ :value | self touchKey: value ].
		html submitButton with: 'OK'
	]
]

{ #category : #rendering }
WEBGlobalConfigurationEditor >> renderNumberInputLabel: aString value: aValueNumber callback: aBlock on: html [
	html tableRow: [
		html tableData: [html text: aString; text: ': '].
		html tableData: [
			html textInput
				style: 'width: 5em';
				callback: aBlock;
				value: aValueNumber asString]]
]

{ #category : #rendering }
WEBGlobalConfigurationEditor >> renderSettingsOn: html [
	html heading level3; with: 'Global settings'.
	html form: [
		html table: [
			self globalConfiguration localKeys sorted do: [:key |
				| value |
				value := self globalConfiguration at: key.
				(value isKindOf: Boolean) ifTrue: [
					self renderCheckboxLabel: key
						value: value
						callback: [:incomingValue | self globalConfiguration at: key put: incomingValue]
						on: html.
				].
			
				(value isKindOf: String) ifTrue: [
					self renderTextInputLabel: key
						value: value
						callback: [:incomingValue | self smartSet: incomingValue at: key ]
						on: html
				].

				(value isKindOf: Number) ifTrue: [
					self renderNumberInputLabel: key
						value: value
						callback: [:incomingValue | self smartSet: incomingValue at: key ]
						on: html
				].

			]].
		html submitButton: 'Save']
]

{ #category : #rendering }
WEBGlobalConfigurationEditor >> renderTextAreaLabel: aString value: aValueString callback: aBlock on: html [
	html tableRow: [
		html tableData: [html text: aString; text: ': '].
		html tableData: [
			html textArea
				callback: aBlock;
				value: aValueString]]
]

{ #category : #rendering }
WEBGlobalConfigurationEditor >> renderTextInputLabel: aString value: aValueString callback: aBlock on: html [
	html tableRow: [
		html tableData: [html text: aString; text: ': '].
		html tableData: [
			html textInput
				callback: aBlock;
				value: aValueString]]
]

{ #category : #rendering }
WEBGlobalConfigurationEditor >> renderToolsOn: html [
	html heading level3; with: 'Aktionen'.
	html div class: 'bottomBuffer'; with: [
		html anchor
			callback: [self installSmtpConfig];
			with: 'Install SMTP config (if you changed SMTP above)'.
		html break.
		html anchor
			callback: [self sendTestEmail];
			with: 'Send test mail'.

	]
]

{ #category : #'as yet unclassified' }
WEBGlobalConfigurationEditor >> sendTestEmail [
	| email |
	email := self request: 'E-Mail Adresse?' default: 'andreas.brodbeck@mindclue.ch'.
	self db mailer sendTestEmailTo: email
]

{ #category : #'as yet unclassified' }
WEBGlobalConfigurationEditor >> smartSet: aString at: aKey [
	| value |
	value := aString.
	
	aString isAllDigits ifTrue: [ value := aString asInteger ].

	self globalConfiguration at: aKey put: value
]

{ #category : #'as yet unclassified' }
WEBGlobalConfigurationEditor >> touchKey: aString [
	self globalConfiguration at: aString asSymbol ifAbsentPut: [ '' ]
]
