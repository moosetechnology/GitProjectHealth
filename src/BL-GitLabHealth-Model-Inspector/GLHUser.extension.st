Extension { #name : #GLHUser }

{ #category : #'*BL-GitLabHealth-Model-Inspector' }
GLHUser >> userView: aBuilder [

	<inspectorPresentationOrder: 0 title: 'View'>
	^ SpPresenter new layout: (SpBoxLayout new beTopToBottom
			   add: (SpBoxLayout new beLeftToRight
					    add: self username;
					    add: (aBuilder newImage
							     image: (ZnEasy getImg: self avatar_url);
							     autoScale: true;
							     yourself))
			   height: 100;
			   yourself)
]
