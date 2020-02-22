Class {
	#name : #WEBBetatestErrorHandler,
	#superclass : #WAHtmlErrorHandler,
	#traits : 'TWEBGlobalHelpers',
	#classTraits : 'TWEBGlobalHelpers classTrait',
	#category : #'Webbase-Main-View'
}

{ #category : #actions }
WEBBetatestErrorHandler >> renderContentForException: anException on: html [

	Transcript show: ('FEHLER im Frontend: ', anException description); cr.

	html heading level1; with: 'Ups, ein Fehler!'.
	html paragraph: [
		html text: 'Das kann passieren. Wir sind im Beta-Test-Modus und sammeln Erfahrungen. Schreiben Sie uns doch kurz eine Mail, an welcher Stelle dieser Fehler aufgetreten ist.'.
		html break.
		html text: 'Vielen Dank!'.
		html break.
		html anchor
			url: ('mailto:',(self globalConfiguration sysAdminEmailAddress ifBlank: [ 'andreas.brodbeck@mindclue.ch']));
			with: 'E-Mail schreiben ...'
	].

	html paragraph: [
		html text: 'Technische Fehlermeldung: '.
		html text: anException description].

	html paragraph: [
		html anchor
			url: '#';
			onClick: 'history.back()';
			with: 'Zurück ...']
]

{ #category : #content }
WEBBetatestErrorHandler >> titleForException: anException [
	^ 'Beta-Test Fehler'
]
