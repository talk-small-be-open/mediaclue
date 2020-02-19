Class {
	#name : #MEDAudioViewer,
	#superclass : #MEDMediaViewer,
	#category : #'Mediaclue-View'
}

{ #category : #rendering }
MEDAudioViewer >> renderPreviewOn: html [
	html pureImage url: (model previewImageUrl: #large).
	html audio
		preload: 'metadata';
		autoplay: false;
		controls: true;
		with: [
			html source
				url: (model audioUrl);
				type: model mimeType asString.
"				media:"
		]
]
