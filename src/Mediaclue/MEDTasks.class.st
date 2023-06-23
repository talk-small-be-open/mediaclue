Class {
	#name : #MEDTasks,
	#superclass : #WEBTasks,
	#category : #'Mediaclue-Misc'
}

{ #category : #'as yet unclassified' }
MEDTasks class >> cleanupEmptyFolders [
	"TODO: Mit find alle leeren Ordner in Original und Preview Folders löschen
	TODO: Put in garbageCollector Class"
]

{ #category : #initialization }
MEDTasks class >> resetVoyageDb [
	VORepository current reset
]

{ #category : #schedule }
MEDTasks class >> run5MinutelyTasks [
	self wakeupButler.
	
	self smalltalkGarbageCollect
]

{ #category : #schedule }
MEDTasks class >> runHourlyTasks [
	self cleanupButler.

	self isProductionOrAlike ifTrue: [
		"asnyc, so that the calling process from cron is not cut off without reply"
		[
			(Delay forSeconds: 2) wait.
			self saveSmalltalkImage.
		] fork.
	].
]

{ #category : #schedule }
MEDTasks class >> runNightlyTasks [
"	self cleanupButler."
	MEDApplicationManager enableAutomation.
	MEDApplicationManager ensureUnoconvServerIsRunning.
	
	self isProductionOrAlike ifTrue: [
		"Dies sucht die User im LDAP, welche noch keiner LDAP-UID zugewiesen sind"
		WEBLdapUserMatchWizard new autoLinkWithLdap.
		
		"Dies erstellt auch User aus den Gruppen, welche noch nicht vorhanden sind"
		MEDLdapUserGroupSyncer new sync ].
	
	self cleanupEmptyFolders.

	self projectGarbageCollect.

	self resetVoyageDb
]
