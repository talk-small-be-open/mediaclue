Class {
	#name : #MEDMaTagListInputComponent,
	#superclass : #MATextInputComponent,
	#traits : 'TWEBComponentHelpers',
	#classTraits : 'TWEBComponentHelpers classTrait',
	#instVars : [
		'suggesterTagId',
		'topTags',
		'myTopTags',
		'mainTags',
		'mainTagGroups',
		'allTags'
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
	
	mainTagGroups := self session mainTagGroups.

	mainTags := self session mainTags.
	topTags := self session topTags.
	myTopTags := self session myTopTags.

	allTags := Set new.
	allTags
		addAll: self model tags;
		addAll: mainTags;
		addAll: topTags;
		addAll: myTopTags.
		
	mainTagGroups do: [ :each |
		allTags addAll: each tags ].
	
	allTags := allTags sortedBySortKey.

"	restTags := self model tags copyWithoutAll: (subjectTags, topTags, myTopTags)."

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
	| options optgroups restTags |
	
	restTags := self restTags.
	
	options := OrderedCollection new.
	optgroups := {
		{ 'value'->'main'. 'label'->'Haupt-Schlagworte' } asD.
		{ 'value'->'top'. 'label'->'Top-Schlagworte' } asD.
		{ 'value'->'mytop'. 'label'->'Meine Top-Schlagworte' } asD.
		{ 'value'->'rest'. 'label'->'Weitere' } asD.
	} asOrderedCollection.

	mainTagGroups do: [ :each |
		| groupName |
		groupName := 'mainGroup', each uuid.
		optgroups add: { 'value'->groupName. 'label'->('Kontext ', each title) } asD.
"		each tags do: [ :eachTag |
			options add: { 'optgroup'->groupName. 'value'->(eachTag title). 'text'->eachTag displayName } asD ]."
	].

"	mainTags do: [ :each |
		options add: { 'optgroup'->'main'. 'value'->(each title). 'text'->(each displayName) } asD
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
"

	allTags do: [ :each |
		| groups |
		groups := Array streamContents: [ :a |
			( mainTags includes: each ) ifTrue: [ a nextPut: 'main' ].
			( topTags includes: each ) ifTrue: [ a nextPut: 'top' ].
			( myTopTags includes: each ) ifTrue: [ a nextPut: 'mytop' ].
			( restTags includes: each ) ifTrue: [ a nextPut: 'rest' ].
	
			mainTagGroups do: [ :eachMtg |
				| groupName |
				groupName := 'mainGroup', eachMtg uuid.
				( eachMtg hasTag: each ) ifTrue: [ a nextPut: groupName ].
		]].
	
		options add: { 'optgroup'->groups. 'value'->(each title). 'text'->(each displayName) } asD.
	].


	html script: '
$("#', self id, '").selectize({
	plugins: ["remove_button",
		{name: "optgroup_columns", options: {equalizeWidth: false, equalizeHeight: false}}
	],
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

	html strong: 'Haupt-Schlagworte: '.
	self renderTags: mainTags on: html.

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

{ #category : #initialization }
MEDMaTagListInputComponent >> restTags [
	^ self model tags copyWithoutAll: (mainTags, topTags, myTopTags).

]
