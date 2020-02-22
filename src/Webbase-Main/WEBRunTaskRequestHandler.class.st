Class {
	#name : #WEBRunTaskRequestHandler,
	#superclass : #WARequestHandler,
	#traits : 'TWEBGlobalHelpers',
	#classTraits : 'TWEBGlobalHelpers classTrait',
	#category : #'Webbase-Main-View'
}

{ #category : #'as yet unclassified' }
WEBRunTaskRequestHandler class >> register [
	| app |
	app := WAAdmin register: self at: 'runTask'.
	
	app configuration addParent: WAEmailConfiguration instance.

	^app
]

{ #category : #'application-faking' }
WEBRunTaskRequestHandler >> clear [
	"do nothing. Called when clearing seaside sessions"
]

{ #category : #handling }
WEBRunTaskRequestHandler >> handleFiltered: aRequestContext [
	| tasksClass |
	tasksClass := self pi defaultTasksClass.

	aRequestContext respond: [ :response |
		| taskName output |
		output := 'OK'.
		taskName := aRequestContext request url path last asSymbol.
		(tasksClass respondsTo: taskName)
			ifTrue: [
				[
					| result |
					result := tasksClass perform: taskName.
				
					"Reagiere auf verschiedene Resultate"
					result isString
						ifTrue: [
							output := result.
							self logError: output.
							response internalError]
						ifFalse: [
							(result == false)
								ifTrue: [
									output := 'Fehler in Task'.
									self logError: output.
									response internalError]
								ifFalse: [
									"Task was OK and returned true or self or anything else, which does not count as error"
									output := taskName, ' OK'.
									self logInfo: output]]
							
				] on: Error do: [:err |
					output := err description.
					self logError: output.
					response internalError]]
			ifFalse: [
				output := ('Unknown task ', taskName).
				self logWarning: output.
				response notFound].

		response
			contentType: WAMimeType textPlain;
			nextPutAll: output;
			nextPutAll: String lf]
]

{ #category : #'application-faking' }
WEBRunTaskRequestHandler >> isApplication [
	"WARNING! We mimic to be an application, since we want to send Emails, and that will get the configurations for
	the SMTP via Grease seasideSmtpUsernamer etc. We ARE NOT a full application, but for those things to work,
	we need to pretend to be one."
	^true
]
