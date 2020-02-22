Class {
	#name : #WEBPingRequestHandler,
	#superclass : #WARequestHandler,
	#category : #'Webbase-Main-View'
}

{ #category : #'as yet unclassified' }
WEBPingRequestHandler class >> register [
	WAAdmin register: self at: 'ping'
]

{ #category : #'as yet unclassified' }
WEBPingRequestHandler >> handleFiltered: aRequestContext [
	aRequestContext respond: [ :response |
		response
			contentType: WAMimeType textPlain;
			nextPutAll: 'OK']
]
