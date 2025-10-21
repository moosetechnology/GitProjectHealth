Class {
	#name : #GLHNotePosition,
	#superclass : #GLHEntity,
	#traits : 'FamixTNamedEntity',
	#classTraits : 'FamixTNamedEntity classTrait',
	#instVars : [
		'#file_path => FMProperty',
		'#original_file_path => FMProperty',
		'#start_line => FMProperty',
		'#start_line_type => FMProperty',
		'#end_line => FMProperty',
		'#end_line_type => FMProperty',
		'#note => FMOne type: #GLHNote opposite: #position'
	],
	#category : #'GitLabHealth-Model-Entities'
}

{ #category : #accessing }
GLHNotePosition >> end_line [

	^ end_line
]

{ #category : #accessing }
GLHNotePosition >> end_line: anObject [

	end_line := anObject
]

{ #category : #accessing }
GLHNotePosition >> end_line_type [

	^ end_line_type
]

{ #category : #accessing }
GLHNotePosition >> end_line_type: anObject [

	end_line_type := anObject
]

{ #category : #accessing }
GLHNotePosition >> file_path [

	^ file_path
]

{ #category : #accessing }
GLHNotePosition >> file_path: anObject [

	file_path := anObject
]

{ #category : #accessing }
GLHNotePosition >> note [

	^ note
]

{ #category : #accessing }
GLHNotePosition >> note: anObject [

	note := anObject
]

{ #category : #accessing }
GLHNotePosition >> original_file_path [

	^ original_file_path
]

{ #category : #accessing }
GLHNotePosition >> original_file_path: anObject [

	original_file_path := anObject
]

{ #category : #accessing }
GLHNotePosition >> start_line [

	^ start_line
]

{ #category : #accessing }
GLHNotePosition >> start_line: anObject [

	start_line := anObject
]

{ #category : #accessing }
GLHNotePosition >> start_line_type [

	^ start_line_type
]

{ #category : #accessing }
GLHNotePosition >> start_line_type: anObject [

	start_line_type := anObject
]
