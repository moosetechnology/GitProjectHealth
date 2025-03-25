Class {
	#name : #CreatedNotesByACRByProjectMetricTest,
	#superclass : #ProjectMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
CreatedNotesByACRByProjectMetricTest >> testCalculate [
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
			 body: 'Auto code review has detected that the code violates this rule.')
			 }.
			
	glhImporter mergeRequests: { (GLHMergeRequest new
			 created_at: createdAt ;
			 iid: 2002;
			 state: 'opened';
			 project: project;
			 note: notes notes) }.
	

	nbNotes := CreatedNotesByACRByProjectMetric new
		                  project: project;
		                  glhImporter: glhImporter;
		                  setPeriodSince: since until: until;
								over: Week.
	"When"
	result := nbNotes calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #tests }
CreatedNotesByACRByProjectMetricTest >> testCalculateNoACRNote [
	| glhImporter result nbNotes notes acrBot |
	"Given"
	glhImporter := GLPHImporterMock new.
	
	acrBot := GLHUser new id: 2661; username: 'AutoCodeReview'; yourself.
	
	notes := glhImporter notes: { 
			(GLHNote new
			noteable_iid: 2002; 
			created_at: createdAt ;
			 updated_at: updatedAt;
			 author: (GLHUser new id: 123; yourself) ;
			 body: 'n importe quoi').
			(GLHNote new
			 created_at: createdAt ;
			 updated_at: updatedAt;
			 noteable_iid: 2002;
			 author: (GLHUser new id: 123; yourself); 
			 body: 'Auto code review has detected that the code violates this rule.')
			 }.
			
	glhImporter mergeRequests: { (GLHMergeRequest new
			 created_at: createdAt ;
			 iid: 2002;
			 state: 'opened';
			 project: project;
			 note: notes notes) }.
	

	nbNotes := CreatedNotesByACRByProjectMetric new
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
CreatedNotesByACRByProjectMetricTest >> testCalculateTwoACRNotes [
	| glhImporter result nbNotes notes acrBot |
	"Given"
	glhImporter := GLPHImporterMock new.
	
	acrBot := GLHUser new id: 2661; username: 'AutoCodeReview'; yourself.
	
	notes := glhImporter notes: { 
			(GLHNote new
			noteable_iid: 2002; 
			created_at: createdAt ;
			 updated_at: updatedAt;
			 author: acrBot ;
			 body: 'n importe quoi').
			(GLHNote new
			 created_at: createdAt ;
			 updated_at: updatedAt;
			 noteable_iid: 2002;
			 author: acrBot; 
			 body: 'Auto code review has detected that the code violates this rule.')
			 }.
			
	glhImporter mergeRequests: { (GLHMergeRequest new
			 created_at: createdAt ;
			 iid: 2002;
			 state: 'opened';
			 project: project;
			 note: notes notes) }.
	

	nbNotes := CreatedNotesByACRByProjectMetric new
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
CreatedNotesByACRByProjectMetricTest >> testCalculateTwoACRNotesDifferentProject [
	| glhImporter result nbNotes notes acrBot |
	"Given"
	glhImporter := GLPHImporterMock new.
	
	acrBot := GLHUser new id: 2661; username: 'AutoCodeReview'; yourself.
	
	notes := glhImporter notes: { 
			(GLHNote new
			noteable_iid: 2002; 
			created_at: createdAt ;
			 updated_at: updatedAt;
			 author: acrBot ;
			 body: 'n importe quoi').
			(GLHNote new
			 created_at: createdAt ;
			 updated_at: updatedAt;
			 noteable_iid: 2002;
			 author: acrBot; 
			 body: 'Auto code review has detected that the code violates this rule.')
			 }.
			
	glhImporter mergeRequests: { (GLHMergeRequest new
			 created_at: createdAt ;
			 iid: 2002;
			 state: 'opened';
			 project: project;
			 note: notes notes) }.
	

	nbNotes := CreatedNotesByACRByProjectMetric new
		                  project: project1;
		                  glhImporter: glhImporter;
		                  setPeriodSince: since until: until;
								over: Week.
	"When"
	result := nbNotes calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
CreatedNotesByACRByProjectMetricTest >> testCalculateTwoACRNotesOneInAndOneOutOfPeriod [
	| glhImporter result nbNotes notes acrBot |
	"Given"
	glhImporter := GLPHImporterMock new.
	
	acrBot := GLHUser new id: 2661; username: 'AutoCodeReview'; yourself.
	
	notes := glhImporter notes: { 
			(GLHNote new
			noteable_iid: 2002; 
			created_at: createdAt ;
			 updated_at: updatedAt ;
			 author: acrBot ;
			 body: 'n importe quoi').
			(GLHNote new
			 created_at: createdAt -1 year  ;
			 updated_at: updatedAt -1 year ;
			 noteable_iid: 2002;
			 author: acrBot; 
			 body: 'Auto code review has detected that the code violates this rule.')
			 }.
			
	glhImporter mergeRequests: { (GLHMergeRequest new
			 created_at: createdAt ;
			 iid: 2002;
			 state: 'opened';
			 project: project;
			 note: notes notes) }.
	

	nbNotes := CreatedNotesByACRByProjectMetric new
		                  project: project;
		                  glhImporter: glhImporter;
		                  setPeriodSince: since until: until;
								over: Week.
	"When"
	result := nbNotes calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #tests }
CreatedNotesByACRByProjectMetricTest >> testCalculateTwoACRNotesOutsidePeriod [
	| glhImporter result nbNotes notes acrBot |
	"Given"
	glhImporter := GLPHImporterMock new.
	
	acrBot := GLHUser new id: 2661; username: 'AutoCodeReview'; yourself.
	
	notes := glhImporter notes: { 
			(GLHNote new
			noteable_iid: 2002; 
			created_at: createdAt -1 year ;
			 updated_at: updatedAt-1 year ;
			 author: acrBot ;
			 body: 'n importe quoi').
			(GLHNote new
			 created_at: createdAt -1 year  ;
			 updated_at: updatedAt -1 year ;
			 noteable_iid: 2002;
			 author: acrBot; 
			 body: 'Auto code review has detected that the code violates this rule.')
			 }.
			
	glhImporter mergeRequests: { (GLHMergeRequest new
			 created_at: createdAt ;
			 iid: 2002;
			 state: 'opened';
			 project: project;
			 note: notes notes) }.
	

	nbNotes := CreatedNotesByACRByProjectMetric new
		                  project: project;
		                  glhImporter: glhImporter;
		                  setPeriodSince: since until: until;
								over: Week.
	"When"
	result := nbNotes calculate.

	"Then"
	self assert: result equals: 0
]
