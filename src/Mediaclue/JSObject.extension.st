Extension { #name : #JSObject }

{ #category : #'*Mediaclue' }
JSObject >> isEqual: anObject [ 
	"Combine the receiver and anObject with a logical equality test."
	
	self addDecoration: (JSBinary new operator: '=='; statement: anObject)
]
