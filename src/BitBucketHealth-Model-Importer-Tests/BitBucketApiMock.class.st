Class {
	#name : #BitBucketApiMock,
	#superclass : #Object,
	#category : #'BitBucketHealth-Model-Importer-Tests'
}

{ #category : #'api - projects' }
BitBucketApiMock >> commitsOfRepo: repositorySlug inProject: projectKey since: since until: until [

	| commits |
	commits := '[
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

	commits := (NeoJSONReader on: commits readStream) next.


	^ commits select: [ :commit |
		  | commitDate |
		  commitDate := DateAndTime fromUnixTime:
			                (commit at: #committerTimestamp) / 1000.
		  commitDate >= since asDate and: commitDate <= until asDate ]
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
