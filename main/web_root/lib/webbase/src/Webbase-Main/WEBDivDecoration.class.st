Class {
	#name : #WEBDivDecoration,
	#superclass : #WEBComponentDecoration,
	#instVars : [
		'cssClass',
		'cssStyle',
		'global'
	],
	#category : #'Webbase-Main-View'
}

{ #category : #'as yet unclassified' }
WEBDivDecoration class >> cssClass: aString [
	^ self new
		cssClass: aString;
		yourself.
]

{ #category : #'as yet unclassified' }
WEBDivDecoration class >> cssStyle: aString [
	^ self new
		cssStyle: aString;
		yourself.
]

{ #category : #adding }
WEBDivDecoration >> addClass: aString [
	cssClass := cssClass, ' ', aString
]

{ #category : #'as yet unclassified' }
WEBDivDecoration >> beGlobal [
	global := true
]

{ #category : #'as yet unclassified' }
WEBDivDecoration >> beLocal [
	global := false
]

{ #category : #accessing }
WEBDivDecoration >> cssClass [
	^ cssClass
]

{ #category : #accessing }
WEBDivDecoration >> cssClass: anObject [
	cssClass := anObject
]

{ #category : #accessing }
WEBDivDecoration >> cssStyle [
	^ cssStyle
]

{ #category : #accessing }
WEBDivDecoration >> cssStyle: anObject [
	cssStyle := anObject
]

{ #category : #'as yet unclassified' }
WEBDivDecoration >> initialize [
	super initialize.
	global := true
]

{ #category : #'as yet unclassified' }
WEBDivDecoration >> isGlobal [
	^global = true
]

{ #category : #'as yet unclassified' }
WEBDivDecoration >> renderContentOn: html [
	html div
		class: cssClass;
		style: cssStyle;
		with: [
			self renderNextOn: html]
]
