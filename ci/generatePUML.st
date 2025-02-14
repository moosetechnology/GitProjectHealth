| documentor |

documentor := FamixUMLDocumentor new.
documentor
	model: GLHModel color: Color white;
    excludeClasses: { GLHModel. TEntityMetaLevelDependency. Object . GLHEntity . GLHTEntityCreator . GLHGroupGroup };
    generate.

'gitproject.puml' asFileReference writeStreamDo: [ :stream |
    FamixUMLPlantUMLBackend new
        outputStream:  stream;
        export: documentor umlEntities.
].

Smalltalk snapshot: false andQuit: true
