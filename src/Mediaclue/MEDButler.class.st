Class {
	#name : #MEDButler,
	#superclass : #WEBButler,
	#category : #'Mediaclue-Misc'
}

{ #category : #initialization }
MEDButler >> initialize [
	super initialize.

	"OPTIMIZE. Ungefähr Anzahl nacheinander hochgeladene Dateien * Anzahl Vorschauen pro Datei"
	"(self globalConfiguration maxUploadSeriesFilesCount * 5)"

	offloader maxJobs: 5000
]
