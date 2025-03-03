"
An AutoCodeCommitFrequencyProjectMetricTest is a test class for testing the behavior of AutoCodeCommitFrequencyProjectMetric
"
Class {
	#name : #AutoCodeCommitFrequencyProjectMetricTest,
	#superclass : #ProjectMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
AutoCodeCommitFrequencyProjectMetricTest >> testCalculate [  
    | glhImporter result commitFrequency autoCommit1 autoCommit2 manualCommit  |  

    "Given"  
    glhImporter := GLPHImporterMock new.  

    "Create an auto commit"  
    autoCommit1 := GLHCommit new  
        created_at: createdAt;  
        repository: project1 repository;  
        title: 'auto-code update'.  
   autoCommit2 := GLHCommit new  
        created_at: createdAt;  
        repository: project1 repository;  
        title: 'auto-code update'.  


    "Create a non-auto commit"  
    manualCommit := GLHCommit new  
        created_at: createdAt;  
        repository: project1 repository;  
        title: 'manual update'.  
 
    glhImporter commits: { autoCommit1. manualCommit. autoCommit2 }.  

    commitFrequency := AutoCodeCommitFrequencyProjectMetric new  
        project: project1;  
        glhImporter: glhImporter;  
        setPeriodSince: since until: until;  
        over: Week.  

    "When"  
    result := commitFrequency calculate.  

    "Then - Only auto commits should be counted"  
    self assert: result equals: 2.

]
