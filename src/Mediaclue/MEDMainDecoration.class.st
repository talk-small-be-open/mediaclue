Class {
	#name : #MEDMainDecoration,
	#superclass : #WEBMainDecoration,
	#category : #'Mediaclue-View'
}

{ #category : #updating }
MEDMainDecoration >> updateRootJquery: anHtmlRoot [
	anHtmlRoot javascript url: '/lib/jquery-3.3.1.min.js'.
	anHtmlRoot javascript url: '/lib/jquery-ui-1.12.1.custom/jquery-ui.min.js'.
]

{ #category : #updating }
MEDMainDecoration >> updateRootLibraries: anHtmlRoot [
	super updateRootLibraries: anHtmlRoot.

	anHtmlRoot stylesheet url: '/lib/pure-1.0.1/pure-min.css'.
	anHtmlRoot stylesheet url: '/lib/pure-1.0.1/grids-responsive-min.css'.

"Hat Bug	anHtmlRoot javascript url: '/lib/selectize/selectize.min.js'."
	anHtmlRoot javascript url: '/lib/selectize/selectize.js'.

"per LESS	anHtmlRoot stylesheet url: '/lib/selectize/selectize.min.js'."

	anHtmlRoot javascript url: '/lib/autosize/autosize.min.js'.

	anHtmlRoot stylesheet url: '/styles.css'.
	anHtmlRoot javascript url: '/scripts.js'.

]
