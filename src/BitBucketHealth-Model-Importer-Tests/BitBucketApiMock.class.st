Class {
	#name : #BitBucketApiMock,
	#superclass : #Object,
	#instVars : [
		'userMock',
		'commitsMock',
		'diffs',
		'mergeRequests'
	],
	#category : #'BitBucketHealth-Model-Importer-Tests'
}

{ #category : #'mock - commits' }
BitBucketApiMock >> commit2 [

	| commits2 |
	commits2 := '
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
  '.

	^ commits2 := (NeoJSONReader on: commits2 readStream) next
]

{ #category : #ressources }
BitBucketApiMock >> commits [

	^ BitBucketCommitsMock new commitsMock: commitsMock; diffs: diffs.
]

{ #category : #'mock - commits' }
BitBucketApiMock >> commits1 [

	| commits1 |
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

	^ commits1 := (NeoJSONReader on: commits1 readStream) next
]

{ #category : #'mock - commits' }
BitBucketApiMock >> commitsMock [

	^ commitsMock
]

{ #category : #'mock - commits' }
BitBucketApiMock >> commitsMock: anObject [

	commitsMock := anObject
]

{ #category : #'mock - mergeRequests' }
BitBucketApiMock >> declinedMergeRequest [

	| pullRequest |
	pullRequest := '{
      "id": 539,
      "version": 10,
      "title": "title",
      "state": "DECLINED",
      "open": false,
      "closed": true,
  		"createdDate": 1721396425473,
  		"updatedDate": 1721457513310,
  		"closedDate": 1721457513310,
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

{ #category : #'mock - diffs' }
BitBucketApiMock >> diffs [

	^ diffs
]

{ #category : #'mock - diffs' }
BitBucketApiMock >> diffs1 [

	| diffs1 |
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

	^ diffs1 := (NeoJSONReader on: diffs1 readStream) next
]

{ #category : #'mock - diffs' }
BitBucketApiMock >> diffs: anObject [

	diffs := anObject
]

{ #category : #'mock - diffs' }
BitBucketApiMock >> diffsNohunks [

	| diffs1 |
	diffs1 := '{
  "fromHash": null,
  "toHash": "123",
  "contextLines": 10,
  "whitespace": "SHOW",
  "diffs": [
      {
      "source": null,
      "destination": {
        "components": [
          "api",
          "api.xlsx"
        ],
        "parent": "api",
        "name": "api.xlsx",
        "extension": "xlsx",
        "toString": "api/api.xlsx"
      },
      "binary": true
    }
  ],
  "truncated": false
}'.

	^ diffs1 := (NeoJSONReader on: diffs1 readStream) next
]

{ #category : #'mock - diffs' }
BitBucketApiMock >> diffsWithoutAdded [

	| diffsWithoutAdded |
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

	^ diffsWithoutAdded := (NeoJSONReader on:
		                        diffsWithoutAdded readStream) next
]

{ #category : #'mock - diffs' }
BitBucketApiMock >> diffsWithoutHunks [

	| diffsWithoutHunks |
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

	^ diffsWithoutHunks := (NeoJSONReader on:
		                        diffsWithoutHunks readStream) next
]

{ #category : #'mock - diffs' }
BitBucketApiMock >> diffsWithoutRemoved [

	| diffsWithoutRemoved |
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

	^ diffsWithoutRemoved := (NeoJSONReader on:
		                          diffsWithoutRemoved readStream) next
]

{ #category : #initialization }
BitBucketApiMock >> initialize [

	commitsMock := self commits1.
	diffs := self diffs1.
	userMock := self user1.
	mergeRequests := { self openedMergeRequest }
]

{ #category : #'mock - mergeRequests' }
BitBucketApiMock >> mergeRequests [

	^ mergeRequests
]

{ #category : #'mock - mergeRequests' }
BitBucketApiMock >> mergeRequests: anObject [

	mergeRequests := anObject
]

{ #category : #'mock - mergeRequests' }
BitBucketApiMock >> mergedMergeRequest [

	| pullRequest |
	pullRequest := '{
      "id": 539,
      "version": 10,
      "title": "title",
      "state": "MERGED",
      "open": false,
      "closed": true,
  		"createdDate": 1721396425473,
  		"updatedDate": 1721457513310,
  		"closedDate": 1721457513310,
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

{ #category : #'mock - mergeRequests' }
BitBucketApiMock >> openedMergeRequest [

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

	^pullRequest := (NeoJSONReader on: pullRequest readStream) next.
]

{ #category : #ressources }
BitBucketApiMock >> projects [

	^BitBucketProjectsMock new
]

{ #category : #'mock - projects' }
BitBucketApiMock >> projectsMock [

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

{ #category : #'mock - mergeRequests' }
BitBucketApiMock >> pullRequestActivities [

	| pullRequestActivities |
	pullRequestActivities := '
    [{
      "id": 1,
      "createdDate": 1720510446734,
      "user": {
        "name": "user-name",
        "emailAddress": "user-name@email.com",
        "id": 24,
        "displayName": "user name",
        "active": true,
        "slug": "un",
        "type": "NORMAL",
        "links": {
          "self": [
            {
              "href": "link"
            }
          ]
        }
      },
      "action": "MERGED"
}]'.

	^ pullRequestActivities := (NeoJSONReader on:
		                            pullRequestActivities readStream) next
]

{ #category : #ressources }
BitBucketApiMock >> pullRequests [

	^ BitbucketPullRequestsMock new mergeRequests: mergeRequests.
]

{ #category : #ressources }
BitBucketApiMock >> repositories [
	^BitBucketRepositoriesMock new.
]

{ #category : #'mock - repositories' }
BitBucketApiMock >> repositoriesMock [

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

	^ repos
]

{ #category : #'mock - users' }
BitBucketApiMock >> user1 [

	| user1 |
	user1 := '
    {
      "name": "test",
      "emailAddress": "test@test.com",
      "id": 1,
      "displayName": "test test",
      "active": true,
      "slug": "test",
      "type": "NORMAL",
      "directoryName": "directory",
      "deletable": false,
      "lastAuthenticationTimestamp": 1727444943000,
      "mutableDetails": false,
      "mutableGroups": true,
      "links": {
        "self": [
          {
            "href": "test.com"
          }
        ]
      }
    }
  '.


	^ user1 := (NeoJSONReader on: user1 readStream) next
]

{ #category : #'mock - users' }
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

{ #category : #'mock - users' }
BitBucketApiMock >> userMock [

	^ userMock
]

{ #category : #'mock - users' }
BitBucketApiMock >> userMock: anObject [

	userMock := anObject
]

{ #category : #ressources }
BitBucketApiMock >> users [

	^ BitbucketUsersMock new userMock: userMock.
]
