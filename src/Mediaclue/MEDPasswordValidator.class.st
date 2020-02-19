Class {
	#name : #MEDPasswordValidator,
	#superclass : #MEDValidator,
	#category : #'Mediaclue-Validation'
}

{ #category : #'as yet unclassified' }
MEDPasswordValidator >> default [
	self validationGroup: [
		self validatePresence of: #password.
		self validatePasswordLength].
	self validationGroup: [
		self validatePresence of: #passwordConfirmation.
		self validatePasswordConfirmation]
]

{ #category : #'as yet unclassified' }
MEDPasswordValidator >> validatePasswordConfirmation [
	(self validateTrue: [object password = object passwordConfirmation])
		errorMessage: #passwordValidator:confirmationMismatch
		
]

{ #category : #'as yet unclassified' }
MEDPasswordValidator >> validatePasswordLength [
	self validateLength
		of: #password;
		minimum: 6.
]
