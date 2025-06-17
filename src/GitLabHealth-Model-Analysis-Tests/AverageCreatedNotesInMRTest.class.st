Class {
	#name : #AverageCreatedNotesInMRTest,
	#superclass : #ProjectMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
AverageCreatedNotesInMRTest >> testCalculate [
	| glhImporter result nbNotes notes acrBot |
	"Given"
	glhImporter := GLPHImporterMock new.
	
	acrBot := GLHUser new id: 2661; username: 'AutoCodeReview'; yourself.
	
	notes := glhImporter notes: { 
			(GLHNote new
			noteable_iid: 2002; 
			created_at: createdAt ;
			 updated_at: updatedAt;
			 author: (GLHUser new id: 123; yourself);
			 body: 'n importe quoi').
			(GLHNote new
			 created_at: createdAt ;
			 updated_at: updatedAt;
			 noteable_iid: 2002;
			 author: acrBot; 
			 body: 'The automated review has been completed. No modifications were found based on the current analysis rules.')
			 }.
			
	glhImporter mergeRequests: { (GLHMergeRequest new
			 created_at: createdAt ;
			 iid: 2002;
			 state: 'closed';
			 project: project;
			 note: notes notes) }.
	

	nbNotes := AverageCreatedNotesInMR new
		                  project: project;
		                  glhImporter: glhImporter;
		                  setPeriodSince: since until: until;
								over: Week.
	"When"
	result := nbNotes calculate.

	"Then"
	self assert: result equals: 2
]

{ #category : #tests }
AverageCreatedNotesInMRTest >> testCalculateMergedMergeRequest [

	| glhImporter result nbNotes notes acrBot |
	"Given"
	glhImporter := GLPHImporterMock new.

	acrBot := GLHUser new
		          id: 2661;
		          username: 'AutoCodeReview';
		          yourself.

	notes := glhImporter notes: {
			         (GLHNote new
				          noteable_iid: 2002;
				          created_at: createdAt;
				          updated_at: updatedAt;
				          author: (GLHUser new
						           id: 123;
						           yourself);
				          body: 'n importe quoi').
			         (GLHNote new
				          created_at: createdAt;
				          updated_at: updatedAt;
				          noteable_iid: 2002;
				          author: acrBot;
				          body:
					          'The automated review has been completed. No modifications were found based on the current analysis rules.') }.

	glhImporter mergeRequests: { (GLHMergeRequest new
			 created_at: createdAt;
			 iid: 2002;
			 state: 'merged';
			 project: project;
			 note: notes notes) }.


	nbNotes := AverageCreatedNotesInMR new
		           project: project;
		           glhImporter: glhImporter;
		           setPeriodSince: since until: until;
		           over: Week.
	"When"
	result := nbNotes calculate.

	"Then"
	self assert: result equals: 2
]

{ #category : #tests }
AverageCreatedNotesInMRTest >> testCalculateMultipleMR [

	| glhImporter result nbNotes notes acrBot notes2 |
	"Given"
	glhImporter := GLPHImporterMock new.

	acrBot := GLHUser new
		          id: 2661;
		          username: 'AutoCodeReview';
		          yourself.

	notes := glhImporter notes: {
			         (GLHNote new
				          noteable_iid: 2002;
				          created_at: createdAt;
				          updated_at: updatedAt;
				          author: (GLHUser new
						           id: 123;
						           yourself);
				          body: 'n importe quoi').
			         (GLHNote new
				          created_at: createdAt;
				          updated_at: updatedAt;
				          noteable_iid: 2002;
				          author: acrBot;
				          body:
					          'The automated review has been completed. No modifications were found based on the current analysis rules.') } asOrderedCollection.

	notes2 := glhImporter notes addAll: {
			          (GLHNote new
				           noteable_iid: 2006;
				           created_at: createdAt;
				           updated_at: updatedAt;
				           author: (GLHUser new
						            id: 123;
						            yourself);
				           body: 'n importe quoi').
			          (GLHNote new
				           created_at: createdAt;
				           updated_at: updatedAt;
				           noteable_iid: 2007;
				           author: acrBot;
				           body:
					           'The automated review has been completed. No modifications were found based on the current analysis rules.') }.

	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 created_at: createdAt;
				 iid: 2002;
				 state: 'closed';
				 project: project;
				 note: notes notes).
			(GLHMergeRequest new
				 created_at: createdAt;
				 iid: 2005;
				 state: 'closed';
				 project: project;
				 note: notes2) }.


	nbNotes := AverageCreatedNotesInMR new
		           project: project;
		           glhImporter: glhImporter;
		           setPeriodSince: since until: until;
		           over: Week.
	"When"
	result := nbNotes calculate.

	"Then"
	self assert: result equals: 2
]

{ #category : #tests }
AverageCreatedNotesInMRTest >> testCalculateMultipleMRDifferentNumberOfNotes [

	| glhImporter result nbNotes notes acrBot notes2 |
	"Given"
	glhImporter := GLPHImporterMock new.

	acrBot := GLHUser new
		          id: 2661;
		          username: 'AutoCodeReview';
		          yourself.

	notes := glhImporter notes: {
			         (GLHNote new
				          noteable_iid: 2002;
				          created_at: createdAt;
				          updated_at: updatedAt;
				          author: (GLHUser new
						           id: 123;
						           yourself);
				          body: 'n importe quoi').
			         (GLHNote new
				          created_at: createdAt;
				          updated_at: updatedAt;
				          noteable_iid: 2002;
				          author: acrBot;
				          body:
					          'The automated review has been completed. No modifications were found based on the current analysis rules.') }
			         asOrderedCollection.

	notes2 := glhImporter notes addAll: { (GLHNote new
			           noteable_iid: 2006;
			           created_at: createdAt;
			           updated_at: updatedAt;
			           author: (GLHUser new
					            id: 123;
					            yourself);
			           body: 'n importe quoi') }.

	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 created_at: createdAt;
				 iid: 2002;
				 state: 'closed';
				 project: project;
				 note: notes notes).
			(GLHMergeRequest new
				 created_at: createdAt;
				 iid: 2005;
				 state: 'closed';
				 project: project;
				 note: notes2) }.

	nbNotes := AverageCreatedNotesInMR new
		           project: project;
		           glhImporter: glhImporter;
		           setPeriodSince: since until: until;
		           over: Week.
	"When"
	result := nbNotes calculate.

	"Then"
	self assert: result equals: 1.5
]

{ #category : #tests }
AverageCreatedNotesInMRTest >> testCalculateMultipleMRMerged [

	| glhImporter result nbNotes notes acrBot notes2 |
	"Given"
	glhImporter := GLPHImporterMock new.

	acrBot := GLHUser new
		          id: 2661;
		          username: 'AutoCodeReview';
		          yourself.

	notes := glhImporter notes: {
			         (GLHNote new
				          noteable_iid: 2002;
				          created_at: createdAt;
				          updated_at: updatedAt;
				          author: (GLHUser new
						           id: 123;
						           yourself);
				          body: 'n importe quoi').
			         (GLHNote new
				          created_at: createdAt;
				          updated_at: updatedAt;
				          noteable_iid: 2002;
				          author: acrBot;
				          body:
					          'The automated review has been completed. No modifications were found based on the current analysis rules.') } asOrderedCollection.

	notes2 := glhImporter notes addAll: {
			          (GLHNote new
				           noteable_iid: 2006;
				           created_at: createdAt;
				           updated_at: updatedAt;
				           author: (GLHUser new
						            id: 123;
						            yourself);
				           body: 'n importe quoi').
			          (GLHNote new
				           created_at: createdAt;
				           updated_at: updatedAt;
				           noteable_iid: 2007;
				           author: acrBot;
				           body:
					           'The automated review has been completed. No modifications were found based on the current analysis rules.') }.

	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 created_at: createdAt;
				 iid: 2002;
				 state: 'merged';
				 project: project;
				 note: notes notes).
			(GLHMergeRequest new
				 created_at: createdAt;
				 iid: 2005;
				 state: 'merged';
				 project: project;
				 note: notes2) }.


	nbNotes := AverageCreatedNotesInMR new
		           project: project;
		           glhImporter: glhImporter;
		           setPeriodSince: since until: until;
		           over: Week.
	"When"
	result := nbNotes calculate.

	"Then"
	self assert: result equals: 2
]

{ #category : #tests }
AverageCreatedNotesInMRTest >> testCalculateMultipleMRMixCloseAndMerged [

	| glhImporter result nbNotes notes acrBot notes2 |
	"Given"
	glhImporter := GLPHImporterMock new.

	acrBot := GLHUser new
		          id: 2661;
		          username: 'AutoCodeReview';
		          yourself.

	notes := glhImporter notes: {
			         (GLHNote new
				          noteable_iid: 2002;
				          created_at: createdAt;
				          updated_at: updatedAt;
				          author: (GLHUser new
						           id: 123;
						           yourself);
				          body: 'n importe quoi').
			         (GLHNote new
				          created_at: createdAt;
				          updated_at: updatedAt;
				          noteable_iid: 2002;
				          author: acrBot;
				          body:
					          'The automated review has been completed. No modifications were found based on the current analysis rules.') }
			         asOrderedCollection.

	notes2 := glhImporter notes addAll: { (GLHNote new
			           noteable_iid: 2006;
			           created_at: createdAt;
			           updated_at: updatedAt;
			           author: (GLHUser new
					            id: 123;
					            yourself);
			           body: 'n importe quoi') }.

	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 created_at: createdAt;
				 iid: 2002;
				 state: 'merged';
				 project: project;
				 note: notes notes).
			(GLHMergeRequest new
				 created_at: createdAt;
				 iid: 2005;
				state: 'closed';
				 project: project;
				 note: notes2) }.


	nbNotes := AverageCreatedNotesInMR new
		           project: project;
		           glhImporter: glhImporter;
		           setPeriodSince: since until: until;
		           over: Week.
	"When"
	result := nbNotes calculate.

	"Then"
	self assert: result equals: 1.5
]

{ #category : #tests }
AverageCreatedNotesInMRTest >> testCalculateMultipleMRMixOpenAndClose [

	| glhImporter result nbNotes notes acrBot notes2 |
	"Given"
	glhImporter := GLPHImporterMock new.

	acrBot := GLHUser new
		          id: 2661;
		          username: 'AutoCodeReview';
		          yourself.

	notes := glhImporter notes: {
			         (GLHNote new
				          noteable_iid: 2002;
				          created_at: createdAt;
				          updated_at: updatedAt;
				          author: (GLHUser new
						           id: 123;
						           yourself);
				          body: 'n importe quoi').
			         (GLHNote new
				          created_at: createdAt;
				          updated_at: updatedAt;
				          noteable_iid: 2002;
				          author: acrBot;
				          body:
					          'The automated review has been completed. No modifications were found based on the current analysis rules.') }
			         asOrderedCollection.

	notes2 := glhImporter notes addAll: { (GLHNote new
			           noteable_iid: 2006;
			           created_at: createdAt;
			           updated_at: updatedAt;
			           author: (GLHUser new
					            id: 123;
					            yourself);
			           body: 'n importe quoi') }.

	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 created_at: createdAt;
				 iid: 2002;
				 state: 'closed';
				 project: project;
				 note: notes notes).
			(GLHMergeRequest new
				 created_at: createdAt;
				 iid: 2005;
				 project: project;
				 note: notes2) }.


	nbNotes := AverageCreatedNotesInMR new
		           project: project;
		           glhImporter: glhImporter;
		           setPeriodSince: since until: until;
		           over: Week.
	"When"
	result := nbNotes calculate.

	"Then"
	self assert: result equals: 2
]

{ #category : #tests }
AverageCreatedNotesInMRTest >> testCalculateMultipleMRMixOpenAndMerged [

	| glhImporter result nbNotes notes acrBot notes2 |
	"Given"
	glhImporter := GLPHImporterMock new.

	acrBot := GLHUser new
		          id: 2661;
		          username: 'AutoCodeReview';
		          yourself.

	notes := glhImporter notes: {
			         (GLHNote new
				          noteable_iid: 2002;
				          created_at: createdAt;
				          updated_at: updatedAt;
				          author: (GLHUser new
						           id: 123;
						           yourself);
				          body: 'n importe quoi').
			         (GLHNote new
				          created_at: createdAt;
				          updated_at: updatedAt;
				          noteable_iid: 2002;
				          author: acrBot;
				          body:
					          'The automated review has been completed. No modifications were found based on the current analysis rules.') }
			         asOrderedCollection.

	notes2 := glhImporter notes addAll: { (GLHNote new
			           noteable_iid: 2006;
			           created_at: createdAt;
			           updated_at: updatedAt;
			           author: (GLHUser new
					            id: 123;
					            yourself);
			           body: 'n importe quoi') }.

	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 created_at: createdAt;
				 iid: 2002;
				 state: 'merged';
				 project: project;
				 note: notes notes).
			(GLHMergeRequest new
				 created_at: createdAt;
				 iid: 2005;
				 project: project;
				 note: notes2) }.


	nbNotes := AverageCreatedNotesInMR new
		           project: project;
		           glhImporter: glhImporter;
		           setPeriodSince: since until: until;
		           over: Week.
	"When"
	result := nbNotes calculate.

	"Then"
	self assert: result equals: 2
]

{ #category : #tests }
AverageCreatedNotesInMRTest >> testCalculateNoMR [

	| glhImporter result nbNotes acrBot |
	"Given"
	glhImporter := GLPHImporterMock new.

	acrBot := GLHUser new
		          id: 2661;
		          username: 'AutoCodeReview';
		          yourself.


	glhImporter mergeRequests: { }.

	nbNotes := AverageCreatedNotesInMR new
		           project: project;
		           glhImporter: glhImporter;
		           setPeriodSince: since until: until;
		           over: Week.
	"When"
	result := nbNotes calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
AverageCreatedNotesInMRTest >> testCalculateOnlyOpenMergeRequest [

	| glhImporter result nbNotes notes acrBot |
	"Given"
	glhImporter := GLPHImporterMock new.

	acrBot := GLHUser new
		          id: 2661;
		          username: 'AutoCodeReview';
		          yourself.

	notes := glhImporter notes: {
			         (GLHNote new
				          noteable_iid: 2002;
				          created_at: createdAt;
				          updated_at: updatedAt;
				          author: (GLHUser new
						           id: 123;
						           yourself);
				          body: 'n importe quoi').
			         (GLHNote new
				          created_at: createdAt;
				          updated_at: updatedAt;
				          noteable_iid: 2002;
				          author: acrBot;
				          body:
					          'The automated review has been completed. No modifications were found based on the current analysis rules.') }.

	glhImporter mergeRequests: { (GLHMergeRequest new
			 created_at: createdAt;
			 iid: 2002;
			 project: project;
			 note: notes notes) }.


	nbNotes := AverageCreatedNotesInMR new
		           project: project;
		           glhImporter: glhImporter;
		           setPeriodSince: since until: until;
		           over: Week.
	"When"
	result := nbNotes calculate.

	"Then"
	self assert: result equals: 0
]
