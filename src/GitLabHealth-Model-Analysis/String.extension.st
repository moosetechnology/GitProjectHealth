Extension { #name : 'String' }

{ #category : '*GitLabHealth-Model-Analysis' }
String >> absLevenshteinDistanceWith: aString [ 
	        ^ { self levenshteinDistanceWith: aString .
					aString levenshteinDistanceWith: self  } max.
]

{ #category : '*GitLabHealth-Model-Analysis' }
String >> levenshteinDistanceWith: aString [ 
	          | m n distances cost |

        m := self size.
        n := aString size.

        "Initialize a 2D array (m+1 x n+1) to store distances"
        distances := Array2D rows: m+1 columns: n+1 element: 0. 
		
        "Fill base cases for first row and first column"
        1 to: m do: [ :i | distances at: i+1 at: 1 put: i ].
        1 to: n do: [ :j | distances at: 1 at: j+1 put: j ].


        "Compute distances using dynamic programming"
        2 to: m do: [ :i |
            2 to: n do: [ :j |
                cost := (self at: i) = (aString at: j) ifTrue: [ 0 ] ifFalse: [ 1 ].
                distances at: (i) at: (j) put: { 
							((distances at: i-1 at: j) + 1) .
							 ((distances at: 1 at: j-1) + 1) .
							((distances at: i-1 at: j-1) + cost) .
						 } min .
            ].
        ].

        "Return the Levenshtein distance between the two strings"
        ^ distances at: m at: n
]
