Class {
	#name : #GLPHApi,
	#superclass : #GLHApi,
	#category : #'GitLabProjectHealth-Model-Importer'
}

{ #category : #commit }
GLPHApi >> commitsOfProject: anInteger forRefName: refName [

	self
		deprecated: 'Use #unknow instead'
		on: '12 April 2024'
		in:
		'Pharo-11.0.0+build.726.sha.aece1b5473acf3830a0e082c1bc3a15d4ff3522b (64 Bit)'.

	^ self
		  commitsOfProject: anInteger
		  forRefName: refName
		  since: nil
		  until: nil
		  path: nil
		  author: nil
		  all: nil
		  with_stats: nil
		  firstParent: nil
		  order: nil
		  trailers: nil
		  perPage: nil
		  page: nil
]

{ #category : #commits }
GLPHApi >> commitsOfProject: anInteger forRefName: refName since: since [

	self
		deprecated: 'Use #unknow instead'
		on: '12 April 2024'
		in:
		'Pharo-11.0.0+build.726.sha.aece1b5473acf3830a0e082c1bc3a15d4ff3522b (64 Bit)'.

	^ self
		  commitsOfProject: anInteger
		  forRefName: refName
		  since: since
		  until: nil
		  path: nil
		  author: nil
		  all: nil
		  with_stats: nil
		  firstParent: nil
		  order: nil
		  trailers: nil
		  perPage: nil
		  page: nil
]

{ #category : #commit }
GLPHApi >> commitsOfProject: aGLHProject forRefName: refName until: toDate [

	| newlyFoundCommit page |
	self
		deprecated: 'Use #unknow instead'
		on: '11 April 2024'
		in:
		'Pharo-11.0.0+build.726.sha.aece1b5473acf3830a0e082c1bc3a15d4ff3522b (64 Bit)'.
	page := 0.
	newlyFoundCommit := { true }.
	[ newlyFoundCommit isNotEmpty ] whileTrue: [
		| results parsedResults existingCommits |
		page := page + 1.
		('import commit page ' , page printString) recordInfo.
		results := self
			           commitsOfProject: aGLHProject id
			           forRefName: nil
			           since: nil
			           until: nil
			           path: nil
			           author: nil
			           all: nil
			           with_stats: nil
			           firstParent: nil
			           order: nil
			           trailers: nil
			           perPage: 100
			           page: page.
		parsedResults := self parseCommitsResult: results.
		existingCommits := aGLHProject mooseModel allWithType: GLHCommit.

		newlyFoundCommit := parsedResults reject: [ :commitParsed |
			                    (toDate isNil or: [
				                     commitParsed committed_date
				                     < toDate asDateAndTime ]) or: [
				                    existingCommits anySatisfy: [ :existingCommit |
					                    existingCommit id = commitParsed id ] ] ].
		aGLHProject mooseModel addAll: newlyFoundCommit.
		aGLHProject repository commits addAll: newlyFoundCommit ].
	self withCommitDiffs ifTrue: [
		aGLHProject repository commits do: [ :commit |
			self importDiffOfCommit: commit ] ]
]

{ #category : #'as yet unclassified' }
GLPHApi >> diffsMergeRequestOfProject: aProjectID withId: anMRiid [

	^ self client get:
		  self baseAPIUrl , '/projects/' , aProjectID printString
		  , '/merge_requests/' , anMRiid printString , '/diffs/'
]

{ #category : #initialization }
GLPHApi >> initialize [

	super initialize
]

{ #category : #'as yet unclassified' }
GLPHApi >> mergeRequestOfProject: aProjectID [
	
	^ self client get:
		  self baseAPIUrl , '/projects/' , aProjectID printString
		  , '/merge_requests/'
]

{ #category : #'as yet unclassified' }
GLPHApi >> mergeRequestOfProject: aProjectID withId: anMRiid [

	^ self client get:
		  self baseAPIUrl , '/projects/' , aProjectID printString
		  , '/merge_requests/' , anMRiid printString
]

{ #category : #accessing }
GLPHApi >> project: aProjectID [

	^ self client get:
		  self baseAPIUrl , '/projects/' , aProjectID printString
]

{ #category : #user }
GLPHApi >> usersSearchByUsername: aUserName [ 

	^ self client get: self baseAPIUrl , '/users?search=' , (aUserName replaceAllRegex: ' ' with:  '+').
]
