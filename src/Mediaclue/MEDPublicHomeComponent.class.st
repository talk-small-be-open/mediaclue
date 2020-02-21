Class {
	#name : #MEDPublicHomeComponent,
	#superclass : #MEDComponent,
	#instVars : [
		'loginComponent'
	],
	#category : #'Mediaclue-View'
}

{ #category : #initialization }
MEDPublicHomeComponent >> initialize [
	super initialize.
	loginComponent := WEBLoginComponent new.
	loginComponent onLogin: [ self close ]
]

{ #category : #rendering }
MEDPublicHomeComponent >> renderContentOn: html [
	html imageLogo.

	html render: loginComponent.
	
	self ifDemoOrDevelopment: [
		html div class: 'demoMessage'; with: [
			html withLineBreaksAndUrls: (self db globalConfiguration demoMessage)]
	]
]
