Class {
	#name : #GLHExtensionTest,
	#superclass : #TestCase,
	#instVars : [
		'model'
	],
	#category : #'GitLabHealth-Model-Extension-Tests'
}

{ #category : #tests }
GLHExtensionTest >> setUp [

	super setUp.
	model := GLHModel new
]

{ #category : #tests }
GLHExtensionTest >> testAddAllOfTypeUnless [

	| user values |
	user := GLHUser new.
	user id: 12.
	values := model addAll: { user } ofType: GLHUser unless: [ :a :b | a id = b id ].
	self assert: values size equals: 1.
	self assert: values anyOne equals: user.
]

{ #category : #tests }
GLHExtensionTest >> testAddAllOfTypeUnlessDifferentEntity [

	| user values alreadyExistingUser |
	alreadyExistingUser := model newUser.
	alreadyExistingUser id: 15.
	user := GLHUser new.
	user id: 12.
	values := model
		          addAll: { user }
		          ofType: GLHUser
		          unless: [ :a :b | a id = b id ].
	self assert: values size equals: 1.
	self assert: model size equals: 2.
	self assert: (values includes: user).
	self assert: (model includes: user).
	self assert: (model includes: alreadyExistingUser)
]

{ #category : #tests }
GLHExtensionTest >> testAddAllOfTypeUnlessWithAlreadyExistingEntity [

	| user values alreadyExistingUser user15 |
	alreadyExistingUser := model newUser.
	alreadyExistingUser id: 15.
	alreadyExistingUser name: 'John'.

	user := GLHUser new.
	user id: 12.
	user15 := GLHUser new.
	user15 id: 15.
	user15 name: 'Tony'.

	values := model
		          addAll: {
				          user.
				          user15 }
		          ofType: GLHUser
		          unless: [ :a :b | a id = b id ].
	self assert: values size equals: 2.
	self assert: (values anySatisfy: [ :e | e name = 'John' ]).
	self deny: (values anySatisfy: [ :e | e name = 'Tony' ]).
	self assert: model size equals: 2.
	self assert: (values includes: user).
	self assert: (values includes: alreadyExistingUser)
]

{ #category : #tests }
GLHExtensionTest >> testAddAllUnless [

	| col |
	col := OrderedCollection new.
	col addAll: { 12 } unless: [ :a :b | a = b ].
	self assert: col size equals: 1.
	self assert: col first equals: 12
]

{ #category : #tests }
GLHExtensionTest >> testAddAllUnlessTwiceEqualityIsTheSameButNotObject [

	| col user result userB |
	user := GLHUser new.
	user id: 12.
	col := OrderedCollection new.
	col addAll: { user } unless: [ :a :b | a id = b id ].
	self assert: col size equals: 1.
	self assert: col first identicalTo: user.
	userB := GLHUser new.
	userB id: 12.
	result := col addAll: { userB } unless: [ :a :b | a id = b id ].
	self assert: col size equals: 1.
	self assert: result first identicalTo: user
]

{ #category : #tests }
GLHExtensionTest >> testAddAllUnlessTwiceTheSame [

	| col user result |
	user := GLHUser new.
	user id: 12.
	col := OrderedCollection new.
	col addAll: { user } unless: [ :a :b | a = b ].
	self assert: col size equals: 1.
	self assert: col first identicalTo: user.
	result := col addAll: { user } unless: [ :a :b | a = b ].
	self assert: col size equals: 1.
	self assert: result first identicalTo: user
]
