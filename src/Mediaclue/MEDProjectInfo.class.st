Class {
	#name : #MEDProjectInfo,
	#superclass : #WEBProjectInfo,
	#category : #'Mediaclue-Core'
}

{ #category : #'as yet unclassified' }
MEDProjectInfo >> defaultDatabaseBaseClass [
	^WEBVoyageMongoDatabase
]

{ #category : #'as yet unclassified' }
MEDProjectInfo >> defaultFrontendSessionClass [
	^ MEDFrontendSession
]

{ #category : #'as yet unclassified' }
MEDProjectInfo >> defaultGlobalConfigurationClass [
	^MEDGlobalConfiguration
]

{ #category : #'as yet unclassified' }
MEDProjectInfo >> defaultIdentityProviderClass [
	^WEBLocalIdentityProvider "MEDLdapIdentityProvider"
]

{ #category : #'as yet unclassified' }
MEDProjectInfo >> defaultLoggedInMainComponentClass [
	^MEDMainComponent
]

{ #category : #'as yet unclassified' }
MEDProjectInfo >> defaultPublicMainComponentClass [
	^MEDPublicMainComponent
]

{ #category : #'as yet unclassified' }
MEDProjectInfo >> defaultSchoolSubjectNames [
	^{
'Biologie'.
'Bildnerisches Gestalten'.
'Chemie'.
'Chinesisch'. 
'Deutsch'.
'Englisch'.
'Wirtschaft und Recht'.
'Französisch'.
'Geographie'.
'Griechisch'.
'Geschichte'.
'Italienisch'.
'Informatik'.
'Kunstgeschichte'.
'Latein'.
'Mathematik'.
'Medien und Gesellschaft'.
'Musik'.
'Physik'.
'Philosophie'.
'Religion'.
'Russisch'. 
'Schulanlass'. "Pseudo-Fach-Tag, gemäss Abmachung mit Simon Küpfer, August 2011"
'Spanisch'. 
'Sport'. 
'Theater'.
}
]

{ #category : #'as yet unclassified' }
MEDProjectInfo >> defaultUserClass [
	^MEDUser
]

{ #category : #'as yet unclassified' }
MEDProjectInfo >> mongoDbPassword [
	^''
]

{ #category : #'as yet unclassified' }
MEDProjectInfo >> projectName [
	^'Mediaclue - Mediendatenbank'
]

{ #category : #'as yet unclassified' }
MEDProjectInfo >> projectShortName [
	^'Mediaclue'
]

{ #category : #'as yet unclassified' }
MEDProjectInfo >> seasideWebserverPort [
	^8087
]
