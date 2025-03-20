"
A GLHModelImporterTest is a test class for testing the behavior of GLHModelImporter
"
Class {
	#name : #GLHModelImporterTest,
	#superclass : #TestCase,
	#instVars : [
		'glphModel',
		'glphApi',
		'since',
		'glhImporter'
	],
	#category : #'GitLabHealth-Model-Importer-Tests'
}

{ #category : #accessing }
GLHModelImporterTest class >> resources [

	^ Array with: GLHModelImporterTestResource
]

{ #category : #running }
GLHModelImporterTest >> glhImporter [

	^ self class resources first current glhImporter
]

{ #category : #running }
GLHModelImporterTest >> model [

	^ self class resources first current model
]

{ #category : #test }
GLHModelImporterTest >> testFilterCommitChanges [

	| importer collection resultCollection |
	importer := GitlabModelImporter new.
	collection := '--- a/code.js
+++ b/code.js
@@ -1,3 +1,4 @@
 //Populate the welcome text
-var name = "Hello Customer";
-$("#welcome").text
\ No newline at end of file
+var is_new = false;
+var name = (is_new ? "Hello New Customer" : "Hello Customer")
+$("#welcome").text(name);
\ No newline at end of file' lines.
	"remove starting with --- and +++ and \nonewLine stuff"
	resultCollection := importer filterCommitChanges: collection.
	self assert: resultCollection size equals: 7
]

{ #category : #tests }
GLHModelImporterTest >> testImportBranch [

	| testCodeChurnRepository |
	testCodeChurnRepository := (self model allWithType: GLHGroup) anyOne
		                           projects anyOne repository.
	self assert: testCodeChurnRepository branches isNotEmpty
]

{ #category : #tests }
GLHModelImporterTest >> testImportCommits [

	| projectTestCodeChurn |
	projectTestCodeChurn := (self model allWithType: GLHProject) detect: [
		                        :project | project id = 57841283 ].
	self glhImporter importLastestCommitsOfProject: projectTestCodeChurn.

	self
		assert: projectTestCodeChurn repository commits last author_name
		equals: 'Nicolas Hlad'
]

{ #category : #tests }
GLHModelImporterTest >> testImportGroup [

	| evrefGroup |
	self assert: (self model allWithType: GLHGroup) size equals: 1.
	evrefGroup := (self model allWithType: GLHGroup) anyOne.
	self assert: evrefGroup projects isNotEmpty.
	"project https://gitlab.com/evref-bl/test-code-churn"
	self assert:
		(evrefGroup projects anySatisfy: [ :project | project id = 57841283 ])
]

{ #category : #tests }
GLHModelImporterTest >> testImportNote [
	| testNote |
	
	testNote := glhImporter importNotesfromMergeRequest: 16 ofProject: 6845.
	self assert: ((self model allWithType: GLHNote size) equals: 3). 
	
	
]

{ #category : #tests }
GLHModelImporterTest >> testImportProject [

	self assert: (self model allWithType: GLHProject) size equals: 1.
	self assert:
		((self model allWithType: GLHProject) anySatisfy: [ :project |
			 project id = 57841283 ])
]
