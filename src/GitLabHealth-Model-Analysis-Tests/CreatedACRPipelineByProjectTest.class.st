Class {
	#name : #CreatedACRPipelineByProjectTest,
	#superclass : #ProjectMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
CreatedACRPipelineByProjectTest >> testCalculate [
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
			 state: 'opened';
			 project: project;
			 note: notes notes) }.
	

	nbNotes := CreatedACRPipelineByProject new
		                  project: project;
		                  glhImporter: glhImporter;
		                  setPeriodSince: since until: until;
								over: Week.
	"When"
	result := nbNotes calculate.

	"Then"
	self assert: result equals: 1
]
