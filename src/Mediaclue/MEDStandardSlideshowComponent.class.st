Class {
	#name : #MEDStandardSlideshowComponent,
	#superclass : #MEDSlideshowComponentBase,
	#category : #'Mediaclue-View'
}

{ #category : #rendering }
MEDStandardSlideshowComponent >> renderContentOn: html [
	
	html span
		class: 'actionClick fullscreenLink';
		onClick: (((html jQuery this closest: 'div.MEDStandardSlideshowComponent') at: 0) call: 'toggleFullscreen');
		with: [
			html iconFullscreen.
			html text: 'Vollbild'].
		
	html div
		class: 'slideshow';
		script: (html jQuery this call: 'slick' with: self slickOptions);
		with: [ 
			self mediasDo: [ :each |
				"Wir verzichten hier auf MediaRenderer, weil wir für slick speziell rendern müssen"
				html div class: 'slide'; with: [ 
					html div class: 'imgContainer'; with: [
						html image
							attributeAt: 'data-lazy' put: (each previewImageUrl: #xlarge) ] ]
"				html preview: "
"				mediaRenderer renderPreview: each size: #small on: html" ]]
]

{ #category : #'as yet unclassified' }
MEDStandardSlideshowComponent >> slickOptions [
	"Siehe https://kenwheeler.github.io/slick/"
	^ {
	'slidesToShow'->1.
	'slidesToScroll'->1.
	'dots'->false.
	'arrows'->true.
	'infinite'->false.
	'lazyLoad'->'ondemand'.
	'centerMode'->false.
	'rows'->1.
	'slidesPerRow'->1.
	'variableWidth'->false.
	'accessibility'->true.
	'adaptiveHeight'->false.
	'draggable'->true.
	'mobileFirst'->false.
	'swipe'->true.
	'touchMove'->true.
	'waitForAnimate'->false.
"	'responsive'->{
	{
		'breakpoint'->1024.
		'settings'->{
			'slidesToShow'->3.
			'slidesToScroll'->3.} asD } asD.
	{
		'breakpoint'->600.
		'settings'->{
			'slidesToShow'->2.
			'slidesToScroll'->2.} asD } asD.
	}."

	} asDictionary
]

{ #category : #updating }
MEDStandardSlideshowComponent >> updateRoot: anHtmlRoot [
	super updateRoot: anHtmlRoot.

	anHtmlRoot stylesheet url: '/lib/slick/slick.css'.
	anHtmlRoot stylesheet url: '/lib/slick/slick-theme.css'.
	
	anHtmlRoot javascript url: '/lib/slick/slick.min.js'.
]
