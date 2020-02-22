Class {
	#name : #WEBSessionKeepaliveRequestHandler,
	#superclass : #WARequestHandler,
	#category : #'Webbase-Main-View'
}

{ #category : #'as yet unclassified' }
WEBSessionKeepaliveRequestHandler class >> register [
	WAAdmin register: self at: 'keepalive'
]

{ #category : #'as yet unclassified' }
WEBSessionKeepaliveRequestHandler >> handle: aRequestContext checkSession: aSessionKey app: anAppName [
	| timeToLive |

	timeToLive := 999999.
	aSessionKey ifNotBlank: [
"		timeToLive := self seasideApplication cache expiryPolicy timeToLiveKey: aSessionKey."
"		timeToLive := self seasideApplication configuration at: #maximumRelativeAge."

		(WAAdmin defaultDispatcher handlerAt: anAppName ifAbsent: [nil]) ifNotNil: [:application |
			timeToLive := application cache timeToLive: aSessionKey.
		].		
	].

	aRequestContext respond: [ :response |
		| result |

		result := 'OK'.
		timeToLive <= (5*60) ifTrue: [result := 'nearlyExpired']. "5 Minuten"
		timeToLive <= 0 ifTrue: [result := 'expired'].

		response
			contentType: WAMimeType textPlain;
			nextPutAll: result]
]

{ #category : #'as yet unclassified' }
WEBSessionKeepaliveRequestHandler >> handle: aRequestContext keepAliveSession: aSessionKey app: anAppName [

	aRequestContext respond: [ :response |

		response
			contentType: WAMimeType textPlain;
			nextPutAll: 'OK'.
			
		aSessionKey ifNotBlank: [
			(WAAdmin defaultDispatcher handlerAt: anAppName ifAbsent: [nil]) ifNotNil: [:application |
				application cache at: aSessionKey ifAbsent: [
					response nextPutAll: ', but session key not found'].
		]].

	]
]

{ #category : #handling }
WEBSessionKeepaliveRequestHandler >> handleFiltered: aRequestContext [
	aRequestContext request at: 'app' ifPresent: [:appName |

		aRequestContext request at: 'session' ifPresent: [:sessionKey |
			self handle: aRequestContext keepAliveSession: sessionKey app: appName].

		aRequestContext request at: 'check' ifPresent: [:sessionKey |
			self handle: aRequestContext checkSession: sessionKey app: appName].
	
	]
]
