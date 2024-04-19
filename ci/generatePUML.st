documentor := FamixUMLDocumentor new.
documentor
    model: GLHModel;
    beWithStubs;
    excludeClasses: { GLHModel. TEntityMetaLevelDependency. Object };
    generate.

'gitproject.puml' asFileReference writeStreamDo: [ :stream |
    FamixUMLPlantUMLBackend new
        outputStream:  stream;
        export: documentor umlEntities.
].

Smalltalk snapshot: false andQuit: true
