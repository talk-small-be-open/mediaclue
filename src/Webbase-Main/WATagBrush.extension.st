Extension { #name : #WATagBrush }

{ #category : #'*Webbase-Main' }
WATagBrush >> disabledIf: aBoolean [
	aBoolean ifTrue: [self disabled]
]

{ #category : #'*Webbase-Main' }
WATagBrush >> noTab [
	self tabIndex: -1
]

{ #category : #'*Webbase-Main' }
WATagBrush >> preventClickPropagation [
"	self onClick: (JSStream on: 'function(e){e.stopPropagation()}')"
	self script: (canvas jQuery this onClick: ((JSStream on: 'event.stopPropagation()') asFunction: #(event)))
]

{ #category : #'*Webbase-Main' }
WATagBrush >> selectOnClick [
	self class: 'selectOnClick'.
	self tooltipTitle: 'Klicken markiert (für copy/paste)'.
	self onClick: 'selectText("', self ensureId, '")'
]

{ #category : #'*Webbase-Main' }
WATagBrush >> submitOnChange [
	self onChange: 'this.form.submit()'
]

{ #category : #'*Webbase-Main' }
WATagBrush >> tooltipTitle: aString [
	self class: 'tooltipTitle'.
	self title: aString
]

{ #category : #'*Webbase-Main' }
WATagBrush >> triggerFocus [
	self script: (canvas jQuery this triggerFocus)
]

{ #category : #'*Webbase-Main' }
WATagBrush >> triggerFocusIf: aBoolean [
	aBoolean ifTrue: [
		self triggerFocus]
]
