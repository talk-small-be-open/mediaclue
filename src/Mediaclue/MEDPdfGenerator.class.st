Class {
	#name : #MEDPdfGenerator,
	#superclass : #WEBPdfGenerator,
	#category : #'Mediaclue-Misc'
}

{ #category : #'as yet unclassified' }
MEDPdfGenerator class >> generateImagesForPrint: aMediasList named: aString [
	self generateImagesForPrint: aMediasList title: aString
	fileNamed: ((MEDHelper filenameFor: aString), '.pdf')
]

{ #category : #'as yet unclassified' }
MEDPdfGenerator class >> generateImagesForPrint: aMediasList title: aTitleString fileNamed: aString [
	| instance component filePath images |
	images := aMediasList images.

	component := MEDImagesForPrintComponent images: images.
	component title: aTitleString.
	instance := self component: component.
	filePath := instance generate.
	
	^ (WEBLocalFileReference fromPath: filePath)
		contentType: 'application/pdf';
		title: aString;
		yourself
]
