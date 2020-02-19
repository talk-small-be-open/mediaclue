Class {
	#name : #MEDOrganizationValidator,
	#superclass : #MEDValidator,
	#category : #'Mediaclue-Validation'
}

{ #category : #'as yet unclassified' }
MEDOrganizationValidator class >> forEmailDomains [
	^self new
		forEmailDomains;
		yourself
]

{ #category : #'as yet unclassified' }
MEDOrganizationValidator class >> minimalForAdmins [
	^self new
		minimalForAdmins;
		yourself
]

{ #category : #'rules creation' }
MEDOrganizationValidator >> default [
	self validateTitle.
	self validateAcronym.
	self validateHomepageUrl.


	"We do not validate the email domains default. The adding of a new domain is protected by a validation rule. But we need to have
	the possibility to add some odd domains by the admins."
	"NOT! self validateEmailDomains"
]

{ #category : #'rules creation' }
MEDOrganizationValidator >> forEmailDomains [
	self validateEmailDomains
]

{ #category : #testing }
MEDOrganizationValidator >> isDomain: aDomain subDomainAnyOf: aDomainsCollection [
	"Checks if aDomain is a subdomain of any of the aDomainsCollection domains"
	^aDomainsCollection anySatisfy: [:eachDomain | aDomain endsWith: ('.', eachDomain)]
]

{ #category : #testing }
MEDOrganizationValidator >> isValidEmailDomains: aDomainCollection ofOrganization: anOrganization [
	| config inherited |
	
	anOrganization isRoot ifTrue: [^true].
	
	config := anOrganization configuration parent.
	inherited := config emailDomains.
	
	^aDomainCollection allSatisfy: [:eachLocalDomain |
		(self isDomain: eachLocalDomain subDomainAnyOf: inherited) or: [inherited includes: eachLocalDomain]]
]

{ #category : #'rules creation' }
MEDOrganizationValidator >> minimalForAdmins [
	"Minimal rules for some simplified backend admin input forms"
	self validateTitle
]

{ #category : #'rules creation' }
MEDOrganizationValidator >> validateAcronym [
	self validatePresence of: #acronym; named: #org:acronym.
]

{ #category : #'rules creation' }
MEDOrganizationValidator >> validateEmailDomains [
	| validationBlock |
	validationBlock := [
		| config |
		config := self object configuration.
		config hasLocalEmailDomains
			ifFalse: [true]
			ifTrue: [
				| locals |
				locals := config localEmailDomains.

				self isValidEmailDomains: locals ofOrganization: self object]].

	(self validateTrue: validationBlock)
		errorMessage: #organizationValidator:emailDomainsMustBeSubdomainsOfParent
]

{ #category : #'rules creation' }
MEDOrganizationValidator >> validateHomepageUrl [
	self validationGroup: [
		self validatePresence of: #homepageUrl; named: #org:homepage.
		(self validateTrue: [self db isWebsiteOnlineCached: self object homepageUrl])
			errorMessage: #org:validation:homepageIsNotOnline]
]

{ #category : #'rules creation' }
MEDOrganizationValidator >> validateTitle [
	self validatePresence of: #titleFieldData; named: #name
]
