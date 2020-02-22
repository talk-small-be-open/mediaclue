Class {
	#name : #WEBComponent,
	#superclass : #WAComponent,
	#traits : 'TWEBComponentHelpers',
	#classTraits : 'TWEBComponentHelpers classTrait',
	#instVars : [
		'formDecoration',
		'containerDecoration'
	],
	#category : #'Webbase-Main-View'
}

{ #category : #'helpers-ui' }
WEBComponent class >> requestPassword [
	^self window: 'Passwortabfrage' with: WEBPasswordComponent new
]

{ #category : #adding }
WEBComponent >> addContainerClass: aCssString [
	containerDecoration addClass: aCssString
]

{ #category : #'as yet unclassified' }
WEBComponent >> formDecoration [
	^formDecoration
]

{ #category : #'as yet unclassified' }
WEBComponent >> formDecoration: anObject [
	formDecoration := anObject
]

{ #category : #initialization }
WEBComponent >> initialize [
	super initialize.
	containerDecoration := self addContainerDiv
]
