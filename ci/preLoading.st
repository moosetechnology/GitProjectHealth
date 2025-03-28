
Iceberg remoteTypeSelector: #httpsUrl.

(IceRepositoryCreator new
	location: '.' asFileReference;
	subdirectory: 'src';
	createRepository)
		name: 'GitProjectHealth';
		register
