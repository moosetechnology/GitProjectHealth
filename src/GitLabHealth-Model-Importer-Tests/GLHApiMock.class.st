Class {
	#name : #GLHApiMock,
	#superclass : #GLHApi,
	#category : #'GitLabHealth-Model-Importer-Tests'
}

{ #category : #'api - commits' }
GLHApiMock >> commitDiff: aCommitID ofProject: aProjectId unidiff: aBoolean [

	aCommitID = 'createError' ifTrue: [
		^ '{"message":"500 Internal Server Error"}' ]
]

{ #category : #api }
GLHApiMock >> user: aUserID [

	^ '{
    "id": 123,
    "username": "jack.dupond",
    "name": "dupond jack",
    "state": "active",
    "locked": false,
    "avatar_url": "https://gitlab.myCompany.com/uploads/-/system/user/avatar/123/avatar.png",
    "web_url": "https://gitlab.myCompany.com/Jack.Dupond",
    "created_at": "2021-06-19T21:11:06.114+02:00",
    "bio": "I am a very good developer. All my life I try to be as good as Badetitou",
    "location": "",
    "public_email": "jack.dupond-public@myCompany.com",
    "skype": "",
    "linkedin": "",
    "twitter": "",
    "discord": "",
    "website_url": "",
    "organization": "",
    "job_title": "",
    "pronouns": "",
    "bot": false,
    "work_information": null,
    "followers": 0,
    "following": 0,
    "is_followed": false,
    "local_time": "3:05 PM",
    "last_sign_in_at": "2024-10-31T09:16:46.412+01:00",
    "confirmed_at": "2021-06-19T21:11:05.919+02:00",
    "last_activity_on": "2024-11-04",
    "email": "jack.dupond@myCompany.com",
    "theme_id": 8,
    "color_scheme_id": 1,
    "projects_limit": 0,
    "current_sign_in_at": "2024-11-04T09:06:50.149+01:00",
    "identities": [
        {
            "provider": "azure_activedirectory_v2",
            "extern_uid": "3de29e50-1847-11ccd28ddc23e22a"
        }
    ],
    "can_create_group": false,
    "can_create_project": false,
    "two_factor_enabled": false,
    "external": false,
    "private_profile": false,
    "commit_email": "jack.dupond-commiter@myCompany.com",
    "is_admin": false,
    "note": null,
    "namespace_id": 1234,
    "created_by": null,
    "email_reset_offered_at": null,
    "highest_role": 50,
    "current_sign_in_ip": "10.12.0.12",
    "last_sign_in_ip": "10.12.0.12",
    "sign_in_count": 12345
}
	'
]
