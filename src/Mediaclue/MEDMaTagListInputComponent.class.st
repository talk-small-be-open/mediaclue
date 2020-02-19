Class {
	#name : #MEDMaTagListInputComponent,
	#superclass : #MATextInputComponent,
	#traits : 'TWEBComponentHelpers',
	#classTraits : 'TWEBComponentHelpers classTrait',
	#instVars : [
		'suggesterTagId',
		'topTags',
		'myTopTags',
		'subjectTags',
		'restTags'
	],
	#category : #'Mediaclue-Magritte'
}

{ #category : #'instance creation' }
MEDMaTagListInputComponent class >> memento: aMemento description: aDescription parent: aComponent [
	"Hm, vermutlich kleiner Bug in Seaside. Spätes init ist nötig."
	^ self basicNew
		setMemento: aMemento;
		setDescription: aDescription;
		setParent: aComponent;
		initialize;
		yourself
]

{ #category : #initialization }
MEDMaTagListInputComponent >> initialize [
	super initialize.
	
	subjectTags := self session schoolSubjectTags.
	topTags := self session topTags.
	myTopTags := self session myTopTags.
	restTags := self model tags copyWithoutAll: (subjectTags, topTags, myTopTags).

	self addContainerDiv
]

{ #category : #rendering }
MEDMaTagListInputComponent >> renderInputOn: html [
	suggesterTagId := html nextId asSymbol.
	
	html textArea
		class: 'tagList';
		id: self id;
"		onFocus: ((html jQuery: suggesterTagId) show);
		onBlur: (((html jQuery: suggesterTagId) delay: 200) hide: 10);"
		on: #string of: self.

	self renderSelectizeJsOn: html.

"	html div class: 'suggestedTags'; id: suggesterTagId; with: [
		self renderSuggestedTagsOn: html ]"
]

{ #category : #rendering }
MEDMaTagListInputComponent >> renderSelectizeJsOn: html [
	| options optgroups |
	options := OrderedCollection new.
	optgroups := {
		{ 'value'->'subject'. 'label'->'Fach-Schlagworte' } asD.
		{ 'value'->'top'. 'label'->'Top-Schlagworte' } asD.
		{ 'value'->'mytop'. 'label'->'Meine Top-Schlagworte' } asD.
		{ 'value'->'rest'. 'label'->'Weitere' } asD.
	}.
	
	subjectTags do: [ :each |
		options add: { 'optgroup'->'subject'. 'value'->(each title). 'text'->(each displayName) } asD
	].
	topTags do: [ :each |
		options add: { 'optgroup'->'top'. 'value'->(each title). 'text'->(each displayName) } asD
	].
	myTopTags do: [ :each |
		options add: { 'optgroup'->'mytop'. 'value'->(each title). 'text'->(each displayName) } asD
	].

	restTags do: [ :each |
		options add: { 'optgroup'->'rest'. 'value'->(each title). 'text'->(each displayName) } asD
	].

	html script: '
$("#', self id, '").selectize({
	plugins: ["remove_button"],
	optgroups: ', optgroups asJavascript,',
	options: ', options asJavascript,',
	delimiter: ",",
	persist: false,
	createOnBlur: true,
	hideSelected: false,
	addPrecedence: false,
	create: function(input) {
		return {
			value: input,
			text: input,
			optgroup: "rest",
		}
	}
});
'
]

{ #category : #rendering }
MEDMaTagListInputComponent >> renderSuggestedTagsOn: html [

	html strong: 'Fach-Schlagworte: '.
	self renderTags: subjectTags on: html.

	html strong: ' Top-Schlagworte: '.
	self renderTags: topTags on: html.

	html strong: ' Meine Top-Schlagworte: '.
	self renderTags: myTopTags on: html.
]

{ #category : #rendering }
MEDMaTagListInputComponent >> renderTags: aCollection on: html [
	aCollection
		do: [:each |
			html anchor
				class: 'actionClick';
				url: '#';
				onClick: 'appendToTagList("', self id, '", "', each title,'"); $("#', suggesterTagId, '").clearQueue(); return false';
				with: each displayName]
		separatedBy: [html text: ', ']
]
