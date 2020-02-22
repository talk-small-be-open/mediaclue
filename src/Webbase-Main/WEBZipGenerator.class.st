Class {
	#name : #WEBZipGenerator,
	#superclass : #WEBObject,
	#instVars : [
		'files'
	],
	#category : #'Webbase-Main-Misc'
}

{ #category : #'as yet unclassified' }
WEBZipGenerator class >> generateFromMedias: aCollection named: aString [
	| instance filePath |
	instance := self new.

	aCollection do: [ :each |
		instance addFile: each fileReference].
	
	filePath := instance generate.
	
	^ (WEBLocalFileReference fromPath: filePath)
		contentType: 'application/zip';
		title: aString;
		yourself
]

{ #category : #adding }
WEBZipGenerator >> addFile: aWebLocalFileReference [
	files add: aWebLocalFileReference
]

{ #category : #accessing }
WEBZipGenerator >> files [
	^files
]

{ #category : #'as yet unclassified' }
WEBZipGenerator >> generate [
	| tempFile shellCommandString |
	tempFile := WEBTempFile zipForXSendfile.

	shellCommandString := String streamContents: [ :s |
		s << 'cd '.
		s << tempFile directory.
		s space.
		s << ' && '.
		s << 'zip -9 --junk-paths '.
		s << (tempFile filePath).
		s space.

		self files withIndexDo: [ :eachFile :eachIndex |
			| prefix symlinkName |
			prefix := (eachIndex printPaddedWith: $0 to: 4), ' '.
			symlinkName := prefix, eachFile title.
				
			"symlink mit natürlichem Namen erstellen"
			WEBSystemCommand run: 'ln -s "', eachFile filePath, '" "', (tempFile directory, '/', symlinkName), '"'.
				
			s << '"'.
			s << symlinkName.
			s << '"'.
			s space.
		]
	].
	
	WEBSystemCommand run: shellCommandString.
	
	^tempFile filePath
]

{ #category : #initialization }
WEBZipGenerator >> initialize [
	super initialize.
	
	files := OrderedCollection new
]
