Class {
	#name : #CreatedNotesByACRByProjectMetricTest,
	#superclass : #ProjectMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
CreatedNotesByACRByProjectMetricTest >> testCalculate [
	| glhImporter result nbNotes |
	"Given"
	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 created_at: createdAt ;
			 state: 'opened';
			 project: project) }.
	
	glhImporter notes: { (GLHNote new
			 created_at: createdAt ;
			 updated_at: updatedAt;
			 body: 'n importe quoi').
			(GLHNote new
			 created_at: createdAt ;
			 updated_at: updatedAt;
			 body: 'Auto code review has detected that the code violates this rule.')
			  }.


	nbNotes := CreatedNotesByACRByProjectMetric new
		                  project: project;
		                  glhImporter: glhImporter;
		                  setPeriodSince: since until: until.

	"When"
	result := nbNotes calculate.

	"Then"
	self assert: result equals: 1
]
