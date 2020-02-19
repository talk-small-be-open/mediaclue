Class {
	#name : #MEDModelObject,
	#superclass : #WEBModelObject,
	#traits : 'TWEBVoyageMongoObject',
	#classTraits : 'TWEBVoyageMongoObject classTrait',
	#category : #'Mediaclue-Models'
}

{ #category : #validation }
MEDModelObject >> defaultValidator [
	^ MEDAlwaysValidValidator object: self
]

{ #category : #'submorphs-add/remove' }
MEDModelObject >> delete [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
MEDModelObject >> descriptionContainer [
	<magritteContainer>
	^ MEDMaContainer new
"		label: self class label;"
"		yourself"
]

{ #category : #validation }
MEDModelObject >> isValid [
	^ self validate isValid
]

{ #category : #validation }
MEDModelObject >> validate [
	^self validateWith: self defaultValidator
]

{ #category : #validation }
MEDModelObject >> validateWith: aValidator [
	^aValidator
		object: self;
		validationResult
]
