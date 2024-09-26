Class {
	#name : #BitBucketApiMock,
	#superclass : #Object,
	#instVars : [
		'commits',
		'commits1',
		'diffs',
		'diffs1',
		'diffsWithoutHunks',
		'diffsWithoutAdded',
		'diffsWithoutRemoved'
	],
	#category : #'BitBucketHealth-Model-Importer-Tests'
}

{ #category : #accessing }
BitBucketApiMock >> commits [

	^ commits
]

{ #category : #accessing }
BitBucketApiMock >> commits1 [

	^ commits1
]

{ #category : #accessing }
BitBucketApiMock >> commits: anObject [

	commits := anObject
]

{ #category : #'api - projects' }
BitBucketApiMock >> commitsOfRepo: repositorySlug inProject: projectKey since: since until: until [

	^ self commits select: [ :commit |
		  | commitDate |
		  commitDate := DateAndTime fromUnixTime:
			                (commit at: #committerTimestamp) / 1000.
		  commitDate >= since asDate and: commitDate <= until asDate ]
]

{ #category : #accessing }
BitBucketApiMock >> diffs [

	^ diffs
]

{ #category : #accessing }
BitBucketApiMock >> diffs: anObject [

	diffs := anObject
]

{ #category : #'api - commits' }
BitBucketApiMock >> diffsOfCommit: commitID inRepo: repositorySlug inProject: projectKey [
	^diffs 
]

{ #category : #accessing }
BitBucketApiMock >> diffsWithoutAdded [

	^ diffsWithoutAdded
]

{ #category : #accessing }
BitBucketApiMock >> diffsWithoutHunks [

	^ diffsWithoutHunks
]

{ #category : #accessing }
BitBucketApiMock >> diffsWithoutRemoved [

	^ diffsWithoutRemoved
]

{ #category : #initialization }
BitBucketApiMock >> initialize [

	self initializeCommits.
	self initializeDiffs.
]

{ #category : #initialization }
BitBucketApiMock >> initializeCommits [

	commits1 := '[
    {
      "id": "abcdef0123abcdef4567abcdef8987abcdef6543",
		"message": "message test",
      "displayId": "abcdef0123a",
      "author": {
        "name": "charlie",
        "emailAddress": "charlie@example.com"
      },
      "authorTimestamp": 1727168151000,
      "committer": {
        "name": "charlie",
        "emailAddress": "charlie@example.com"
      },
      "committerTimestamp": 1727168151000,
      "message": "WIP on feature 1",
      "parents": [
        {
          "id": "abcdef0123abcdef4567abcdef8987abcdef6543",
          "displayId": "abcdef0"
        }
      ]
    }
  ]'.

	commits1 := (NeoJSONReader on: commits1 readStream) next.

	commits := commits1
]

{ #category : #initialization }
BitBucketApiMock >> initializeDiffs [

	diffs1 := '{
  "fromHash": null,
  "toHash": "123",
  "contextLines": 10,
  "whitespace": "SHOW",
  "diffs": [
    {
      "source": {
        "components": [
          "build.gradle"
        ],
        "parent": "",
        "name": "build.gradle",
        "extension": "gradle",
        "toString": "build.gradle"
      },
      "destination": {
        "components": [
          "build.gradle"
        ],
        "parent": "",
        "name": "build.gradle",
        "extension": "gradle",
        "toString": "build.gradle"
      },
      "hunks": [
        {
          "sourceLine": 1,
          "sourceSpan": 14,
          "destinationLine": 1,
          "destinationSpan": 14,
          "segments": [
            {
              "type": "CONTEXT",
              "lines": [
                {
                  "source": 3,
                  "destination": 3,
                  "line": " line",
                  "truncated": false
                }
              ],
              "truncated": false
            },
            {
              "type": "REMOVED",
              "lines": [
                {
                  "source": 4,
                  "destination": 4,
                  "line": "line4",
                  "truncated": false
                }
              ],
              "truncated": false
            },
            {
              "type": "ADDED",
              "lines": [
                {
                  "source": 5,
                  "destination": 4,
                  "line": "line5",
                  "truncated": false
                }
              ],
              "truncated": false
            },
            {
              "type": "CONTEXT",
              "lines": [
                {
                  "source": 14,
                  "destination": 14,
                  "line": "",
                  "truncated": false
                }
              ],
              "truncated": false
            }
          ],
          "truncated": false
        }
      ],
      "truncated": false
    }
  ],
  "truncated": false
}'.

	diffs1 := (NeoJSONReader on: diffs1 readStream) next.

	diffsWithoutHunks := '{
  "fromHash": null,
  "toHash": "2",
  "contextLines": 10,
  "whitespace": "SHOW",
  "diffs": [
    {
      "source": {
        "components": [
          "build.gradle"
        ],
        "parent": "",
        "name": "build.gradle",
        "extension": "gradle",
        "toString": "build.gradle"
      },
      "destination": {
        "components": [
          "build.gradle"
        ],
        "parent": "",
        "name": "build.gradle",
        "extension": "gradle",
        "toString": "build.gradle"
      },
          
      "truncated": false
    }
  ],
  "truncated": false
}'.

	diffsWithoutHunks := (NeoJSONReader on: diffsWithoutHunks readStream)
		                     next.

	diffsWithoutAdded := '{
  "fromHash": null,
  "toHash": "3",
  "contextLines": 10,
  "whitespace": "SHOW",
  "diffs": [
    {
      "source": {
        "components": [
          "build.gradle"
        ],
        "parent": "",
        "name": "build.gradle",
        "extension": "gradle",
        "toString": "build.gradle"
      },
      "destination": {
        "components": [
          "build.gradle"
        ],
        "parent": "",
        "name": "build.gradle",
        "extension": "gradle",
        "toString": "build.gradle"
      },
      "hunks": [
        {
          "sourceLine": 1,
          "sourceSpan": 14,
          "destinationLine": 1,
          "destinationSpan": 14,
          "segments": [
            {
              "type": "CONTEXT",
              "lines": [
                {
                  "source": 1,
                  "destination": 1,
                  "line": "line1",
                  "truncated": false
                },
                {
                  "source": 2,
                  "destination": 2,
                  "line": "line2",
                  "truncated": false
                },
                {
                  "source": 3,
                  "destination": 3,
                  "line": "line3",
                  "truncated": false
                }
              ],
              "truncated": false
            },
            {
              "type": "REMOVED",
              "lines": [
                {
                  "source": 4,
                  "destination": 4,
                  "line": "line4",
                  "truncated": false
                }
              ],
              "truncated": false
            },
            {
              "type": "CONTEXT",
              "lines": [
                {
                  "source": 5,
                  "destination": 5,
                  "line": "",
                  "truncated": false
                }
              ],
              "truncated": false
            }
          ],
          "truncated": false
        }
      ],
      "truncated": false
    }
  ],
  "truncated": false
}'.

	diffsWithoutAdded := (NeoJSONReader on: diffsWithoutAdded readStream)
		                     next.


	diffsWithoutRemoved := '{
  "fromHash": null,
  "toHash": "1",
  "contextLines": 10,
  "whitespace": "SHOW",
  "diffs": [
    {
      "source": {
        "components": [
          "build.gradle"
        ],
        "parent": "",
        "name": "build.gradle",
        "extension": "gradle",
        "toString": "build.gradle"
      },
      "destination": {
        "components": [
          "build.gradle"
        ],
        "parent": "",
        "name": "build.gradle",
        "extension": "gradle",
        "toString": "build.gradle"
      },
      "hunks": [
        {
          "sourceLine": 1,
          "sourceSpan": 14,
          "destinationLine": 1,
          "destinationSpan": 14,
          "segments": [
            {
              "type": "CONTEXT",
              "lines": [
                {
                  "source": 3,
                  "destination": 3,
                  "line": " line",
                  "truncated": false
                }
              ],
              "truncated": false
            },
            {
              "type": "ADDED",
              "lines": [
                {
                  "source": 5,
                  "destination": 4,
                  "line": "    test2",
                  "truncated": false
                }
              ],
              "truncated": false
            },
            {
              "type": "CONTEXT",
              "lines": [
                {
                  "source": 6,
                  "destination": 6,
                  "line": "",
                  "truncated": false
                }
              ],
              "truncated": false
            }
          ],
          "truncated": false
        }
      ],
      "truncated": false
    }
  ],
  "truncated": false
}'.

	diffsWithoutRemoved := (NeoJSONReader on:
		                        diffsWithoutRemoved readStream) next.

	diffs := diffs1
]

{ #category : #accessing }
BitBucketApiMock >> projects [

	| projects |
	projects := '[
    {
      "key": "PRJ",
      "id": 1,
      "name": "My Cool Project",
      "description": "The description for my cool project.",
      "public": true,
      "type": "NORMAL",
      "links": {
        "self": [{"href": "http://link/to/project"}]
      }
    }
  ],
'.

	projects := (NeoJSONReader on: projects readStream) next.

	^ projects
]

{ #category : #'api - projects' }
BitBucketApiMock >> repositoriesOfProject: projectKey [

	| repos |
	repos := '[
    {
      "slug": "my-repo",
      "id": 1,
      "name": "My repo",
      "scmId": "git",
      "state": "AVAILABLE",
      "statusMessage": "Available",
      "forkable": true,
      "project": {
        "key": "PRJ",
        "id": 1,
        "name": "My Cool Project",
        "description": "The description for my cool project.",
        "public": true,
        "type": "NORMAL",
        "links": {
          "self": [{"href": "http://link/to/project"}]
        }
      },
      "public": true,
      "links": {
        "clone": [
          {"href": "ssh://git@<baseURL>/PRJ/my-repo.git", "name": "ssh"},
          {"href": "https://<baseURL>/scm/PRJ/my-repo.git", "name": "http"}
        ],
        "self": [{"href": "http://link/to/repository"}]
      }
    }
  ],'.

repos := (NeoJSONReader on: repos readStream) next.

^repos
]

{ #category : #accessing }
BitBucketApiMock >> user: accountId [

	| user |
	user := '{
        "type": "user",
        "nickname": "evzijst",
        "display_name": "Erik van Zijst",
		  "created_on": "12-04-2024",
        "uuid": "{d301aafa-d676-4ee0-88be-962be7417567}"
   }'.

	^ user
]
