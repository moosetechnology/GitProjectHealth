Class {
	#name : #GLHUserCatalogue,
	#superclass : #Dictionary,
	#instVars : [
		'users',
		'anImporter'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #import }
GLHUserCatalogue class >> loadFromJson: aString [

	| catalogue dic |
	catalogue := self new.
	dic := (STONJSON fromString: aString) asDictionary.
	dic associationsDo: [ :assoc |
		| itsName itsUsername itsCommitNames itsId |
		itsName := assoc key.
		itsCommitNames := assoc value at: #foundNames.
		itsUsername := assoc value at: #username.
		itsId := assoc value at: #id.

		catalogue
			addUser: (GLHUser new
					 id: itsId;
					 username: itsUsername;
					 name: itsName;
					 yourself)
			withNames: itsCommitNames ].

	^ catalogue
]

{ #category : #'as yet unclassified' }
GLHUserCatalogue class >> scrapeContributedProjectsForCommitAuthorsRelatedToUser: aGLHUser [
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

	GitlabModelImporter current withCommitDiffs: false.
	itsProjects := aGLHUser contributedProjects ifEmpty: [
		               GitlabModelImporter current
			               importContributedProjectsOfUser: aGLHUser ].

	itsProjects
		collect: [ :project |
			GitlabModelImporter current importAndLoadLatestsCommitsOfProject:
				project ]
		from: 1
		to: (itsProjects size min: maxProjects).

	^ (aGLHUser commits collect: [ :commit | commit author_name ]) asSet
]

{ #category : #'as yet unclassified' }
GLHUserCatalogue class >> scrapeWithImporter: anImporter contributedProjectsForCommitAuthorsRelatedToUser: aGLHUser [
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

{ #category : #adding }
GLHUserCatalogue >> addUser: aGLHUser [

	self at: aGLHUser ifAbsentPut: [ Set new add: (aGLHUser username); add:  (aGLHUser name) ; yourself ]. 
]

{ #category : #adding }
GLHUserCatalogue >> addUser: aGLHUser withName: name [

	self
		at: aGLHUser
		ifPresent: [ :names | names add: name ]
		ifAbsentPut: [
			Set new
				add: aGLHUser username;
				add: aGLHUser name;
				add: name;
				yourself ]
]

{ #category : #adding }
GLHUserCatalogue >> addUser: aGLHUser withNames: aCollectionOfNames [

	self
		at: aGLHUser
		ifPresent: [ :names | names addAll: aCollectionOfNames ]
		ifAbsentPut: [
			Set new
				add: aGLHUser username;
				add: aGLHUser name;
				addAll: aCollectionOfNames;
				yourself ]
]

{ #category : #accessing }
GLHUserCatalogue >> anImporter: aGLHModelImporter [
	anImporter := aGLHModelImporter
	
]

{ #category : #accessing }
GLHUserCatalogue >> atWithId: anId [ 
	|res |
	res := self associations detect: [ :assoc | assoc key id = anId ] ifNone: [ nil ].
	^ res ifNotNil: [ res value ].
]

{ #category : #'as yet unclassified' }
GLHUserCatalogue >> collectUsernames [

	| username2User |
	self ifEmpty: [ ^ {  } ].

	username2User := OrderedDictionary new.

	self associationsDo: [ :assoc |
		| user |
		user := assoc key.
		assoc value do: [ :username | username2User at: username put: user ] ].

	^ username2User
]

{ #category : #completion }
GLHUserCatalogue >> completeAuthorNameOfUser: aGLHUser with: authorName [

	self
		deprecated: 'Use #addUser:withName: instead'
		on: '12 August 2024'
		in:
		'Pharo-11.0.0+build.726.sha.aece1b5473acf3830a0e082c1bc3a15d4ff3522b (64 Bit)'.

	self addUser: aGLHUser withName: authorName
]

{ #category : #completion }
GLHUserCatalogue >> completeAuthorNameOfUser: aGLHUser withAll: authorNames [

	self
		deprecated: 'Use #addUser:withNames: instead'
		on: '12 August 2024'
		in:
		'Pharo-11.0.0+build.726.sha.aece1b5473acf3830a0e082c1bc3a15d4ff3522b (64 Bit)'.


	self addUser: aGLHUser withNames: authorNames
]

{ #category : #export }
GLHUserCatalogue >> exportToJson [

	| tempDic |
	"	tempDic := self associations collect: [ :assoc |
					Dictionary new at: (assoc key name) put: ({
			           (#names -> assoc value asArray).
			           (#id -> assoc key id) } asDictionary); yourself ]."
	tempDic := Dictionary new.
	self associationsDo: [ :assoc |
		tempDic
			at: assoc key name put: {
					(#name -> assoc key name).
					(#username -> assoc key username).
					(#foundNames -> assoc value asArray).
					(#id -> assoc key id) } asDictionary;
			yourself ].

	^ STONJSON toString: tempDic
]

{ #category : #initialization }
GLHUserCatalogue >> initialize [

	anImporter := GitlabModelImporter importers anyOne.
]

{ #category : #'as yet unclassified' }
GLHUserCatalogue >> namesAt: aGLHUser [

	| assoc |
	assoc := self associationAt: aGLHUser.
	^ assoc value
]

{ #category : #'as yet unclassified' }
GLHUserCatalogue >> reImportAllUsers [
	"use it after a catalogue import from JSON"

	self associationsDo: [ :assoc |
		| user |
		user := assoc key.
		user := anImporter ifNotNil: [
					  user id ifNotNil: [ anImporter importUser: user id ] ifNil: [ anImporter importUserByUsername: user username ]
			         ] ifNil: user.
		assoc key: user ]
]

{ #category : #'as yet unclassified' }
GLHUserCatalogue >> scrapeAuthorNameForAllUsers [

	| currentUsers |
	currentUsers := self keys.
	currentUsers do: [ :key |
		(self at: key) addAll: (GLHUserCatalogue
				 scrapeWithImporter: anImporter  contributedProjectsForCommitAuthorsRelatedToUser: key) ]
]

{ #category : #'as yet unclassified' }
GLHUserCatalogue >> scrapeAuthorNameForUser: aGLHUser [

	| assoc |
	assoc := self associationAt: aGLHUser.
	assoc value addAll: (GLHUserCatalogue
			 scrapeWithImporter: anImporter
				 contributedProjectsForCommitAuthorsRelatedToUser: aGLHUser)
]

{ #category : #scrape }
GLHUserCatalogue >> scrapeAuthorNamesForUsers: aUserCollection [ 
	
	aUserCollection do: [ :aGLHUser |
		self scrapeAuthorNameForUser: aGLHUser
		 ].
]

{ #category : #completion }
GLHUserCatalogue >> searchModelForAuthorNamesOfUser: aGLHUser [ 
	|assoc|
	assoc := self associationAt: aGLHUser.
	assoc value addAll: (aGLHUser commits collect: [:c | c author_name]).
	
]

{ #category : #search }
GLHUserCatalogue >> searchName: aName [

	^ self select: [ :collectionOfName |
		  (' ' join: collectionOfName) asLowercase  includesSubstring: aName asLowercase ]
]

{ #category : #search }
GLHUserCatalogue >> searchUserWithName: aName [ 
	^ (self searchName: aName) keys.
]

{ #category : #accessing }
GLHUserCatalogue >> users [
	^ self keys
]
