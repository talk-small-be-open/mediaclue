Class {
	#name : #WEBTasks,
	#superclass : #WEBObject,
	#category : #'Webbase-Main-Core'
}

{ #category : #tasks }
WEBTasks class >> cleanupButler [
	self db butler cleanup
]

{ #category : #tasks }
WEBTasks class >> projectGarbageCollect [
	self pi defaultGarbageCollectorClass new gcAll
]

{ #category : #schedule }
WEBTasks class >> run5MinutelyTasks [
	self subclassResponsibility
]

{ #category : #schedule }
WEBTasks class >> runHourlyTasks [
	self subclassResponsibility
]

{ #category : #schedule }
WEBTasks class >> runNightlyTasks [
	self subclassResponsibility
]

{ #category : #tasks }
WEBTasks class >> saveAndQuitPharo [
"	self saveBackup."

	"Delay, so that the image date will be really newer. Startup will not restore from backup then"
"	(Delay forSeconds: 2) wait."
	
	"Fork, damit dem Task von aussen nicht die Verbindung abgeschnitten wird via curl"
	Smalltalk snapshot: true andQuit: true
]

{ #category : #tasks }
WEBTasks class >> saveSmalltalkImage [

	Smalltalk saveSession.

	"TODO: Make history copy of the image&sources file through file operations?"
]

{ #category : #tasks }
WEBTasks class >> smalltalkGarbageCollect [
	Smalltalk garbageCollect
]

{ #category : #tasks }
WEBTasks class >> wakeupButler [
	self db butler wakeup
]
