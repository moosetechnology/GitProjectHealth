Extension { #name : #GLHCommit }

{ #category : #'*GitLabHealth-Model-Extension' }
GLHCommit >> displayStringOn: aStream [

	aStream
		<< self short_id;
		<< ' ';
		<< self message
]
