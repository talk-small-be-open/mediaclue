Class {
	#name : #MEDMediaSet,
	#superclass : #MEDMediaCollection,
	#traits : 'TMEDTaggable',
	#classTraits : 'TMEDTaggable classTrait',
	#instVars : [
		'owner',
		'description',
		'sortPath',
		'rating',
		'permissionType',
		'tagList',
		'createdAt',
		'readPermittedAuthorities',
		'writePermittedAuthorities'
	],
	#category : #'Mediaclue-Models'
}

{ #category : #testing }
MEDMediaSet class >> isVoyageRoot [
	^true
]

{ #category : #accessing }
MEDMediaSet >> createdAt [
	^ createdAt
]

{ #category : #accessing }
MEDMediaSet >> createdAt: anObject [
	createdAt := anObject
]

{ #category : #'accessing-defaults' }
MEDMediaSet >> defaultValidator [
	^ MEDMediaSetValidator object: self
]

{ #category : #'submorphs-add/remove' }
MEDMediaSet >> delete [
	self remove
]

{ #category : #accessing }
MEDMediaSet >> description [
	^ description
]

{ #category : #accessing }
MEDMediaSet >> description: anObject [
	description := anObject
]

{ #category : #magritte }
MEDMediaSet >> descriptionCreatedAt [
	<magritteDescription>
	^ WEBMaDateAndTimeDescription new
		accessor: #createdAt;
		label: 'Erstellt am';
		beReadonly;
		yourself
]

{ #category : #magritte }
MEDMediaSet >> descriptionDescription [
	<magritteDescription>
	^ MAMemoDescription new
		accessor: #description;
		label: 'Beschreibung';
		lineCount: 1;
		yourself
]

{ #category : #magritte }
MEDMediaSet >> descriptionOwner [
	<magritteDescription>
	^ MEDMaSingleOptionDescription new
		optionsBlock: [ self db users ];
		accessor: #owner;
		label: 'Besitzer';
		beRequired;
		yourself
]

{ #category : #magritte }
MEDMediaSet >> descriptionSortPath [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #sortPath;
		label: 'Einsortierung';
		yourself
]

{ #category : #'as yet unclassified' }
MEDMediaSet >> findAllMediaForUser: aUser [

]

{ #category : #'as yet unclassified' }
MEDMediaSet >> findMediaForUser: aUser query: aSearchQuery [

]

{ #category : #'as yet unclassified' }
MEDMediaSet >> generatePdfForUser: aUser [
"  def to_pdf_for_user(user)
    filename = File.join RAILS_ROOT, 'tmp', #{File.sanitize_filename(name)}_ID#{id}.pdf
#    files = self.images_for_user_as_viewer(user).collect { |image| image.image_thumbnail(:pdfslideshow).public_filename }
#    PdfSlideShowController.render_pdf :filename => filename, :image_files => files, :name => self.name, :desc => self.desc
     ::PdfSlideShowController.render_pdf :filename => filename, 
                                     :media_set => self,
                                     :images => self.images_for_user_as_viewer(user)
#                                    :name => self.name, 
#                                    :desc => self.desc, 
    filename
  end

"
]

{ #category : #'as yet unclassified' }
MEDMediaSet >> generateZipFileForUser: aUser [
"  def to_zip_for_user(user)
    filename = File.join RAILS_ROOT, 'tmp', #{File.sanitize_filename(name)}_ID#{id}.zip

    File.delete filename if File.exists? filename
    Zip::ZipFile.open(filename, Zip::ZipFile::CREATE) do |zipfile|
      self.media_for_user_as_viewer(user).each_with_index do |medium, idx|
        filename_parts = [idx.to_s.rjust(3,'0')]
        
        zipfile.add #{idx.to_s.rjust(3,'0')}_#{medium.pretty_filename}, medium.full_filename
      end
    end

    filename
  end
"
]

{ #category : #accessing }
MEDMediaSet >> hasSortPath [
	^ sortPath notBlank
]

{ #category : #'as yet unclassified' }
MEDMediaSet >> imagesForUserAsViewer: aUser [
	^self images select: [ :each | each canView: aUser ]
]

{ #category : #initialization }
MEDMediaSet >> initialize [
	super initialize.
	
	readPermittedAuthorities := OrderedCollection new.
	writePermittedAuthorities := OrderedCollection new.
"	tagList := OrderedCollection new."
	createdAt := DateAndTime now.
]

{ #category : #initialization }
MEDMediaSet >> initializeDefaultValues [
	super initializeDefaultValues.
	
	tagList ifNil: [ tagList := Set new ].	

]

{ #category : #accessing }
MEDMediaSet >> owner [
	^ owner
]

{ #category : #accessing }
MEDMediaSet >> owner: anObject [
	owner := anObject
]

{ #category : #accessing }
MEDMediaSet >> permissionType [
	^ permissionType ifBlank: [ #owner ]
]

{ #category : #accessing }
MEDMediaSet >> permissionType: anObject [
	permissionType := anObject
]

{ #category : #copying }
MEDMediaSet >> postCopy [
	super postCopy.

	tagList := tagList copy.
	readPermittedAuthorities := readPermittedAuthorities copy.
	writePermittedAuthorities := writePermittedAuthorities copy.
]

{ #category : #'as yet unclassified' }
MEDMediaSet >> publicUrl [
	self isPublic ifFalse: [ ^nil ].

	^ 'https://', self globalConfiguration webDomain, '/galleries/', self uuidString, '/', self publicUrlName
]

{ #category : #'as yet unclassified' }
MEDMediaSet >> publicUrlName [
	^ (MEDHelper urlnameFor: self title), '.html'
]

{ #category : #accessing }
MEDMediaSet >> rating [
	^ rating
]

{ #category : #accessing }
MEDMediaSet >> rating: anObject [
	rating := anObject
]

{ #category : #'as yet unclassified' }
MEDMediaSet >> readPermittedAuthorities [
	^ readPermittedAuthorities
]

{ #category : #accessing }
MEDMediaSet >> readPermittedAuthorities: anObject [
	readPermittedAuthorities := anObject
]

{ #category : #accessing }
MEDMediaSet >> sortPath [
	^ sortPath
]

{ #category : #accessing }
MEDMediaSet >> sortPath: anObject [
	sortPath := anObject
]

{ #category : #accessing }
MEDMediaSet >> tagList [
	^tagList
]

{ #category : #accessing }
MEDMediaSet >> tagList: aCollection [
	tagList := aCollection
]

{ #category : #'as yet unclassified' }
MEDMediaSet >> writePermittedAuthorities [
	^ writePermittedAuthorities
]

{ #category : #accessing }
MEDMediaSet >> writePermittedAuthorities: anObject [
	writePermittedAuthorities := anObject
]
