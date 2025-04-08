"
A GitMetricExporterTest is a test class for testing the behavior of GitMetricExporter
"
Class {
	#name : #GitMetricExporterTest,
	#superclass : #TestCase,
	#instVars : [
		'gme'
	],
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #running }
GitMetricExporterTest >> setUp [

	| period |
	super setUp.
	gme := GitMetricExporter new.
	period := {
		          (#since -> '2024-09-04' asDate).
		          (#until -> '2024-09-05' asDate) } asDictionary.
	gme analyses: {
			(ProjectAnalysisReport new
				 projectID: 12;
				 projectName: 'A Nice Project';
				 over: Week;
				 period: period;
				 yourself).
			"same name in purpose"
			(ProjectAnalysisReport new
				 projectID: 13;
				 projectName: 'A Nice Project';
				 over: Week;
				 period: period;
				 yourself) }
]

{ #category : #running }
GitMetricExporterTest >> tearDown [
	GitMetricExporter recoverFromGHMutation.
	super tearDown.
]

{ #category : #tests }
GitMetricExporterTest >> testExportProjectAnalysesInCSV [

	| memoryFile |
	memoryFile := (FileSystem memory / 'test.csv') asFileReference.
	(gme stub constructFilePathFor: Any andEntities: Any) willReturn:
		memoryFile.
	gme exportProjectAnalysesInCSV.
	"Include project ID 12"
	self assert: (memoryFile contents includesSubstring: '"12"').
	"Include project ID 13"
	self assert: (memoryFile contents includesSubstring: '"13"')
]
