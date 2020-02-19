Class {
	#name : #BaselineOfMediaclue,
	#superclass : #BaselineOf,
	#category : #BaselineOfMediaclue
}

{ #category : #baselines }
BaselineOfMediaclue >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
"		spec preLoadDoIt: #'preload:package:'."
		spec blessing: #'baseline'.
		spec 
			baseline: 'Webbase' with: [
				spec
					repository: 'github://talk-small-be-open/webbase';
					loads: #(default mongo magritte ldap) ];
			project: 'Webbase-Dev'
			copyFrom: 'Webbase'
			with: [ spec loads: #(default mongo magritte ldap devtools) ].

"			baseline: 'Magritte' with: [
				spec
					repository: 'github://magritte-metamodel/magritte:v3.6'; 
					loads: #(default Seaside) ]."

"			project: 'XMLParserHTML' with: [
				spec
					className: #ConfigurationOfXMLParserHTML;
					versionString: #'stable';
					repository: 'http://smalltalkhub.com/mc/Pharo/MetaRepoForPharo70/main/' ];"
"			baseline: 'PetitParser' with: [
				spec
					repository: 'github://moosetechnology/PetitParser/src';
					loads: #('Minimal')];"

"			project: 'PetitParser-Dev'
			copyFrom: 'PetitParser'
			with: [ spec loads: #('ParserIDE') ];"

"			baseline: 'Parasol' with: [
				spec
					repository: 'github://SeasideSt/Parasol/repository';
					loads: #('core')]."
	].

	spec for: #pharo do: [
		spec package: #Mediaclue with: [
			spec
				repository: 'github://talk-small-be-open/mediaclue';
				requires: #('Webbase')].

		spec group: 'default' with: #(#Mediaclue).
		spec group: 'devtools' with: #(#'Webbase-Dev').
	]
]
