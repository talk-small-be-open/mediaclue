Class {
	#name : #WEBSystemCommand,
	#superclass : #WEBObject,
	#category : #'Webbase-Main-Misc'
}

{ #category : #convenience }
WEBSystemCommand class >> cp: aSource to: aTarget [
	self run: 'cp "', aSource, '" "', aTarget, '"'
]

{ #category : #'as yet unclassified' }
WEBSystemCommand class >> ensureNonBullshitShellCommand: aShellCommandString [

	aShellCommandString isByteString ifFalse: [
		WEBError signal: 'Cant execute non-8bit shell commands' ].
		
	"TODO: Check more than that?"
]

{ #category : #command }
WEBSystemCommand class >> fetch: aCommandString [
"	| shellOutput exitCode shell output cmd |
	self logCommand: aCommandString.

	cmd := aCommandString.
	
	self ensureNonBullshitShellCommand: cmd.

	OSSUnixSubprocess new
		shellCommand: cmd;
		redirectStdout;
		runAndWaitOnExitDo: [ :process :outString |
			shellOutput := WEBHelper fromUtf8: outString.
		].

	self logOutput: shellOutput.

	^shellOutput"
	
	self ensureNonBullshitShellCommand: aCommandString.

	self logCommand: aCommandString.

	^ self runShellCommand: aCommandString fetch: true args: nil cd: nil
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
	self logCommand: aString args: #() 
]

{ #category : #'as yet unclassified' }
WEBSystemCommand class >> logCommand: aString args: aCollection [
	^ self logCommand: aString args: aCollection in: nil
]

{ #category : #'as yet unclassified' }
WEBSystemCommand class >> logCommand: aString args: aCollection in: aDirPath [
	self db logInfo: (String streamContents: [ :s | 
		s << 'System-Call in '.
		s << ( aDirPath ifNil: [ 'CWD' ] ifNotNil: [ :o | o asString ] ).
		s << ': '.
		s << aString.
		aCollection ifNotEmpty: [ 
			s << ' with arguments: '.
			aCollection do: [ :each | s << each. s space ] ] ])
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

	^ self run: aCommandString args: #()
]

{ #category : #'as yet unclassified' }
WEBSystemCommand class >> run: aCommandString args: anArgsCollection [
	^ self run: aCommandString args: anArgsCollection cd: nil
]

{ #category : #'as yet unclassified' }
WEBSystemCommand class >> run: aCommandString args: anArgsCollection cd: aPathString [

	self ensureNonBullshitShellCommand: aCommandString.

	self logCommand: aCommandString args: anArgsCollection in: aPathString.

	^ self runShellCommand: aCommandString fetch: false args: anArgsCollection cd: aPathString
]

{ #category : #command }
WEBSystemCommand class >> runAsync: aCommandString [
"	| cmd |

	self logCommand: aCommandString.
	
	cmd := aCommandString.

	self ensureNonBullshitShellCommand: cmd.
	
	OSSUnixSubprocess new
		shellCommand: cmd;
		run"
		
	self ensureNonBullshitShellCommand: aCommandString.

	self logCommand: aCommandString.
	
	self runAsyncShellCommand: aCommandString args: nil cd: nil
]

{ #category : #'as yet unclassified' }
WEBSystemCommand class >> runAsyncShellCommand: aShellCommandString args: aCollectionOfStrings cd: aWorkingDirString [
	| wrapperScriptPath cmd cd args |

	cmd := aShellCommandString.
	cd := aWorkingDirString ifBlank: [ '.' ].
	args := aCollectionOfStrings ifNil: [ #() ] ifNotNil: [ :c | c copyWithoutBlanks ].

	wrapperScriptPath := (WEBHelper cliToolsFolder / 'execute-clean-subprocess.sh') pathString.

	OSSUnixSubprocess new
		command: wrapperScriptPath;
		arguments: ({ cd. '/dev/null'. cmd. } copyWithAll: args);
		run
]

{ #category : #'as yet unclassified' }
WEBSystemCommand class >> runShellCommand: aShellCommandString fetch: aFetchBoolean args: aCollectionOfStrings cd: aWorkingDirString [
	| shellOutput wrapperScriptPath cmd tmpFile cd args subprocess |

"	cmd := ALHelper asUtf8: aShellCommandString."
	cmd := aShellCommandString.
	cd := aWorkingDirString ifBlank: [ '.' ].
	args := aCollectionOfStrings ifNil: [ #() ] ifNotNil: [ :c | c copyWithoutBlanks ].
	
	tmpFile := aFetchBoolean ifTrue: [ WEBTempFile new filePath ] ifFalse: [ '/dev/null' ].

	wrapperScriptPath := (WEBHelper cliToolsFolder / 'execute-clean-subprocess.sh') pathString.

	"REMARK! Since we had sporadic problems with posix_spawn bad file descriptor errors,
	we do not rely on stdout redirect, but simple file writes via the executeCleanSubprocess.sh script."

	subprocess := OSSUnixSubprocess new
		command: wrapperScriptPath;
		arguments: ({ cd. tmpFile. cmd. } copyWithAll: args);
		"redirectStdout;"
		runAndWait;
		yourself.
		
"		OnExitDo: [ :process :outString |"
"				shellOutput := outString."

"	shellOutput := ALHelper fromUtf8: (GRPlatform contentsOfFile: '/tmp/execute.out' binary: false)."

	aFetchBoolean ifTrue: [
		shellOutput := GRPlatform current contentsOfFile: tmpFile binary: false.
		^ shellOutput
	] ifFalse: [ ^ subprocess isSuccess ].
	
	"TODO: remove tmpFile"

	"fallback"
	^ nil
]
