Extension { #name : #LGitPatch }

{ #category : #'*GitProjectHealth-Model-LocalImporter' }
LGitPatch >> patchString [	
	| buf patchString |
	buf := LGitBuf new.
	self patch_to_buf: buf.
	patchString := buf prim_ptr utf8StringFromCString.
	buf free.
	^ patchString
]

{ #category : #'*GitProjectHealth-Model-LocalImporter' }
LGitPatch >> patch_to_buf: out [

	^ self
		  ffiCallSafely:
			  #( LGitReturnCodeEnum git_patch_to_buf #( LGitBuf * out , LGitPatch
			        self ) )
		  options: #( optMayGC optCoerceNilToNull )
]
