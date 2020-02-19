Class {
	#name : #MEDVideoViewer,
	#superclass : #MEDMediaViewer,
	#category : #'Mediaclue-View'
}

{ #category : #rendering }
MEDVideoViewer >> renderPreviewOn: html [
"	html pureImage url: (model previewImageUrl: #large)"
	html video
		preload: 'metadata';
		autoplay: false;
		width: 800;
		height: 600;
		poster: (model previewImageUrl: #large);
		controls: true;
		with: [
			html source
				url: (model videoUrl);
				type: model mimeType asString.
"				media:"
		]
]
