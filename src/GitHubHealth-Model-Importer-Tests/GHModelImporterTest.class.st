"
A GHModelImporterTest is a test class for testing the behavior of GHModelImporter
"
Class {
	#name : #GHModelImporterTest,
	#superclass : #TestCase,
	#instVars : [
		'importer'
	],
	#category : #'GitHubHealth-Model-Importer-Tests'
}

{ #category : #running }
GHModelImporterTest >> setUp [
	super setUp.

	importer := GHModelImporter new
]

{ #category : #test }
GHModelImporterTest >> testParsePipelinesResult [

	| project |

	project := importer parsePipelinesResult: '{
  "total_count": 1,
  "workflow_runs": [
    {
      "id": 7482814798,
      "conclusion": "success",
      "run_started_at": "2024-01-11T00:00:00"
    }]}'.

	self assert: project workflow_runs size equals: 1.

	self assert: project workflow_runs anyOne status equals: 'success'.
	self assert: project workflow_runs anyOne runDate equals: (DateAndTime year: 2024 month: 01 day: 11).

]
