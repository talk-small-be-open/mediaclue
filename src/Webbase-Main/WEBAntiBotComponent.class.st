Class {
	#name : #WEBAntiBotComponent,
	#superclass : #WEBComponent,
	#instVars : [
		'challenge',
		'isOk'
	],
	#category : #'Webbase-Main-View'
}

{ #category : #'as yet unclassified' }
WEBAntiBotComponent >> confirmChallenge: aString [
	challenge = aString ifFalse: [ isOk := false ]
]

{ #category : #actions }
WEBAntiBotComponent >> incoming: aValue [
	aValue
		ifBlank: [ isOk ifNil: [isOk := true]]
		ifNotBlank: [ isOk := false ]
]

{ #category : #initialization }
WEBAntiBotComponent >> initialize [

	super initialize.

	isOk := nil.
	
	challenge := UUID new asString
]

{ #category : #accessing }
WEBAntiBotComponent >> isOk [
	^isOk = true
]

{ #category : #rendering }
WEBAntiBotComponent >> renderContentOn: html [
	| catchall |
	catchall := [ :value | self incoming: value ].
	
	"Versteckt, damit Menschen es nicht ausfüllen"
	html div style: 'height: 0.1px; overflow: hidden'; with: [
		"Einmal challenge, weil sonst das Formular einfach nochmals gepostet werden könnte"
		"Und: Leeren der Felder per Javascript, weil gewisse Browser beim Autofüllen diese Felder füllen, aber Bots führen eher kein Javascript aus"
		html textInput
			script: ((html jQuery this closest: 'form') onSubmit: ((html jQuery: 'input.webappab') value: ''));
			callback: [:ch | self confirmChallenge: ch];
			with: challenge.

		"Fake inputs, welche immer leer bleiben müssen, sonst ist es ein Bot"
		"Es kann jedoch sein, dass der Browser mit Autofill ebenfalls das ausfüllt"
		html textInput
			class: 'required name lastName webappab';
			callback: catchall.
		html textInput
			class: 'required name firstName webappab';
			callback: catchall.
		html textInput
			class: 'required name email webappab';
			callback: catchall.
	]
]
