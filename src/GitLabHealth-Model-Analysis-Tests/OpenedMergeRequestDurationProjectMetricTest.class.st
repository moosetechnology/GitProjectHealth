"
An OpenedMergeRequestDurationProjectMetricTest is a test class for testing the behavior of OpenedMergeRequestDurationProjectMetric
"
Class {
	#name : #OpenedMergeRequestDurationProjectMetricTest,
	#superclass : #ProjectMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
OpenedMergeRequestDurationProjectMetricTest >> testCalculate [  
    | result glhImporter mergeRequestDuration durationInSeconds currentDate  |

    glhImporter := GLPHImporterMock new.  
      "to calculate the exact duration from the creation to the  current  date "
    createdAt := DateAndTime   year: 2024   month: 09  day: 04  hour: 00   minute: 0  second: 0.
     "Calculate expected open duration in seconds"
    currentDate := DateAndTime now.
    durationInSeconds := (currentDate - createdAt) asSeconds.

    glhImporter mergeRequests: {  
        (GLHMergeRequest new  
            project: project1 ;  
            created_at: createdAt).  
    }.  

    mergeRequestDuration := OpenedMergeRequestDurationProjectMetric new   
                               project: project1 ;  
                               glhImporter: glhImporter;  
                               setPeriodSince: since  
                               until: until;  
                               over: Week.  

    "When"
    result := mergeRequestDuration calculate.  

    "Then"
    self assert: result equals: durationInSeconds.

]

{ #category : #tests }
OpenedMergeRequestDurationProjectMetricTest >> testCalculate3MergeRequest [    
    | result glhImporter mergeRequestDuration  currentDate createdAt1 createdAt2 createdAt3 totalDuration averageDuration |

    glhImporter := GLPHImporterMock new.  

    "Define creation timestamps for three merge requests"
    createdAt1 := DateAndTime year: 2020 month: 05 day: 24 hour: 00 minute: 0 second: 0.
    createdAt2 := DateAndTime year: 2024 month: 09 day: 04 hour: 12 minute: 0 second: 0.
    createdAt3 := DateAndTime year: 2025 month: 02 day: 23 hour: 12 minute: 0 second: 0.
   
   

    "Calculate expected open duration in seconds for each request"
    currentDate := DateAndTime now.
    totalDuration := (currentDate - createdAt2) asSeconds .
    "Calculate average duration"
    averageDuration := totalDuration / 1.

    glhImporter mergeRequests: {  
        (GLHMergeRequest new project: project1 ; created_at: createdAt1).  
        (GLHMergeRequest new project: project1 ; created_at: createdAt2). 
        (GLHMergeRequest new project: project1 ; created_at: createdAt3).  
    }.  

    mergeRequestDuration := OpenedMergeRequestDurationProjectMetric new  
                               project: project1 ;  
                               glhImporter: glhImporter;  
                               setPeriodSince: since  
                               until: until;  
                               over: Week.  

    "When"
    result := mergeRequestDuration calculate.  

    "Then"
    self assert: result equals: totalDuration .


]

{ #category : #tests }
OpenedMergeRequestDurationProjectMetricTest >> testCalculateNoMergeRequests [

	| result glhImporter mergeRequestDuration |
	glhImporter := GLPHImporterMock new.

	mergeRequestDuration := OpenedMergeRequestDurationProjectMetric new
		                        project: project1 ;
		                        glhImporter: glhImporter;
		                        setPeriodSince: since
		                        until: until;
		                        over: Week.

	"When"
	result := mergeRequestDuration calculate.

	"Then"
	self assert: result equals: nil
]
