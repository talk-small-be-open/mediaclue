Class {
	#name : #WEBMaDateComponent,
	#superclass : #MATextInputComponent,
	#traits : 'TWEBComponentHelpers',
	#classTraits : 'TWEBComponentHelpers classTrait',
	#category : #'Webbase-Magritte'
}

{ #category : #rendering }
WEBMaDateComponent >> renderInputOn: html [
	html dateInput5
		on: #string of: self
]
