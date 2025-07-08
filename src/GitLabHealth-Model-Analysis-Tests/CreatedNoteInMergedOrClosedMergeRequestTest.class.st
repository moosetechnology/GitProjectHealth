Class {
	#name : #CreatedNoteInMergedOrClosedMergeRequestTest,
	#superclass : #ProjectMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
CreatedNoteInMergedOrClosedMergeRequestTest >> testCalculate [
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
			closed_at: closedAt;
			 iid: 2002;
			 state: 'closed';
			 project: project;
			 note: notes notes) }.
	

	nbNotes := CreatedNoteInMergedOrClosedMergeRequest new
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
CreatedNoteInMergedOrClosedMergeRequestTest >> testCalculateMergedMergeRequest [

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
			 merged_at: mergedAt;
			 iid: 2002;
			 state: 'merged';
			 project: project;
			 note: notes notes) }.


	nbNotes := CreatedNoteInMergedOrClosedMergeRequest new
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
CreatedNoteInMergedOrClosedMergeRequestTest >> testCalculateMergedMergeRequestNoteBeforePeriod [

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
				          created_at: (createdAt - 3 week) asDateAndTime;
				          updated_at: (updatedAt - 3 week) asDateAndTime;
				          noteable_iid: 2002;
				          author: acrBot;
				          body:
					          'The automated review has been completed. No modifications were found based on the current analysis rules.') }.

	glhImporter mergeRequests: { (GLHMergeRequest new
			 created_at: createdAt;
			 merged_at: mergedAt;
			 iid: 2002;
			 state: 'merged';
			 project: project;
			 note: notes notes) }.


	nbNotes := CreatedNoteInMergedOrClosedMergeRequest new
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
CreatedNoteInMergedOrClosedMergeRequestTest >> testCalculateMultipleMR [

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
				 closed_at: closedAt;
				 project: project;
				 note: notes notes).
			(GLHMergeRequest new
				 created_at: createdAt;
				 closed_at: closedAt;
				 iid: 2005;
				 state: 'closed';
				 project: project;
				 note: notes2) }.


	nbNotes := CreatedNoteInMergedOrClosedMergeRequest new
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
CreatedNoteInMergedOrClosedMergeRequestTest >> testCalculateMultipleMRDifferentNumberOfNotes [

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
				 closed_at: closedAt;
				 project: project;
				 note: notes notes).
			(GLHMergeRequest new
				 created_at: createdAt;
				 iid: 2005;
				 state: 'closed';
				 closed_at: closedAt;
				 project: project;
				 note: notes2) }.

	nbNotes := CreatedNoteInMergedOrClosedMergeRequest new
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
CreatedNoteInMergedOrClosedMergeRequestTest >> testCalculateMultipleMRMerged [

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
				 merged_at: mergedAt;
				 project: project;
				 note: notes notes).
			(GLHMergeRequest new
				 created_at: createdAt;
				 merged_at: mergedAt;
				 iid: 2005;
				 state: 'merged';
				 project: project;
				 note: notes2) }.


	nbNotes := CreatedNoteInMergedOrClosedMergeRequest new
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
CreatedNoteInMergedOrClosedMergeRequestTest >> testCalculateMultipleMRMixCloseAndMerged [

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
				 merged_at: mergedAt;
				 project: project;
				 note: notes notes).
			(GLHMergeRequest new
				 created_at: createdAt;
				 iid: 2005;
				 state: 'closed';
				 closed_at: closedAt;
				 project: project;
				 note: notes2) }.


	nbNotes := CreatedNoteInMergedOrClosedMergeRequest new
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
CreatedNoteInMergedOrClosedMergeRequestTest >> testCalculateMultipleMRMixOpenAndClose [

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
				 closed_at: closedAt;
				 project: project;
				 note: notes notes).
			(GLHMergeRequest new
				 created_at: createdAt;
				 iid: 2005;
				 project: project;
				 note: notes2) }.


	nbNotes := CreatedNoteInMergedOrClosedMergeRequest new
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
CreatedNoteInMergedOrClosedMergeRequestTest >> testCalculateMultipleMRMixOpenAndMerged [

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
				 merged_at: mergedAt;
				 project: project;
				 note: notes notes).
			(GLHMergeRequest new
				 created_at: createdAt;
				 iid: 2005;
				 project: project;
				 note: notes2) }.


	nbNotes := CreatedNoteInMergedOrClosedMergeRequest new
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
CreatedNoteInMergedOrClosedMergeRequestTest >> testCalculateNoMR [

	| glhImporter result nbNotes acrBot |
	"Given"
	glhImporter := GLPHImporterMock new.

	acrBot := GLHUser new
		          id: 2661;
		          username: 'AutoCodeReview';
		          yourself.


	glhImporter mergeRequests: { }.

	nbNotes := CreatedNoteInMergedOrClosedMergeRequest new
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
CreatedNoteInMergedOrClosedMergeRequestTest >> testCalculateOnlyOpenMergeRequest [

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


	nbNotes := CreatedNoteInMergedOrClosedMergeRequest new
		           project: project;
		           glhImporter: glhImporter;
		           setPeriodSince: since until: until;
		           over: Week.
	"When"
	result := nbNotes calculate.

	"Then"
	self assert: result equals: 0
]
