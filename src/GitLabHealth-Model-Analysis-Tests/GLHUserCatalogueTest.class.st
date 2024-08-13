"
A GLHUserCatalogueTest is a test class for testing the behavior of GLHUserCatalogue
"
Class {
	#name : #GLHUserCatalogueTest,
	#superclass : #TestCase,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #test }
GLHUserCatalogueTest >> testAddSameUser [

	| user catalogue |
	catalogue := GLHUserCatalogue new.

	user := GLHUser new
		        username: 'testUser';
		        name: 'test user';
		        yourself.

	catalogue addUser: user.
	catalogue addUser: user.

	self assert: catalogue size equals: 1
]

{ #category : #test }
GLHUserCatalogueTest >> testAddUser [

	| user catalogue |
	catalogue := GLHUserCatalogue new.

	user := GLHUser new
		        username: 'testUser';
		        name: 'test user';
		        yourself.

	catalogue addUser: user. 
	
	self assert: catalogue size equals:  1.
]

{ #category : #test }
GLHUserCatalogueTest >> testAddUserWithName [

	| user catalogue |
	catalogue := GLHUserCatalogue new.

	user := GLHUser new
		        username: 'testUser';
		        name: 'test user';
		        yourself.

	catalogue addUser: user withName: 'toto'.

	self assert: (catalogue at: user) size equals: 3.
	self assert: ((catalogue at: user) includes: 'toto') equals: true.
	self assert: ((catalogue at: user) includes: 'testUser') equals: true.
	self
		assert: ((catalogue at: user) includes: 'test user')
		equals: true
]

{ #category : #test }
GLHUserCatalogueTest >> testAddUserWithNames [

	
	| user catalogue |
	catalogue := GLHUserCatalogue new.

	user := GLHUser new
		        username: 'testUser';
		        name: 'test user';
		        yourself.

	catalogue addUser: user withNames: {'toto' . 'tata' . 'titi'}.
 
	self assert: (catalogue at: user) size equals: 5.
	self assert: ((catalogue at: user) includes: 'toto') equals: true.
	self assert: ((catalogue at: user) includes: 'tata') equals: true.
	self
		assert: ((catalogue at: user) includes: 'titi')
		equals: true
]

{ #category : #test }
GLHUserCatalogueTest >> testAddUsers [

	| user1 user2 catalogue |
	catalogue := GLHUserCatalogue new.

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

{ #category : #test }
GLHUserCatalogueTest >> testCollectUsernames [

	| user1 user2 catalogue res |
	catalogue := GLHUserCatalogue new.

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
	 self assert: (res at: 'testUser1')  equals: user1.
 self assert: (res at: 'testUser2')  equals: user2.	
 self assert: (res at: 'test user1')  equals: user1.
 self assert: (res at: 'test user2')  equals: user2.


]

{ #category : #tests }
GLHUserCatalogueTest >> testExportAndLoad [

	| user json catalogue res |
	user := GLHUser new
		        username: 'testUser';
		        name: 'test user';
		        yourself.
	catalogue := GLHUserCatalogue new.

	catalogue addUser: user.
	json := catalogue exportToJson.

	res := GLHUserCatalogue loadFromJson: json.
	self assert: res size equals: catalogue size
]

{ #category : #test }
GLHUserCatalogueTest >> testExportToJson [

	| user user2 json catalogue res |
	user := GLHUser new
		        username: 'testUser';
		        name: 'test user';
				id: 1;
		        yourself.
	user2  := GLHUser new
		        username: 'testUser2';
		        name: 'test user2';
		id: 2;
		        yourself.
	catalogue := GLHUserCatalogue new.

	catalogue addUser: user; addUser: user2.
	json := catalogue exportToJson.

	res := (STONJSON fromString: json).
	self assert: res size equals: catalogue size.
	self assert: ((res at: 'test user2') at: #foundNames) size equals: 2 .
	self assert: ((res at: 'test user') at: #foundNames) size equals: 2 .
	
]

{ #category : #tests }
GLHUserCatalogueTest >> testLoadFromJson [

	| json res |
	json := '{"Benoit VERHAEGHE":{"id":1,"username":"Benoit.VERHAEGHE","foundNames":["Benoit VERHAEGHE","Benoit.VERHAEGHE","Benoît VERHAEGHE","Benoît Verhaeghe"],"name":"Benoit VERHAEGHE"},"HLAD Nicolas":{"id":2,"username":"Nicolas.HLAD","foundNames":["Nicolas Hlad","Nicolas.HLAD","HLAD Nicolas"],"name":"HLAD Nicolas"}}'.

	res := GLHUserCatalogue loadFromJson: json.
	self assert: res size equals: 2.
	self assert: (res searchUserWithName: 'Nicolas') isNotEmpty equals: true.
		self assert: (res searchUserWithName: 'VERHAEGHE') isNotEmpty equals: true.
]
