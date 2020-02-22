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
	html grid: [
		html gridUnitSmall: 0 medium: 1/2 large: 1/3 with: [
			html imageLogo ] ].

	html render: loginComponent.
	
	self ifDemoOrDevelopment: [
		html div class: 'demoMessage'; with: [
			html withLineBreaksAndUrls: (self db globalConfiguration demoMessage)]
	]
]
