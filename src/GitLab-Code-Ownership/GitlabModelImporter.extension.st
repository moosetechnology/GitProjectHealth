Extension { #name : #GitlabModelImporter }

{ #category : #'*GitLab-Code-Ownership' }
GitlabModelImporter >> GetBlame: aGLHFile [ 
	| results  params   jsonObject  result |
			params := { 
		    #ref ->   aGLHFile branch name  .
	       } asDictionary.
	           results := self repoApi blames getBlameFile: aGLHFile path ofProject: aGLHFile branch repository project id withParams: params      .
              jsonObject := NeoJSONReader fromString: results .
              result:= (jsonObject isArray ifTrue: [jsonObject ] ifFalse: [nil]).
"              result:= result reject: [:item | item isNil]."
   ^result 
	

	
]

{ #category : #'*GitLab-Code-Ownership' }
GitlabModelImporter >> UserContributionFromBlames: blamesArray [
    | dictionary_Emails_Lines line blames   |
     "filter if  the blame isn't nil  bacause some file like media and photo dosn'thave blame  "
    blames := blamesArray reject: [:item | item isNil].
    "Step 1: Initialize dictionary to store email -> total lines count"
    dictionary_Emails_Lines := Dictionary new.
    "calculer le nombre totale des ligns "
    line :=  blames collect: [ :bl |
    bl  collect: [ :element |
	    |  lines |
        lines :=  ((element at: 'lines')size) .
    ]
   ].
    line:=( line flattened) sum .

    "Step 2: Process each blame dictionary"
     blames do: [:blameEntries |
        blameEntries isArray ifTrue: [  "Ensure it's a valid blame entry"
            blameEntries do: [:element | 
                | authorEmail linesSize |
                authorEmail := (element at: 'commit') at: 'author_email'.
                linesSize := (element at: 'lines') size.  "Number of lines modified"

                "Update dictionary (add lines if email exists, otherwise initialize)"
                (dictionary_Emails_Lines includesKey: authorEmail)
                    ifTrue: [ dictionary_Emails_Lines at: authorEmail put: ((dictionary_Emails_Lines at: authorEmail) + ((linesSize)/line)asFloat) ]
                    ifFalse: [ dictionary_Emails_Lines at: authorEmail put:((linesSize)/line)asFloat ].
            ].
        ].
    ].

    "Return the final dictionary of email -> total modified lines"
    ^ dictionary_Emails_Lines

]
