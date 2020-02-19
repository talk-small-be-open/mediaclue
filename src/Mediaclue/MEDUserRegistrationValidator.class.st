Class {
	#name : #MEDUserRegistrationValidator,
	#superclass : #MEDValidator,
	#category : #'Mediaclue-Validation'
}

{ #category : #defaults }
MEDUserRegistrationValidator >> default [
	self forNewRegistration
]

{ #category : #rulesets }
MEDUserRegistrationValidator >> forNewRegistration [
	self validationGroup: [
		self validatePresence
			of: #email;
			named: #email.
		self validateEmailFormat of: #email.
		self validateUniqueEmail].

	self validatePresence of: #firstName.
	self validatePresence of: #lastName.

	self validationGroup: [
		self validatePresence of: #password.
		self validatePasswordLength].

	self validationGroup: [
		self validatePresence of: #passwordConfirmation.
		self validatePasswordConfirmation].
	
	self validateAcceptanceOfTermsAndConditions
]

{ #category : #'rules creation' }
MEDUserRegistrationValidator >> validateAcceptanceOfTermsAndConditions [
	(self validateTrue: [object isAcceptedTermsAndConditions])
		errorMessage: #userRegistrationValidator:mustAcceptTermsAndConditions
]

{ #category : #'rules creation' }
MEDUserRegistrationValidator >> validatePasswordConfirmation [
	(self validateTrue: [object password = object passwordConfirmation])
		errorMessage: #passwordValidator:confirmationMismatch
		
]

{ #category : #'rules creation' }
MEDUserRegistrationValidator >> validatePasswordLength [
	self validateLength
		of: #password;
		minimum: 6.
]

{ #category : #'rules creation' }
MEDUserRegistrationValidator >> validateUniqueEmail [
	(self validateTrue: [(self db isExistingUserWithEmail: self object email) not])
		errorMessage: #userRegistrationValidator:emailIsTaken
]
