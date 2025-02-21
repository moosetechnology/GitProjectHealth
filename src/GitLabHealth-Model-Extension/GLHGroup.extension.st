Extension { #name : #GLHGroup }

{ #category : #'*GitLabHealth-Model-Extension' }
GLHGroup >> allProjectstoScope [
	"return the all the projects and subprojects of this group"
	^ self toScope: GLHProject
]
