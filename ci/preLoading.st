
Iceberg remoteTypeSelector: #httpsUrl.

(IceRepositoryCreator new
	location: '.' asFileReference;
	subdirectory: 'src';
	createRepository) register
