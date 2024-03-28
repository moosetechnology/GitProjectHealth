Extension { #name : #GLHUser }

{ #category : #'*GLPHExtended-Model-accessing' }
GLHUser >> assignedMergeRequests [
	"Relation named: #assignedMergeRequests type: #GLPHEMergeRequest opposite: #assignees"

	<generated>
	<FMProperty: #assignedMergeRequests type: #GLPHEMergeRequest opposite: #assignees>
	<package: #'GLPHExtended-Model'>
	^ self attributeAt: #assignedMergeRequests ifAbsentPut: [ FMMultiMultivalueLink on: self opposite: #assignees ]
]

{ #category : #'*GLPHExtended-Model-accessing' }
GLHUser >> assignedMergeRequests: anObject [

	<generated>
	self assignedMergeRequests value: anObject
]

{ #category : #'*GLPHExtended-Model-accessing' }
GLHUser >> closedMergeRequests [
	"Relation named: #closedMergeRequests type: #GLPHEMergeRequest opposite: #closed_by"

	<generated>
	<derived>
	<FMProperty: #closedMergeRequests type: #GLPHEMergeRequest opposite: #closed_by>
	<package: #'GLPHExtended-Model'>
	^ self attributeAt: #closedMergeRequests ifAbsentPut: [ FMMultivalueLink on: self opposite: #closed_by: ]
]

{ #category : #'*GLPHExtended-Model-accessing' }
GLHUser >> closedMergeRequests: anObject [

	<generated>
	self closedMergeRequests value: anObject
]

{ #category : #'*GLPHExtended-Model-accessing' }
GLHUser >> createdMergeRequests [
	"Relation named: #createdMergeRequests type: #GLPHEMergeRequest opposite: #author"

	<generated>
	<derived>
	<FMProperty: #createdMergeRequests type: #GLPHEMergeRequest opposite: #author>
	<package: #'GLPHExtended-Model'>
	^ self attributeAt: #createdMergeRequests ifAbsentPut: [ FMMultivalueLink on: self opposite: #author: ]
]

{ #category : #'*GLPHExtended-Model-accessing' }
GLHUser >> createdMergeRequests: anObject [

	<generated>
	self createdMergeRequests value: anObject
]

{ #category : #'*GLPHExtended-Model-accessing' }
GLHUser >> currentlyAssignedMergeRequest [
	"Relation named: #currentlyAssignedMergeRequest type: #GLPHEMergeRequest opposite: #assignee"

	<generated>
	<derived>
	<FMProperty: #currentlyAssignedMergeRequest type: #GLPHEMergeRequest opposite: #assignee>
	<package: #'GLPHExtended-Model'>
	^ self attributeAt: #currentlyAssignedMergeRequest ifAbsentPut: [ FMMultivalueLink on: self opposite: #assignee: ]
]

{ #category : #'*GLPHExtended-Model-accessing' }
GLHUser >> currentlyAssignedMergeRequest: anObject [

	<generated>
	self currentlyAssignedMergeRequest value: anObject
]

{ #category : #'*GLPHExtended-Model-accessing' }
GLHUser >> mergerOfMergeRequests [
	"Relation named: #mergerOfMergeRequests type: #GLPHEMergeRequest opposite: #merged_by"

	<generated>
	<derived>
	<FMProperty: #mergerOfMergeRequests type: #GLPHEMergeRequest opposite: #merged_by>
	<package: #'GLPHExtended-Model'>
	^ self attributeAt: #mergerOfMergeRequests ifAbsentPut: [ FMMultivalueLink on: self opposite: #merged_by: ]
]

{ #category : #'*GLPHExtended-Model-accessing' }
GLHUser >> mergerOfMergeRequests: anObject [

	<generated>
	self mergerOfMergeRequests value: anObject
]

{ #category : #'*GLPHExtended-Model-accessing' }
GLHUser >> reviewedMergeResquest [
	"Relation named: #reviewedMergeResquest type: #GLPHEMergeRequest opposite: #reviewers"

	<generated>
	<FMProperty: #reviewedMergeResquest type: #GLPHEMergeRequest opposite: #reviewers>
	<package: #'GLPHExtended-Model'>
	^ self attributeAt: #reviewedMergeResquest ifAbsentPut: [ FMMultiMultivalueLink on: self opposite: #reviewers ]
]

{ #category : #'*GLPHExtended-Model-accessing' }
GLHUser >> reviewedMergeResquest: anObject [

	<generated>
	self reviewedMergeResquest value: anObject
]

{ #category : #'*GLPHExtended-Model-accessing' }
GLHUser >> usedMerges [
	"Relation named: #usedMerges type: #GLPHEMergeRequest opposite: #merge_user"

	<generated>
	<derived>
	<FMProperty: #usedMerges type: #GLPHEMergeRequest opposite: #merge_user>
	<package: #'GLPHExtended-Model'>
	^ self attributeAt: #usedMerges ifAbsentPut: [ FMMultivalueLink on: self opposite: #merge_user: ]
]

{ #category : #'*GLPHExtended-Model-accessing' }
GLHUser >> usedMerges: anObject [

	<generated>
	self usedMerges value: anObject
]
