Class {
	#name : #MEDHelper,
	#superclass : #WEBHelper,
	#category : #'Mediaclue-Misc'
}

{ #category : #'as yet unclassified' }
MEDHelper class >> noValueLabel [
	^'[Keine Angabe]'
]

{ #category : #'as yet unclassified' }
MEDHelper class >> runPdftkInputs: aCollection commands: aString [
	| cmd |

"Aternative zu pdftk: https://github.com/qpdf/qpdf"

	cmd := String streamContents: [:s |
		s << 'pdftk '.
		aCollection do: [ :each |
			s << each.
			s space ].
		s << aString.
		s << ' dont_ask'.
	].
		
	WEBSystemCommand run: cmd.

]

{ #category : #'as yet unclassified' }
MEDHelper class >> runUnoconv: aParameterString [
	| success python |
	
	"brauche Standard System python"
	python := ''.
	
"	self isDevelopment
		ifTrue: [python := '/Applications/office/LibreOffice_Albus.app/Contents/MacOS/python ']."

	"Hinweis: -v ist nicht nötig, aber es gab komische Nebeneffekte mit deadlocks,
	und das hat vermutlich mit stdin zu tun, und meine Beobachtung war,
	dass es nie passierte, wenn mit -v gewisser Output da war.
	unset LD_... ist nötig für Libreoffice, es checkts sonst nicht"
	success := WEBSystemCommand run: 'unset LD_LIBRARY_PATH && ', (python, MEDHelper cliToolsFolder pathString, '/unoconv -v ', aParameterString).
	
	^ success
]

{ #category : #'as yet unclassified' }
MEDHelper class >> sourceIndicationCodes [
^ #(
unknown
owner
personal
school
free
)
]

{ #category : #'as yet unclassified' }
MEDHelper class >> sourceIndicationList [
	| map |
	map := self sourceIndicationMap.
	^ self sourceIndicationCodes collect: [ :each | each->(map at: each) ]
]

{ #category : #'as yet unclassified' }
MEDHelper class >> sourceIndicationMap [
^ {
nil->self noValueLabel.
'unknown'->'Unbekannt'.
'owner'->'Rechte beim Besitzer'.
'personal'->'Netzklau (nur für persönlichen Gebrauch)'.
'school'->'Schulcopyright (offiziell für Schulzwecke lizensiert)'.
'free'->'Frei (Creative Commons Licence)'.
} asD
]
