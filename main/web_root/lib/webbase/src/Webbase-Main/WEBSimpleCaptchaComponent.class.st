Class {
	#name : #WEBSimpleCaptchaComponent,
	#superclass : #WEBCaptchaComponent,
	#category : #'Webbase-Main-View'
}

{ #category : #rendering }
WEBSimpleCaptchaComponent >> renderCaptchaCodeOn: html [
	html div
		class: 'captcha';
		with: captchaCode
]
