Class {
	#name : #CreatedNotesByACRByProjectMetricTest,
	#superclass : #ProjectMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
CreatedNotesByACRByProjectMetricTest >> testCalculate [
	| glhImporter result nbNotes notes |
	"Given"
	glhImporter := GLPHImporterMock new.
	
	notes := glhImporter notes: { (GLHNote new
			 created_at: createdAt ;
			 noteable_iid: 2002;
			 updated_at: updatedAt;
			 body: 'n importe quoi').
			(GLHNote new
			 created_at: createdAt ;
			 updated_at: updatedAt;
			 noteable_iid: 2002;
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
