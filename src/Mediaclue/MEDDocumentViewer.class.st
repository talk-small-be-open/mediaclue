Class {
	#name : #MEDDocumentViewer,
	#superclass : #MEDMediaViewer,
	#category : #'Mediaclue-View'
}

{ #category : #rendering }
MEDDocumentViewer >> renderPreviewOn: html [
	| id pdfUrl |
"	html pureImage url: (model previewImageUrl: #large)."

	id := html nextId.
	
	html canvas
		id: id;
		style: 'border:1px solid black'.

	html div: [
		html anchor
			class: 'actionClick';
			onClick: 'pdfPreviousPage()';
			with: [ html iconArrowLeft; text: 'Zurück'].
		html space: 3.
		html anchor
			class: 'actionClick';
			onClick: 'pdfNextPage()';
			with: [html text: 'Weiter '; iconArrowRight]
	].

	pdfUrl := model previewPdf ifNotNil: #url.

	pdfUrl ifNotBlank: [
		html script: 'renderPdf("', pdfUrl, '", "', id, '")']
]

{ #category : #updating }
MEDDocumentViewer >> updateRoot: anHtmlRoot [
	super updateRoot: anHtmlRoot.
	
	anHtmlRoot javascript url: '/lib/pdfjs-2/build/pdf.js'.
	anHtmlRoot javascript url: '/scripts_pdf.js'
]
