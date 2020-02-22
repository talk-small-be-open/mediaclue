Class {
	#name : #WEBIframeDialog,
	#superclass : #WEBComponent,
	#instVars : [
		'url',
		'width',
		'height'
	],
	#category : #'Webbase-Main-View'
}

{ #category : #accessing }
WEBIframeDialog >> height [
	^ height
]

{ #category : #accessing }
WEBIframeDialog >> height: anObject [
	height := anObject
]

{ #category : #rendering }
WEBIframeDialog >> renderContentOn: html [
	html iframe
		style: ('width: ', width asString, ';height:', height asString);
		class: 'webview';
		url: url.
	
"	html div class: 'mt-1'; with: [
		html bsAnchorButtonLight
			callback: [ self close ];
			with: 'Schliessen']"
]

{ #category : #accessing }
WEBIframeDialog >> url [
	^ url
]

{ #category : #accessing }
WEBIframeDialog >> url: anObject [
	url := anObject
]

{ #category : #accessing }
WEBIframeDialog >> width [
	^ width
]

{ #category : #accessing }
WEBIframeDialog >> width: anObject [
	width := anObject
]
