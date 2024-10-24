Class {
	#name : 'GLHUserCatalogueV2Test',
	#superclass : 'TestCase',
	#instVars : [
		'catalogue'
	],
	#category : 'GitLabHealth-Model-Analysis-Tests',
	#package : 'GitLabHealth-Model-Analysis-Tests'
}

{ #category : 'running' }
GLHUserCatalogueV2Test >> setUp [

	catalogue := GLHUserCatalogueV2 new
]

{ #category : 'test' }
GLHUserCatalogueV2Test >> testAddSameUser [

	| user |

	user := GLHUser new
		        username: 'testUser';
		        name: 'test user';
		        yourself.

	catalogue addUser: user.
	catalogue addUser: user.

	self assert: catalogue size equals: 1
]

{ #category : 'test' }
GLHUserCatalogueV2Test >> testAddUser [

	| user  |


	user := GLHUser new
		        username: 'testUser';
		        name: 'test user';
		        yourself.

	catalogue addUser: user.

	self assert: catalogue size equals: 1
]

{ #category : 'test' }
GLHUserCatalogueV2Test >> testAddUserWithName [

	| user |


	user := GLHUser new
		        username: 'testUser';
		        name: 'test user';
		        yourself.

	catalogue addUser: user withName: 'toto'.

	self assert: (catalogue namesAt: user) size equals: 3.
	self assert: ((catalogue namesAt: user) includes: 'toto') equals: true.
	self assert: ((catalogue namesAt: user) includes: 'testUser') equals: true.
	self
		assert: ((catalogue namesAt: user) includes: 'test user')
		equals: true
]

{ #category : 'test' }
GLHUserCatalogueV2Test >> testAddUserWithNames [

	| user |
	user := GLHUser new
		        username: 'testUser';
		        name: 'test user';
		        yourself.

	catalogue addUser: user withNames: { 'toto'. 'tata'. 'titi' }.

	self assert: (catalogue namesAt: user) size equals: 5.
	self
		assert: ((catalogue namesAt: user) includes: 'toto')
		equals: true.
	self
		assert: ((catalogue namesAt: user) includes: 'tata')
		equals: true.
	self
		assert: ((catalogue namesAt: user) includes: 'titi')
		equals: true
]

{ #category : 'test' }
GLHUserCatalogueV2Test >> testAddUsers [

	| user1 user2  |


	user1 := GLHUser new
		         username: 'testUser1';
		         name: 'test user1';
		         yourself.

	user2 := GLHUser new
		         username: 'testUser2';
		         name: 'test user2';
		         yourself.

	catalogue addUser: user1.
	catalogue addUser: user2.

	self assert: catalogue size equals: 2
]

{ #category : 'test' }
GLHUserCatalogueV2Test >> testCollectUsernames [

	| user1 user2  res |


	user1 := GLHUser new
		         username: 'testUser1';
		         name: 'test user1';
		         yourself.

	user2 := GLHUser new
		         username: 'testUser2';
		         name: 'test user2';
		         yourself.

	catalogue addUser: user1.
	catalogue addUser: user2.


	res := catalogue collectUsernames.

	self assert: res size equals: 4.
	self assert: (res at: 'testUser1') equals: user1.
	self assert: (res at: 'testUser2') equals: user2.
	self assert: (res at: 'test user1') equals: user1.
	self assert: (res at: 'test user2') equals: user2
]

{ #category : 'tests' }
GLHUserCatalogueV2Test >> testExportAndLoad [

	| user json  res |
	user := GLHUser new
		        username: 'testUser';
		        name: 'test user';
				  contributedProjects: { GLHProject new id: 11 }; 
		        yourself.

	catalogue addUser: user.
	json := catalogue exportToJson.
	res := GLHUserCatalogueV2 loadFromJson: json.
	
	self assert: res size equals: catalogue size.
	self assert: ((res at: 'test user' at: #contributedProjects) includes: 11) equals: true.
	self assert: ((res at: 'test user' at: #names) includes: 'test user') equals: true.
	self assert: ((res at: 'test user' at: #names) includes: 'testUser') equals: true.
]

{ #category : 'test' }
GLHUserCatalogueV2Test >> testExportToJson [

	| user user2 json  res |
	user := GLHUser new
		        username: 'testUser';
		        name: 'test user';
				  contributedProjects: { GLHProject new id: 11  } ;
		        id: 1;
		        yourself.
	user2 := GLHUser new
		         username: 'testUser2';
		         name: 'test user2';
		         id: 2;
					contributedProjects: { GLHProject new id: 21 . GLHProject new id: 22 } ;
		         yourself.


	catalogue
		addUser: user;
		addUser: user2.
	json := catalogue exportToJson.

	res := STONJSON fromString: json.
	self assert: res size equals: catalogue size.
	self assert: ((res at: 'test user2') at: #foundNames) size equals: 2.
	self assert: ((res at: 'test user') at: #foundNames) size equals: 2.
	self assert: ((res at: 'test user') at: #contributedProjects) size equals: 1.
	self assert: ((res at: 'test user2') at: #contributedProjects) size equals: 2.
]

{ #category : 'test' }
GLHUserCatalogueV2Test >> testExportToJsonApostrophe [

	| user  json  res |
	user := GLHUser new
		        username: 'test User';
		        name: 'tes''t user';
				  contributedProjects: { GLHProject new id: 11  } ;
		        id: 1;
		        yourself.



	catalogue
		addUser: user.
	json := catalogue exportToJson.

	res := STONJSON fromString: json.
	self assert: res size equals: catalogue size.

	self assert: ((res at: 'tes''t user') at: #foundNames) size equals: 2.
	self assert: ((res at: 'tes''t user') at: #contributedProjects) size equals: 1.

]

{ #category : 'as yet unclassified' }
GLHUserCatalogueV2Test >> testLevenshteinDistanceBetweenBenoitAndNicolas [
	self assert: ('benoit' levenshteinDistanceWith: 'nicolas') equals: 6
	
]

{ #category : 'as yet unclassified' }
GLHUserCatalogueV2Test >> testLevenshteinDistanceBetweenExamenAndExaman [
	self assert: ('examen' levenshteinDistanceWith: 'examan') equals: 1
	
]

{ #category : 'as yet unclassified' }
GLHUserCatalogueV2Test >> testLevenshteinDistanceBetweenExamenAndExamen [
	self assert: ('examen' levenshteinDistanceWith: 'examen') equals: 0
	
]

{ #category : 'as yet unclassified' }
GLHUserCatalogueV2Test >> testLevenshteinDistanceBetweenNicolasAndNico [
	self assert: ('nicolas' levenshteinDistanceWith: 'nico') equals: 3
	
]

{ #category : 'tests' }
GLHUserCatalogueV2Test >> testLoadFromJson [

	| json res |
	json := '{"Benoit VERHAEGHE":{"id":1,"username":"Benoit.VERHAEGHE","foundNames":["Benoit VERHAEGHE","Benoit.VERHAEGHE","Benoît VERHAEGHE","Benoît Verhaeghe"],"name":"Benoit VERHAEGHE"},"HLAD Nicolas":{"id":2,"username":"Nicolas.HLAD","foundNames":["Nicolas Hlad","Nicolas.HLAD","HLAD Nicolas"],"name":"HLAD Nicolas"}}'.

	res := GLHUserCatalogue loadFromJson: json.
	self assert: res size equals: 2.

	self
		assert: (res searchUserWithName: 'Hlad') anyOne name
		equals: 'HLAD Nicolas'.
	self
		assert: (res searchUserWithName: 'VERHAEGHE') anyOne name
		equals: 'Benoit VERHAEGHE'.
]

{ #category : 'test' }
GLHUserCatalogueV2Test >> testNamesAt [

	| user  |


	user := GLHUser new
		        username: 'testUser';
		        name: 'test user';
		        yourself.

	catalogue addUser: user withName: 'toto'.


	self assert: (catalogue namesAt: user) size equals: 3.
	self
		assert: ((catalogue namesAt: user) includes: 'toto')
		equals: true.
	self
		assert: ((catalogue namesAt: user) includes: 'testUser')
		equals: true.
	self
		assert: ((catalogue namesAt: user) includes: 'test user')
		equals: true
]

{ #category : 'test' }
GLHUserCatalogueV2Test >> testNamesAtChangingUser [

	| user  |


	user := GLHUser new
		        name: 'test User';
		        yourself.

	user hash. " 114462615"

	catalogue addUser: user withName: 'toto'.

	user username: 'testUser'.

	user hash.

	self assert: (catalogue namesAt: user) size equals: 3.
	self
		assert: ((catalogue namesAt: user) includes: 'toto')
		equals: true.
	"his username has been added after so its not in the catalogue"
	self
		assert: ((catalogue namesAt: user) includes: 'testUser')
		equals: false.
	self
		assert: ((catalogue namesAt: user) includes: 'test User')
		equals: true
]
