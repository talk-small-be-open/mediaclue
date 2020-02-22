Class {
	#name : #WEBRestoreScrollPositionDecoration,
	#superclass : #WEBComponentDecoration,
	#instVars : [
		'elementId'
	],
	#category : #'Webbase-Main-View'
}

{ #category : #testing }
WEBRestoreScrollPositionDecoration >> isGlobal [
	^ false
]

{ #category : #'as yet unclassified' }
WEBRestoreScrollPositionDecoration >> scrollingItemId [
	^self decoratedComponent restoreScrollPositionId
]

{ #category : #updating }
WEBRestoreScrollPositionDecoration >> updateRoot: aHtmlRoot [
	| functionName |
	super updateRoot: aHtmlRoot.

	functionName := 'saveScroll_', self scrollingItemId.

	aHtmlRoot addScript: '
function ', functionName,'() {
	saveScroll("', self scrollingItemId,'")
}

$(document).ready(function(){
	if (!$.restoreScrollPositionIsSet) {
		$.restoreScrollPositionIsSet = true;
		window.addEventListener("unload", ', functionName, ');
		loadScroll("', self scrollingItemId,'");
		setInterval(', functionName, ', 1000);
	}
});
'
]
