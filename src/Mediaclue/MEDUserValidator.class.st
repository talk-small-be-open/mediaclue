Class {
	#name : #MEDUserValidator,
	#superclass : #MEDValidator,
	#category : #'Mediaclue-Validation'
}

{ #category : #defaults }
MEDUserValidator >> default [
	self forActivation
]

{ #category : #rulesets }
MEDUserValidator >> forActivation [
	self validationGroup: [
		self validatePresence
			of: #email;
			named: #email.
		self validateEmailFormat of: #email.
		self validateUniqueEmail].

"	self validatePresence of: #firstName.
	self validatePresence of: #lastName."
]

{ #category : #rulesets }
MEDUserValidator >> forRegistration [
	self validationGroup: [
		self validatePresence
			of: #email;
			named: #email.
		self validateEmailFormat of: #email.
		self validateUniqueEmail].

	self validatePresence of: #firstName.
	self validatePresence of: #lastName.
]

{ #category : #'rules creation' }
MEDUserValidator >> validateUniqueEmail [
	(self validateTrue: [
		| existingUser |
		existingUser := self db findUserByEmail: self object email.
		existingUser isNil or: [existingUser == self object]])

		errorMessage: #userValidator:emailIsTaken
]
