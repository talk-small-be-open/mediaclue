Class {
	#name : #MEDPublicGalleriesComponent,
	#superclass : #MEDGalleriesComponentBase,
	#category : #'Mediaclue-View'
}

{ #category : #'as yet unclassified' }
MEDPublicGalleriesComponent class >> registerAsApplication: aName [
	| app  |

	app := WAAdmin 
		register: self
		asApplicationAt: aName.

	app configuration addParent: WAEmailConfiguration instance.

	app
		preferenceAt: #sessionClass put: MEDPublicGalleriesSession;
"		preferenceAt: #trackingStrategy put: WACookieIfSupportedSessionTrackingStrategy new;"
		scriptGeneratorClass: JQScriptGenerator.
		
	app exceptionHandler: WADebugErrorHandler.

	"Für REST"
	app addFilter: MEDRestfulGalleriesFilter new.

	^app
]

{ #category : #hooks }
MEDPublicGalleriesComponent >> initialRequest: aRequest [
	super initialRequest: aRequest.
	
	self requestContext properties at: #requestedGalleryUuid ifPresent: [ :uuidString |
		(self db findPublicMediaSetByUuid: uuidString) ifNotNil: [:mediaSet |
			self selectMediaSet: mediaSet ]
	]
]

{ #category : #initialization }
MEDPublicGalleriesComponent >> initialize [
	super initialize.

	self addDecoration: self pi defaultMainDecorationClass new
]

{ #category : #updating }
MEDPublicGalleriesComponent >> updateUrl: aUrl [
	super updateUrl: aUrl.
	self isShowing ifTrue: [
		aUrl addToPath: (selectedMediaSet uuidString, '.html')]
]
