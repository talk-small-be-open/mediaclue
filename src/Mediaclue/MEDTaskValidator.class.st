Class {
	#name : #MEDTaskValidator,
	#superclass : #MEDValidator,
	#category : #'Mediaclue-Validation'
}

{ #category : #'as yet unclassified' }
MEDTaskValidator >> default [
	self validatePresence of: #title named: 'task:title'.
"	self validatePresence of: #classification:topicTags named: 'task:topicTags'."
	self validatePresence of: #classification:activityTypeTags named: 'task:activityTypeTags'.
"	self validatePresence of: #classification:contextTags named: 'task:contextTags'."
"	self validatePresence of: #classification:grammarTopicTags named: 'task:grammarTopicTags'."
]
