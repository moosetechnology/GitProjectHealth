"
A GHModelImporterTest is a test class for testing the behavior of GHModelImporter
"
Class {
	#name : 'GHModelImporterTest',
	#superclass : 'TestCase',
	#instVars : [
		'importer'
	],
	#category : 'GitHubHealth-Model-Importer-Tests',
	#package : 'GitHubHealth-Model-Importer-Tests'
}

{ #category : 'running' }
GHModelImporterTest >> setUp [
	super setUp.

	importer := GHModelImporter new
]

{ #category : 'tests' }
GHModelImporterTest >> testParseCommitsResult [

	| commits |
	commits := importer parseCommitsResult: '[
  {
    "sha": "f5ac58f4afe4632b0a26d1e968439c78962da289",
    "node_id": "C_kwDOAmR199oAKGY1YWM1OGY0YWZlNDYzMmIwYTI2ZDFlOTY4NDM5Yzc4OTYyZGEyODk",
    "commit": {
      "author": {
        "name": "Clotilde Toullec",
        "email": "39184695+ClotildeToullec@users.noreply.github.com",
        "date": "2024-09-09T14:32:48Z"
      },
      "committer": {
        "name": "GitHub",
        "email": "noreply@github.com",
        "date": "2024-09-09T14:32:48Z"
      },
      "message": "Update test-and-release.yml",
      "tree": {
        "sha": "d6163cb0d50d0e6fe149e3c92b22b13cf2c253f1",
        "url": "https://api.github.com/repos/moosetechnology/Moose/git/trees/d6163cb0d50d0e6fe149e3c92b22b13cf2c253f1"
      },
      "url": "https://api.github.com/repos/moosetechnology/Moose/git/commits/f5ac58f4afe4632b0a26d1e968439c78962da289",
      "comment_count": 0,
      "verification": {
        "verified": true,
        "reason": "valid",
        "signature": "-----BEGIN PGP SIGNATURE-----\n\nwsFcBAABCAAQBQJm3wcQCRC1aQ7uu5UhlAAAQ7kQAJOUaDn2VQd1VHl7LbmYSF/R\nTaV6o9Ck1RzeZQRKKhIeofERpItb726h8IPtDh7AcS7c97D0+Opv3c8x7GXvgfzi\ne+XhZ2FErra11pd1AXW1bZwlCEp2KhBEkTXEhKZK8Yg18z/1/hGR3gE27P1qBU7N\nm6pGDVPapdKVmljbteCGprUGcDe9uKqg9sj1YONXNDVm7pAYSrQXOnqfUKm/sFDm\n3wdLVr+U0jshg4Obhy+kxPHqNCxEFCPov4SxUJ0Fx6L4Gg90K4qQ3GwiuSUbwNGP\nAbopNPdNfcWlK2Zzez1e2GiaSwBjhcADkSQ1aGveINuE34KAe/yYd1BRuIW7BtDK\nc+qSGD98KyfNNxPBwv/JyPh76CvDghexgz8+j3PKE+SQkwPHKfJjHbB3Ool4RwY2\npeHU1E1mj0O29a+y6iUcYGyRXkAzBC+B86PJ5QC7dQvklLHZfX2uIFw3tr2ZlunC\nbjhLN7Vnor6BPocSLPdPanOrZXDmoy6grUhyNSgvCuoiRZ9HoG3NREn4GLEFIjLd\nNKxnS8Zim8QQnd2lvvunz7Gge6mfwWLGMIX4MPC3BQUYhZ6i2nx7vqIID0cEyWlj\n6K+tUj/MJkgj0EcnBL8HC1AIiJeJk9hTBdOHrJj3/kvM/0HIrAg+PQEdK0y2iYLp\nxXqau3U95zTp2792mpVc\n=n2IL\n-----END PGP SIGNATURE-----\n",
        "payload": "tree d6163cb0d50d0e6fe149e3c92b22b13cf2c253f1\nparent eb31d04f01254d0caf7c7a5b03546e3f6a5c3d58\nauthor Clotilde Toullec <39184695+ClotildeToullec@users.noreply.github.com> 1725892368 +0200\ncommitter GitHub <noreply@github.com> 1725892368 +0200\n\nUpdate test-and-release.yml"
      }
    },
    "url": "https://api.github.com/repos/moosetechnology/Moose/commits/f5ac58f4afe4632b0a26d1e968439c78962da289",
    "html_url": "https://github.com/moosetechnology/Moose/commit/f5ac58f4afe4632b0a26d1e968439c78962da289",
    "comments_url": "https://api.github.com/repos/moosetechnology/Moose/commits/f5ac58f4afe4632b0a26d1e968439c78962da289/comments",
    "author": {
      "login": "ClotildeToullec",
      "id": 39184695,
      "node_id": "MDQ6VXNlcjM5MTg0Njk1",
      "avatar_url": "https://avatars.githubusercontent.com/u/39184695?v=4",
      "gravatar_id": "",
      "url": "https://api.github.com/users/ClotildeToullec",
      "html_url": "https://github.com/ClotildeToullec",
      "followers_url": "https://api.github.com/users/ClotildeToullec/followers",
      "following_url": "https://api.github.com/users/ClotildeToullec/following{/other_user}",
      "gists_url": "https://api.github.com/users/ClotildeToullec/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/ClotildeToullec/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/ClotildeToullec/subscriptions",
      "organizations_url": "https://api.github.com/users/ClotildeToullec/orgs",
      "repos_url": "https://api.github.com/users/ClotildeToullec/repos",
      "events_url": "https://api.github.com/users/ClotildeToullec/events{/privacy}",
      "received_events_url": "https://api.github.com/users/ClotildeToullec/received_events",
      "type": "User",
      "site_admin": false
    },
    "committer": {
      "login": "web-flow",
      "id": 19864447,
      "node_id": "MDQ6VXNlcjE5ODY0NDQ3",
      "avatar_url": "https://avatars.githubusercontent.com/u/19864447?v=4",
      "gravatar_id": "",
      "url": "https://api.github.com/users/web-flow",
      "html_url": "https://github.com/web-flow",
      "followers_url": "https://api.github.com/users/web-flow/followers",
      "following_url": "https://api.github.com/users/web-flow/following{/other_user}",
      "gists_url": "https://api.github.com/users/web-flow/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/web-flow/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/web-flow/subscriptions",
      "organizations_url": "https://api.github.com/users/web-flow/orgs",
      "repos_url": "https://api.github.com/users/web-flow/repos",
      "events_url": "https://api.github.com/users/web-flow/events{/privacy}",
      "received_events_url": "https://api.github.com/users/web-flow/received_events",
      "type": "User",
      "site_admin": false
    },
    "parents": [
      {
        "sha": "eb31d04f01254d0caf7c7a5b03546e3f6a5c3d58",
        "url": "https://api.github.com/repos/moosetechnology/Moose/commits/eb31d04f01254d0caf7c7a5b03546e3f6a5c3d58",
        "html_url": "https://github.com/moosetechnology/Moose/commit/eb31d04f01254d0caf7c7a5b03546e3f6a5c3d58"
      }
    ]
  },
  {
    "sha": "eb31d04f01254d0caf7c7a5b03546e3f6a5c3d58",
    "node_id": "C_kwDOAmR199oAKGViMzFkMDRmMDEyNTRkMGNhZjdjN2E1YjAzNTQ2ZTNmNmE1YzNkNTg",
    "commit": {
      "author": {
        "name": "Clotilde Toullec",
        "email": "39184695+ClotildeToullec@users.noreply.github.com",
        "date": "2024-09-09T14:23:04Z"
      },
      "committer": {
        "name": "GitHub",
        "email": "noreply@github.com",
        "date": "2024-09-09T14:23:04Z"
      },
      "message": "Update release.yml",
      "tree": {
        "sha": "2603616f5508d52a14de694ebfd36a4fe3d92c32",
        "url": "https://api.github.com/repos/moosetechnology/Moose/git/trees/2603616f5508d52a14de694ebfd36a4fe3d92c32"
      },
      "url": "https://api.github.com/repos/moosetechnology/Moose/git/commits/eb31d04f01254d0caf7c7a5b03546e3f6a5c3d58",
      "comment_count": 0,
      "verification": {
        "verified": true,
        "reason": "valid",
        "signature": "-----BEGIN PGP SIGNATURE-----\n\nwsFcBAABCAAQBQJm3wTJCRC1aQ7uu5UhlAAAMVsQADtx9h/p+gZpgOZfWwGUgV1O\nk8HSuq+Q1Z/OMg22+zvTYw77qS7ni+jFn34XYGpZECbMybTobqT8bRWvKGaoyhE3\n054OutXJLRhh/6Siy1AI9Bcr/huLWHzQ0faU4M4mO+SS/RQF1yfqCNzyDFfafWEU\nxnlf1CpdknoWAAjN2kaNBXvBBmTBOPZQ5mP+j7Mi2U4DvoG/2NpB9QhkjE0zdw0Z\nddApTKCe4QkrtFfLTJ3NJuWoCoNif+8leyfAsE4iqonZvhUKly/9EdZuhR8QgbrE\nunDk9RF9IoZDR4b1Sz/qY+ajd1IXqYNRQg0Aihb5DDzQY8tZsZRmrlSKw/xqwTOf\nOy5rO9MWSGHFqnRbWZfgzWYgE/w0pvbL3Z9ahsYbHJaWcxSX9BcfV1KbN5ygm9Bx\nlDUr8D2scOrmr+Eg4LdmJxtZB6eEJfPA34H/PY5IZvQDkbFyzPJm4IUfRRFmEwLy\nx1JmE/bVBl1q0YaLiDW856y5yAAkYfRlkHVhqgya6kfaWEHNMl4r0od8M4PbNF9F\n/Qx4VNqQH+u+iThn8l9BDA0B2NrPu5rUyz+SAo/OjRuBoVv+yiYBaevLzkuLOhkL\noUxYduwo9bT2imkiOvKEAsXpNPjuraf6gHUkY9OxinnEp6AWe/qyqc5duhFSJuzC\nAVA3RPqe7kvwqnWKurpZ\n=bDEh\n-----END PGP SIGNATURE-----\n",
        "payload": "tree 2603616f5508d52a14de694ebfd36a4fe3d92c32\nparent cfa833e9c504fe1f27c93fca016a5006cc300206\nauthor Clotilde Toullec <39184695+ClotildeToullec@users.noreply.github.com> 1725891784 +0200\ncommitter GitHub <noreply@github.com> 1725891784 +0200\n\nUpdate release.yml"
      }
    },
    "url": "https://api.github.com/repos/moosetechnology/Moose/commits/eb31d04f01254d0caf7c7a5b03546e3f6a5c3d58F",
    "html_url": "https://github.com/moosetechnology/Moose/commit/eb31d04f01254d0caf7c7a5b03546e3f6a5c3d58",
    "comments_url": "https://api.github.com/repos/moosetechnology/Moose/commits/eb31d04f01254d0caf7c7a5b03546e3f6a5c3d58/comments",
    "author": {
      "login": "ClotildeToullec",
      "id": 39184695,
      "node_id": "MDQ6VXNlcjM5MTg0Njk1",
      "avatar_url": "https://avatars.githubusercontent.com/u/39184695?v=4",
      "gravatar_id": "",
      "url": "https://api.github.com/users/ClotildeToullec",
      "html_url": "https://github.com/ClotildeToullec",
      "followers_url": "https://api.github.com/users/ClotildeToullec/followers",
      "following_url": "https://api.github.com/users/ClotildeToullec/following{/other_user}",
      "gists_url": "https://api.github.com/users/ClotildeToullec/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/ClotildeToullec/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/ClotildeToullec/subscriptions",
      "organizations_url": "https://api.github.com/users/ClotildeToullec/orgs",
      "repos_url": "https://api.github.com/users/ClotildeToullec/repos",
      "events_url": "https://api.github.com/users/ClotildeToullec/events{/privacy}",
      "received_events_url": "https://api.github.com/users/ClotildeToullec/received_events",
      "type": "User",
      "site_admin": false
    },
    "committer": {
      "login": "web-flow",
      "id": 19864447,
      "node_id": "MDQ6VXNlcjE5ODY0NDQ3",
      "avatar_url": "https://avatars.githubusercontent.com/u/19864447?v=4",
      "gravatar_id": "",
      "url": "https://api.github.com/users/web-flow",
      "html_url": "https://github.com/web-flow",
      "followers_url": "https://api.github.com/users/web-flow/followers",
      "following_url": "https://api.github.com/users/web-flow/following{/other_user}",
      "gists_url": "https://api.github.com/users/web-flow/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/web-flow/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/web-flow/subscriptions",
      "organizations_url": "https://api.github.com/users/web-flow/orgs",
      "repos_url": "https://api.github.com/users/web-flow/repos",
      "events_url": "https://api.github.com/users/web-flow/events{/privacy}",
      "received_events_url": "https://api.github.com/users/web-flow/received_events",
      "type": "User",
      "site_admin": false
    },
    "parents": [
      {
        "sha": "cfa833e9c504fe1f27c93fca016a5006cc300206",
        "url": "https://api.github.com/repos/moosetechnology/Moose/commits/cfa833e9c504fe1f27c93fca016a5006cc300206",
        "html_url": "https://github.com/moosetechnology/Moose/commit/cfa833e9c504fe1f27c93fca016a5006cc300206"
      }
    ]
  }
]'.

	self assert: commits size equals: 2.
	self assert: commits first message equals: 'Update test-and-release.yml'.
	self assert: commits second message equals: 'Update release.yml'.
]

{ #category : 'test' }
GHModelImporterTest >> testParsePipelinesResult [

	| project |
	project := importer parsePipelinesResult: '{
  "total_count": 1,
  "workflow_runs": [
    {
      "id": 7482814798,
      "conclusion": "success",
      "run_started_at": "2024-01-11T00:00:00"
    }]}'.

	self assert: project workflow_runs size equals: 1.

	self assert: project workflow_runs anyOne status equals: 'success'.
	self
		assert: project workflow_runs anyOne runDate
		equals: (DateAndTime year: 2024 month: 01 day: 11)
]
