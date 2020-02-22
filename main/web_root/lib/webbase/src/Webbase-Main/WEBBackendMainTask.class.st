Class {
	#name : #WEBBackendMainTask,
	#superclass : #WEBMainTask,
	#category : #'Webbase-Main-View'
}

{ #category : #'as yet unclassified' }
WEBBackendMainTask class >> registerAsApplication [

	^self registerAsApplication: 'app-admin'
]

{ #category : #'as yet unclassified' }
WEBBackendMainTask class >> registerAsApplication: aName [
	| app  |

	app := WAAdmin 
		register: self
		asApplicationAt: aName.

	app configuration addParent: WAEmailConfiguration instance.

	app
		preferenceAt: #sessionClass put: self pi defaultBackendSessionClass;
		preferenceAt: #trackingStrategy put: WACookieIfSupportedSessionTrackingStrategy new;
		scriptGeneratorClass: JQScriptGenerator.
		
	"TODO"
	app exceptionHandler: WADebugErrorHandler.

	^app
]

{ #category : #'as yet unclassified' }
WEBBackendMainTask >> loggedInMainComponentClass [
	^self pi defaultAdminLoggedInMainComponentClass 
]

{ #category : #'as yet unclassified' }
WEBBackendMainTask >> publicMainComponentClass [
	^self pi defaultAdminPublicMainComponentClass 
]
