Class {
	#name : #GLHUserCatalogueV2,
	#superclass : #GLHUserCatalogue,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #import }
GLHUserCatalogueV2 class >> loadFromJson: aString [

	| catalogue dic |
	catalogue := self new.
	dic := (STONJSON fromString: aString) asDictionary.
	dic associationsDo: [ :assoc |
		| itsName itsUsername itsCommitNames itsId itsProjectIDs|
		itsName := assoc key.
		itsCommitNames := assoc value at: #foundNames.
		itsUsername := assoc value at: #username.
		itsId := assoc value at: #id.
		itsProjectIDs := assoc value at: #contributedProjects ifAbsent: [{}].

		catalogue
			addUser: (GLHUser new
					 id: itsId;
					 username: itsUsername;
					 name: itsName;
					 yourself)
			withNames: itsCommitNames
			withProjects: itsProjectIDs ].

	^ catalogue
]

{ #category : #'as yet unclassified' }
GLHUserCatalogueV2 class >> scrapeContributedProjectsForCommitAuthorsRelatedToUser: aGLHUser [
	"get all "

	| maxProjects itsProjects |
	self
		deprecated:
		'Use #scrapeWithImporter:ContributedProjectsForCommitAuthorsRelatedToUser: instead'
		on: '12 August 2024'
		in:
		'Pharo-11.0.0+build.726.sha.aece1b5473acf3830a0e082c1bc3a15d4ff3522b (64 Bit)'.

	aGLHUser id ifNil: [ ^ {  } asSet ].

	maxProjects := 10.

	GLHModelImporter current withCommitDiffs: false.
	itsProjects := aGLHUser contributedProjects ifEmpty: [
		               GLHModelImporter current
			               importContributedProjectsOfUser: aGLHUser ].

	itsProjects
		collect: [ :project |
			GLHModelImporter current importAndLoadLatestsCommitsOfProject:
				project ]
		from: 1
		to: (itsProjects size min: maxProjects).

	^ (aGLHUser commits collect: [ :commit | commit author_name ]) asSet
]

{ #category : #'as yet unclassified' }
GLHUserCatalogueV2 class >> scrapeWithImporter: anImporter contributedProjectsForCommitAuthorsRelatedToUser: aGLHUser [
	"get all "

	| maxProjects itsProjects |
	aGLHUser id ifNil: [ ^ {  } asSet ].

	maxProjects := 10.

	anImporter withCommitDiffs: false.
	itsProjects := aGLHUser contributedProjects ifEmpty: [
		               anImporter
			               importContributedProjectsOfUser: aGLHUser ].

	itsProjects
		collect: [ :project |
			anImporter importAndLoadLatestsCommitsOfProject:
				project ]
		from: 1
		to: (itsProjects size min: maxProjects).

	^ (aGLHUser commits collect: [ :commit | commit author_name ]) asSet
]

{ #category : #'as yet unclassified' }
GLHUserCatalogueV2 >> RSHeatMapLevenshtein [
	
		| builder|
	builder := RSHeatmap new.
	builder objectsX: self keys.
	builder objectsY: self keys.

	builder dataMatrix: self levenshteinMatrix.

	builder build.
	builder gradientLegend remove.
	builder canvas open
]

{ #category : #'as yet unclassified' }
GLHUserCatalogueV2 >> RSHeatMapLevenshteinTrimedAt: aBlockCondition [
	
		| builder matrice|
	builder := RSHeatmap new.
	builder objectsX: self keys.
	builder objectsY: self keys.
	

	matrice := self levenshteinMatrix.
	1 to: matrice size do: [ :i |
		1 to: (matrice at: i) size do: [ :j |
			|val|
			val := ((matrice at: i) at: j).
			(matrice at: i) at: j put: ( aBlockCondition value: val ).
			 ] ].
	
	
	builder dataMatrix: matrice.

	builder build.
	builder gradientLegend remove.
	builder canvas open
]

{ #category : #adding }
GLHUserCatalogueV2 >> addUser: aGLHUser [

	^ self at: aGLHUser name ifAbsentPut: [
		self initACatalogueEntryForUser: aGLHUser ]
]

{ #category : #adding }
GLHUserCatalogueV2 >> addUser: aGLHUser withName: name [

	^ self addUser: aGLHUser withNames: { name }
	
]

{ #category : #adding }
GLHUserCatalogueV2 >> addUser: aGLHUser withNames: aCollectionOfNames [
	| entry |
	entry := (self
		at: aGLHUser name
		ifAbsentPut: [ (self initACatalogueEntryForUser: aGLHUser ). ]).
	(entry  at: #names)  addAll: aCollectionOfNames. 
	^ entry
]

{ #category : #adding }
GLHUserCatalogueV2 >> addUser: aGLHUser withNames: aCollectionOfNames withProject: aProjectID [

	^ self addUser: aGLHUser withNames: aCollectionOfNames withProjects: { aProjectID }
]

{ #category : #adding }
GLHUserCatalogueV2 >> addUser: aGLHUser withNames: aCollectionOfNames withProjects: aCollectionOfProjectIDs [
	|entry|
	
	entry := self addUser: aGLHUser withNames: aCollectionOfNames.
	(entry at: #contributedProjects) addAll: aCollectionOfProjectIDs.
	^ entry. 
	
]

{ #category : #adding }
GLHUserCatalogueV2 >> addUser: aGLHUser withProject: aProjectID [
	
	^ self addUser: aGLHUser withProjects: {aProjectID}.
	
]

{ #category : #adding }
GLHUserCatalogueV2 >> addUser: aGLHUser withProjects: aCollectionOfProjectIDs [
	|entry|

	entry := self addUser: aGLHUser.
	(entry at: #contributedProjects) addAll: aCollectionOfProjectIDs.
	^ entry.
	
]

{ #category : #accessing }
GLHUserCatalogueV2 >> anImporter: aGLHModelImporter [
	anImporter := aGLHModelImporter
	
]

{ #category : #accessing }
GLHUserCatalogueV2 >> atId: anId [ 
	^ self detect: [ :entry |
		(entry at: #user) id =  anId ]
]

{ #category : #'as yet unclassified' }
GLHUserCatalogueV2 >> collectUsernames [

	| username2User |
	self ifEmpty: [ ^ {  } ].

	username2User := OrderedDictionary new.

	self associationsDo: [ :assoc |
		| user |
		user := assoc value at: #user .
		(assoc value at: #names) do: [ :username | username2User at: username put: user ] ].

	^ username2User
]

{ #category : #completion }
GLHUserCatalogueV2 >> completeAuthorNameOfUser: aGLHUser with: authorName [

	self
		deprecated: 'Use #addUser:withName: instead'
		on: '12 August 2024'
		in:
		'Pharo-11.0.0+build.726.sha.aece1b5473acf3830a0e082c1bc3a15d4ff3522b (64 Bit)'.

	self addUser: aGLHUser withName: authorName
]

{ #category : #completion }
GLHUserCatalogueV2 >> completeAuthorNameOfUser: aGLHUser withAll: authorNames [

	self
		deprecated: 'Use #addUser:withNames: instead'
		on: '12 August 2024'
		in:
		'Pharo-11.0.0+build.726.sha.aece1b5473acf3830a0e082c1bc3a15d4ff3522b (64 Bit)'.


	self addUser: aGLHUser withNames: authorNames
]

{ #category : #export }
GLHUserCatalogueV2 >> exportToJson [

	| tempDic |
	"	tempDic := self associations collect: [ :assoc |
					Dictionary new at: (assoc key name) put: ({
			           (#names -> assoc value asArray).
			           (#id -> assoc key id) } asDictionary); yourself ]."
	tempDic := Dictionary new.
	self associationsDo: [ :assoc |
		|entry user names projectIDs|
		entry := assoc value.
		user := entry at: #user.
		names := entry at: #names.
		projectIDs := entry at: #contributedProjects.
		tempDic
			at: assoc key put: {
					(#name -> user name).
					(#username -> user username).
					(#foundNames -> names asArray).
					(#contributedProjects -> projectIDs asArray).
					(#id -> user id) } asDictionary;
			yourself ].

	^ STONJSON toString: tempDic
]

{ #category : #fuse }
GLHUserCatalogueV2 >> fuse: mainUser with: subUser [ 
	self at: mainUser ifPresent: [ :entry |
		self at: subUser ifAbsent: [ ^ self ]. 
		(entry at: #names) addAll: (self at: subUser at: #names ).
		self removeKey: subUser.
		 ].
]

{ #category : #'instance creation' }
GLHUserCatalogueV2 >> initACatalogueEntryForUser: aGLHUser [.

^ Dictionary new
			at: #user put: aGLHUser;
			at: #names put: (Set new
					 add: aGLHUser username;
					 add: aGLHUser name;
					 yourself);
			at: #contributedProjects put: (Set new 
					addAll: (aGLHUser contributedProjects collect: #id); 
					yourself );
			yourself
]

{ #category : #initialization }
GLHUserCatalogueV2 >> initialize [

	anImporter := GLHModelImporter current.
]

{ #category : #'as yet unclassified' }
GLHUserCatalogueV2 >> levenshteinMatrix [ 
	| matrix|

	matrix := Array new: self keys size .
	1 to: matrix size do: [ :i | matrix at: i put: (Array new: self keys size) ]. 
	
	1 to: self keys size do: [ :i |
		1 to: self keys size do: [ :j |
			
			(matrix at: i) at: j put: ( (self keys at: i) absLevenshteinDistanceWith: (self keys at: j) ). 
			  ].
		  ].

	^ matrix.
]

{ #category : #'accessing - name' }
GLHUserCatalogueV2 >> names [
	^ self collect: [ :entry | entry at: #names ]
]

{ #category : #'as yet unclassified' }
GLHUserCatalogueV2 >> namesAt: aGLHUser [
	^ (self at: aGLHUser name) at: #names.
]

{ #category : #'as yet unclassified' }
GLHUserCatalogueV2 >> reImportAllUsers [
	"use it after a catalogue import from JSON"

	self associationsDo: [ :assoc |
		| user |
		user := assoc value at: #user.
		user := anImporter
			        ifNotNil: [
				        user id
					        ifNotNil: [ anImporter importUser: user id ]
					        ifNil: [ anImporter importUserByUsername: user username ] ]
			        ifNil: [user].
		assoc value at: #user put: user ]
]

{ #category : #'as yet unclassified' }
GLHUserCatalogueV2 >> reImportUser: aGLHUser [
	"use it after a catalogue import from JSON"
	|user|
	user := anImporter
			        ifNotNil: [
				        aGLHUser id
					        ifNotNil: [ anImporter importUser: aGLHUser id ]
					        ifNil: [ anImporter importUserByUsername: aGLHUser username ] ]
			        ifNil: [aGLHUser].
	
	
	self at: aGLHUser name at: #user put: (user).
	
]

{ #category : #scrape }
GLHUserCatalogueV2 >> scrapeAuthorNameForAllRealUsers [
	
	|listOfUsers|
	listOfUsers := self users select: [ :user | user id isNotNil ].
	listOfUsers do: [ :user | self scrapeAuthorNameForUser: user ].
]

{ #category : #'as yet unclassified' }
GLHUserCatalogueV2 >> scrapeAuthorNameForAllUsers [

	|listOfUsers|
	
	listOfUsers := self users. 
	listOfUsers do: [ :user | self scrapeAuthorNameForUser: user ]
]

{ #category : #'as yet unclassified' }
GLHUserCatalogueV2 >> scrapeAuthorNameForUser: aGLHUser [

	self addUser: aGLHUser withNames: (GLHUserCatalogue
			 scrapeWithImporter: anImporter
			 contributedProjectsForCommitAuthorsRelatedToUser: aGLHUser).
]

{ #category : #scrape }
GLHUserCatalogueV2 >> scrapeAuthorNamesForUsers: aUserCollection [ 
	
	aUserCollection do: [ :aGLHUser |
		self scrapeAuthorNameForUser: aGLHUser
		 ].
]

{ #category : #search }
GLHUserCatalogueV2 >> searchId: anId [ 
	^ self select: [ :entry | (entry at: #user) id = anId ].
]

{ #category : #completion }
GLHUserCatalogueV2 >> searchModelForAuthorNamesOfUser: aGLHUser [

	self addUser: aGLHUser withNames: 
		(aGLHUser commits collect: [ :c | c author_name ])
]

{ #category : #search }
GLHUserCatalogueV2 >> searchName: aName [

	^ self select: [ :entry |
		|collectionOfName|
		collectionOfName := entry at: #names.
		  (' ' join: collectionOfName) asLowercase includesSubstring:
			  aName asLowercase ]
]

{ #category : #search }
GLHUserCatalogueV2 >> searchUserWithName: aName [

	^ (self searchName: aName) users
]

{ #category : #accessing }
GLHUserCatalogueV2 >> userAt: aGLHUser [
	^ (self at: aGLHUser name) at: #user.  
]

{ #category : #accessing }
GLHUserCatalogueV2 >> users [

	^ self collect: [ :entry | entry at: #user ].
]
