Class {
	#name : #WEBKeepaliveSessionDecoration,
	#superclass : #WEBComponentDecoration,
	#category : #'Webbase-Main-View'
}

{ #category : #'as yet unclassified' }
WEBKeepaliveSessionDecoration >> isGlobal [
	^ true
]

{ #category : #rendering }
WEBKeepaliveSessionDecoration >> renderContentOn: html [
	| keepaliveUrl appName |
	self renderNextOn: html.

	"HINWEIS: Beim allerersten Session-Aufruf, gibt es noch keinen Pfad, deshalb ifAbsent"
	appName := self requestContext request url path at: 1 ifAbsent: ['app'].
		
	keepaliveUrl := String streamContents: [:stream |
		stream nextPutAll: '//'.
		stream nextPutAll: self globalConfiguration webDomain.
		stream nextPutAll: '/keepalive?session='.
		stream nextPutAll: self session key.
		stream nextPutAll: '&app='.
		stream nextPutAll: appName.
	].

	html script: '
function callKeepalive() {
	',(html jQuery ajax url: keepaliveUrl) asJavascript, ';
	setTimeout(callKeepalive, 540000);
}

setTimeout(callKeepalive, 540000);
'.
]
