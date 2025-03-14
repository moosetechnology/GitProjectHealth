"
An AutoCodeCommitFrequencyProjectMetricTest is a test class for testing the behavior of AutoCodeCommitFrequencyProjectMetric
"
Class {
	#name : #AutoCodeReviewCommitFrequencyProjectMetricTest,
	#superclass : #ProjectMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
AutoCodeReviewCommitFrequencyProjectMetricTest >> testCalculate [  
    | glhImporter result commitFrequency autoCommit   |  

    "Given"  
    glhImporter := GLPHImporterMock new.  

 
   autoCommit := GLHCommit new  
        created_at: createdAt;  
        repository: project1 repository;  
        title: '[ACR][JS125R-1] This block of commented-out lines of code should be removed.'.  

 
    glhImporter commits: {   autoCommit }.  

    commitFrequency := AutoCodeReviewCommitFrequencyProjectMetric new  
        project: project1;  
        glhImporter: glhImporter;  
        setPeriodSince: since until: until;  
        over: Week.  

    "When"  
    result := commitFrequency calculate.  

    "Then - Only auto commits should be counted"  
    self assert: result equals: 1.

]

{ #category : #tests }
AutoCodeReviewCommitFrequencyProjectMetricTest >> testCalculateMultipleCommit [  
    | glhImporter result commitFrequency autoCommit1 autoCommit2 manuelcommit  |  

    "Given"  
    glhImporter := GLPHImporterMock new.  

    "Create an auto commit"  
    autoCommit1 := GLHCommit new  
        created_at: createdAt;  
        repository: project1 repository;  
        title: '[ACR][JS117R-2] rename my_param in camel case'.  
   autoCommit2 := GLHCommit new  
        created_at: createdAt;  
        repository: project1 repository;  
        title: '[ACR][JS117R-2] rename LOCAL in camel case'. 
   manuelcommit := GLHCommit new  
        created_at: createdAt;  
        repository: project1 repository;  
        title: 'commit manuel '. 

 
 
    glhImporter commits: { autoCommit1. autoCommit2 . manuelcommit}.  

    commitFrequency := AutoCodeReviewCommitFrequencyProjectMetric new  
        project: project1;  
        glhImporter: glhImporter;  
        setPeriodSince: since until: until;  
        over: Week.  

    "When"  
    result := commitFrequency calculate.  

    "Then - Only auto commits should be counted"  
    self assert: result equals: 2.

]

{ #category : #tests }
AutoCodeReviewCommitFrequencyProjectMetricTest >> testCalculateMultipleCommitDiffProejct [  
    | glhImporter result commitFrequency autoCommit1 autoCommit2 autoCommit3 autoCommit4 autoCommit5  |  

    "Given"  
    glhImporter := GLPHImporterMock new.  

    "Create an auto commit"  
    autoCommit1 := GLHCommit new  
        created_at: createdAt;  
        repository: project1 repository;  
        title: '[ACR][JS117R-2] rename my_param in camel case'.  
   autoCommit2 := GLHCommit new  
        created_at: createdAt;  
        repository: project2 repository;  
        title: '[ACR][JS117R-2] rename LOCAL in camel case'. 
 autoCommit3 := GLHCommit new  
        created_at: createdAt;  
        repository: project2 repository;  
        title: '[ACR][JS117R-2] rename LOCAL in camel case'. 
 autoCommit4 := GLHCommit new  
        created_at: createdAt;  
        repository: project2 repository;  
        title: '[ACR][JS117R-2] rename LOCAL in camel case'. 
    autoCommit5 := GLHCommit new  
        created_at: createdAt;  
        repository: project1 repository;  
        title: '[ACR][JS117R-2] rename LOCAL in camel case'. 
 
 
    glhImporter commits: { autoCommit1. autoCommit2 . autoCommit3 .autoCommit4 .autoCommit5 }.  

    commitFrequency := AutoCodeReviewCommitFrequencyProjectMetric new  
        project: project2;  
        glhImporter: glhImporter;  
        setPeriodSince: since until: until;  
        over: Week.  

    "When"  
    result := commitFrequency calculate.  

    "Then - Only auto commits should be counted"  
    self assert: result equals: 3.

]

{ #category : #tests }
AutoCodeReviewCommitFrequencyProjectMetricTest >> testCalculateNoCommit [  
    | glhImporter result commitFrequency Commit1 Commit2   |  

    "Given"  
    glhImporter := GLPHImporterMock new.  

    "Create an auto commit"  
   Commit1 := GLHCommit new  
        created_at: createdAt;  
        repository: project1 repository;  
        title: 'commit21'.  
  Commit2 := GLHCommit new  
        created_at: createdAt;  
        repository: project1 repository;  
        title: 'commit1'.  

 
 
    glhImporter commits: { Commit1. Commit2 }.  

    commitFrequency := AutoCodeReviewCommitFrequencyProjectMetric new  
        project: project1;  
        glhImporter: glhImporter;  
        setPeriodSince: since until: until;  
        over: Week.  

    "When"  
    result := commitFrequency calculate.  

    "Then - Only auto commits should be counted"  
    self assert: result equals: 0.

]
