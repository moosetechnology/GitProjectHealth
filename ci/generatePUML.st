documentor := FamixUMLDocumentor new.
documentor
	model: GLPHEModel color: Color white;
	model: GLHModel  color: Color white;
    excludeClasses: { GLHModel. TEntityMetaLevelDependency. Object . GLHEntity . GLPHEEntity . GLPHEModel . GLPHETEntityCreator . GLHTEntityCreator . GLHGroupGroup };
    generate.
    
'gitproject.puml' asFileReference writeStreamDo: [ :stream |
    FamixUMLPlantUMLBackend new
        outputStream:  stream;
        export: documentor umlEntities.
].

Smalltalk snapshot: false andQuit: true
