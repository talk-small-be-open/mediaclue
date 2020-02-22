Class {
	#name : #WEBDownloadDocumentComponent,
	#superclass : #WEBComponent,
	#instVars : [
		'textMessage',
		'actionBlock',
		'documentName'
	],
	#category : #'Webbase-Main-View'
}

{ #category : #'as yet unclassified' }
WEBDownloadDocumentComponent class >> named: aString action: aBlock [ 
	^self new
		actionBlock: aBlock;
		documentName: aString;
		yourself
]

{ #category : #'as yet unclassified' }
WEBDownloadDocumentComponent >> actionBlock: aBlock [
	actionBlock := aBlock
]

{ #category : #'as yet unclassified' }
WEBDownloadDocumentComponent >> documentName: aString [
	documentName := aString
]

{ #category : #'as yet unclassified' }
WEBDownloadDocumentComponent >> performAction [
	actionBlock value
]

{ #category : #'as yet unclassified' }
WEBDownloadDocumentComponent >> renderContentOn: html [
	html paragraph: textMessage.

	html script: 'function downloadClicked() {
	$("#downloadDocument_closeButton").show();
	$("#downloadDocument_closeAnchor").hide();
}'.
	
	html anchorButtonPrimary
		onClick: (JSStream on: 'setTimeout(downloadClicked, 500)');
		callback: [self performAction];
		with: [
			html iconDocument.
			html strong: 'Download:'; space.
			html text: documentName].
	
	html buttonToolbar class: 'topBuffer'; with: [
		html anchorButton
			id: 'downloadDocument_closeButton';
			style: 'display: none';
			callback: [self close];
			with: 'OK, ich habe das Dokument runtergeladen'.
		html anchor
			id: 'downloadDocument_closeAnchor';
			class: 'text-muted small';
			callback: [self close];
			with: [
				html small: 'Ohne Download schliessen']]
]

{ #category : #'as yet unclassified' }
WEBDownloadDocumentComponent >> textMessage: aString [
	textMessage := aString
]
