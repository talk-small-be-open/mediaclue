Class {
	#name : #MEDConfiguration,
	#superclass : #MEDModelObject,
	#traits : 'TWEBConfiguration',
	#classTraits : 'TWEBConfiguration classTrait',
	#instVars : [
		'values'
	],
	#category : #'Mediaclue-Models'
}

{ #category : #initialization }
MEDConfiguration >> initialize [
	super initialize.
	values := IdentityDictionary new
]

{ #category : #accessing }
MEDConfiguration >> localDictionary [
	^values
]
