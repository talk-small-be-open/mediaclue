"
I am a decoration that looks like a single window box in the browser. I will display the logo. Only use this, if it is the only one component in the browser.
"
Class {
	#name : #WEBWindowDecoration,
	#superclass : #WEBComponentDecoration,
	#instVars : [
		'cssClass',
		'title'
	],
	#category : #'Webbase-Main-View'
}

{ #category : #'instance creation' }
WEBWindowDecoration class >> default [
	^ self red
]

{ #category : #'instance creation' }
WEBWindowDecoration class >> green [
	^ self newWithStyle: 'green'
]

{ #category : #'instance creation' }
WEBWindowDecoration class >> newWithStyle: aString [
	^ self new
		cssClass: aString;
		yourself.
]

{ #category : #'instance creation' }
WEBWindowDecoration class >> red [
	^ self newWithStyle: 'red'
]

{ #category : #'instance creation' }
WEBWindowDecoration class >> title: aTitleString [
	^self default
		title: aTitleString;
		yourself
]

{ #category : #'as yet unclassified' }
WEBWindowDecoration >> cssClass: aClassName [
	cssClass := aClassName.
]

{ #category : #'as yet unclassified' }
WEBWindowDecoration >> initialize [
	super initialize.

	
]

{ #category : #'as yet unclassified' }
WEBWindowDecoration >> isGlobal [
	^ true
]

{ #category : #rendering }
WEBWindowDecoration >> renderContentOn: html [
	html div
		class: self class name;
		class: cssClass;
		with: [
			html h2 class: 'title'; with: [
				html anchor
					url: self globalConfiguration webUrl;
					with: [
						html image class: 'logo'; url: self pi logoRelativePath].
					title ifNotBlank: [ html span: title ]].
			self renderNextOn: html]
]

{ #category : #accessing }
WEBWindowDecoration >> title [
	^ title
]

{ #category : #accessing }
WEBWindowDecoration >> title: anObject [
	title := anObject
]
