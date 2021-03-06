Class {
	#name : #MEDDataMigrator,
	#superclass : #WEBDataMigrator,
	#category : #'Mediaclue-Database'
}

{ #category : #actions }
MEDDataMigrator class >> afterMigrate [
	super afterMigrate.
	VORepository current reset.
]

{ #category : #migrations }
MEDDataMigrator >> m001AddIdentityProvider [
	MEDDatabase current initializeDefaultValues
]

{ #category : #migrations }
MEDDataMigrator >> m002RenewIdentityProvider [
	MEDDatabase current instVarNamed: 'identityProvider' put: nil.
	MEDDatabase current initializeDefaultValues
]
