"
Captcha component, displaying the code as a ASCII art. Needs command line tool figlet, see http://www.figlet.org/
"
Class {
	#name : #WEBFigletCaptchaComponent,
	#superclass : #WEBCaptchaComponent,
	#category : #'Webbase-Main-View'
}

{ #category : #'as yet unclassified' }
WEBFigletCaptchaComponent >> figletCaptchaCodeText [
	^WEBSystemCommand fetch: ('figlet -W ', captchaCode)
]

{ #category : #'as yet unclassified' }
WEBFigletCaptchaComponent >> renderCaptchaCodeOn: html [
	html preformatted
		class: 'captcha';
		with: self figletCaptchaCodeText
]
