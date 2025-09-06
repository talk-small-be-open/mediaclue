Class {
	#name : #MEDExiftool,
	#superclass : #MEDObject,
	#traits : 'TMEDVisitor',
	#classTraits : 'TMEDVisitor classTrait',
	#category : #'Mediaclue-Misc'
}

{ #category : #model }
MEDExiftool >> read: aMedia [
	^ aMedia acceptVisitor: self
]

{ #category : #visiting }
MEDExiftool >> runOn: aMedia options: aString [
	| cmd output |
	cmd := 'exiftool ', aString, ' -json "', aMedia fileReference filePath,'"'.

	"Liefert ein JSON Array, pro Bild ein Dict."
	output := WEBSystemCommand fetch: cmd.
	
"	^ (WAJsonParser parse: (WEBHelper fromUtf8: output)) first"
	^ (WAJsonParser parse: output) first
]

{ #category : #visiting }
MEDExiftool >> visitImageAsset: aMedia [
	^ self runOn: aMedia options: ''
]

{ #category : #visiting }
MEDExiftool >> visitMediaAsset: aMedia [
	^ self runOn: aMedia options: ''
]
