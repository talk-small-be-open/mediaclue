Class {
	#name : #WEBSystemCommand,
	#superclass : #WEBObject,
	#category : #'Webbase-Main-Misc'
}

{ #category : #convenience }
WEBSystemCommand class >> cp: aSource to: aTarget [
	self run: 'cp "', aSource, '" "', aTarget, '"'
]

{ #category : #command }
WEBSystemCommand class >> fetch: aCommandString [
	| shellOutput exitCode shell output |
	self logCommand: aCommandString.

	shell := PipeableOSProcess command: aCommandString.

	[
		output := shell outputAndError.
		shellOutput := output first.
		exitCode := output last.
	] ensure: [
		shell
			closePipes;
			close;
			release ].

	self logOutput: shellOutput.

	^shellOutput
]

{ #category : #convenience }
WEBSystemCommand class >> lns: aSource to: aTarget [
	self run: 'ln -fs "', aSource, '" "', aTarget, '"'
]

{ #category : #convenience }
WEBSystemCommand class >> lns: aSource to: aTarget inFolder: aFolderString [
	self run: 'cd "', aFolderString, '" && ln -fs "', aSource, '" "', aTarget, '"'
]

{ #category : #'as yet unclassified' }
WEBSystemCommand class >> logCommand: aString [
	Transcript
		show: ('System-Call: ', aString);
		cr.
]

{ #category : #'as yet unclassified' }
WEBSystemCommand class >> logOutput: aString [
	Transcript show: ('System-Call output: ', aString)
]

{ #category : #convenience }
WEBSystemCommand class >> mv: aSource to: aTarget [
	self run: 'mv "', aSource, '" "', aTarget, '"'
]

{ #category : #convenience }
WEBSystemCommand class >> rm: aSource [
	self run: 'rm -f "', aSource, '"'
]

{ #category : #command }
WEBSystemCommand class >> run: aCommandString [
	| pop |

	self logCommand: aCommandString.

	pop := OSProcess waitForCommand: aCommandString.
	^pop
]

{ #category : #command }
WEBSystemCommand class >> runAsync: aCommandString [
	self logCommand: aCommandString.
	^OSProcess command: aCommandString "Ist async und hinterlässt keine offenen Pipes!"
]
