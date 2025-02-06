Class {
	#name : #BitbucketPullRequestsMock,
	#superclass : #Object,
	#instVars : [
		'mergeRequests'
	],
	#category : #'BitBucketHealth-Model-Importer-Tests'
}

{ #category : #'api - get' }
BitbucketPullRequestsMock >> allSince: since until: until withParams: paramsDictionary inRepository: repositorySlug ofProject: projectKey [
		^ mergeRequests
]

{ #category : #initialization }
BitbucketPullRequestsMock >> initialize [ 
		mergeRequests := { self openedMergeRequest }
]

{ #category : #accessing }
BitbucketPullRequestsMock >> openedMergeRequest [

	| pullRequest |
	pullRequest := '{
      "id": 539,
      "version": 10,
      "title": "title",
      "state": "OPEN",
      "open": true,
      "closed": false,
      "createdDate": 1709726344893,
      "updatedDate": 1709728944248,
      "fromRef": {
        "id": "refs/heads/wip/1",
        "displayId": "wip/1",
        "latestCommit": "2",
        "repository": {
          "slug": "repoSlug",
          "id": 242,
          "name": "repo-name",
          "scmId": "git",
          "state": "AVAILABLE",
          "statusMessage": "Available",
          "forkable": true,
          "project": {
            "key": "project-key",
            "id": 242,
            "name": "project-name",
            "description": "project description",
            "public": true,
            "type": "NORMAL",
            "links": {
              "self": [
                {
                  "href": "link"
                }
              ]
            }
          },
          "public": false,
          "links": {
            "clone": [
              {
                "href": "clone",
                "name": "ssh"
              },
              {
                "href": "clone",
                "name": "http"
              }
            ],
            "self": [
              {
                "href": "link"
              }
            ]
          }
        }
      },
      "toRef": {
        "id": "refs/heads/develop/trunk",
        "displayId": "develop/trunk",
        "latestCommit": "3",
        "repository": {
          "slug": "repo-slug",
          "id": 242,
          "name": "repo-name",
          "scmId": "git",
          "state": "AVAILABLE",
          "statusMessage": "Available",
          "forkable": true,
          "project": {
            "key": "project-key",
            "id": 242,
            "name": "project-name",
            "description": "description",
            "public": true,
            "type": "NORMAL",
            "links": {
              "self": [
                {
                  "href": "link"
                }
              ]
            }
          },
          "public": false,
          "links": {
            "clone": [
              {
                "href": "link",
                "name": "ssh"
              },
              {
                "href": "link-http",
                "name": "http"
              }
            ],
            "self": [
              {
                "href": "link-self"
              }
            ]
          }
        }
      },
      "locked": false,
      "author": {
        "user": {
          "name": "user-name",
          "id": 1,
          "displayName": "user-display-name",
          "active": false,
          "slug": "user-slug",
          "type": "NORMAL",
          "links": {
            "self": [
              {
                "href": "link-self"
              }
            ]
          }
        },
        "role": "AUTHOR",
        "approved": false,
        "status": "UNAPPROVED"
      },
      "reviewers": [
        {
          "user": {
            "name": "reviewer-name",
            "emailAddress": "reviewer@email.com",
            "id": 1713,
            "displayName": "reviewer-display-name",
            "active": true,
            "slug": "reviewer-slug",
            "type": "NORMAL",
            "links": {
              "self": [
                {
                  "href": "link-self"
                }
              ]
            }
          },
          "lastReviewedCommit": "2",
          "role": "REVIEWER",
          "approved": true,
          "status": "APPROVED"
        },
        {
          "user": {
            "name": "reveiwer2-name",
            "emailAddress": "reviewer2@email.com",
            "id": 49,
            "displayName": "reviewer2 display name",
            "active": true,
            "slug": "reviewer2-slug",
            "type": "NORMAL",
            "links": {
              "self": [
                {
                  "href": "link-self"
                }
              ]
            }
          },
          "role": "REVIEWER",
          "approved": false,
          "status": "UNAPPROVED"
        }
      ],
      "participants": [],
      "properties": {
        "mergeResult": {
          "outcome": "CONFLICTED",
          "current": true
        },
        "resolvedTaskCount": 0,
        "commentCount": 4,
        "openTaskCount": 0
      },
      "links": {
        "self": [
          {
            "href": "link"
          }
        ]
      }
    }'.

	^ pullRequest := (NeoJSONReader on: pullRequest readStream) next
]
