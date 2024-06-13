# GitProject health

This project includes a model, an importer, and some visulization to evaluate the health of a GitLab or GitHub group.

## Installation

Download a [Moose image](https://modularmoose.org/moose-wiki/Beginners/InstallMoose).

In the Moose image, in a playground (`Ctrl+O`, `Ctrl+W`), perform:

```st
Metacello new
  repository: 'github://moosetechnology/GitProjectHealth:main/src';
  baseline: 'GitLabHealth';
  onConflict: [ :ex | ex useIncoming ];
  onUpgrade: [ :ex | ex useIncoming ];
  onDowngrade: [ :ex | ex useLoaded ];
  load
```

## Usages

### Import

#### Group import: GitLab

In a playground (`Ctrl+O`, `Ctrl+W`).

```st
glhModel := GLHModel new.

glhApi := GLHApi new
    privateToken: '<Your private token>';
    baseAPIUrl:'https://gitlab.myPrivateHost.com/api/v4';
    yourself.

glhImporter := GLHModelImporter new
    glhApi: glhApi;
    glhModel: glhModel.


"137 is the ID of the a Group, you can find the number in the webpage of every project and group"
glhImporter importGroup: 137.
```

#### Group import: GitHub

In a playground (`Ctrl+O`, `Ctrl+W`).

```st
glhModel := GLHModel new.

githubImporter := GHModelImporter new glhModel: glhModel; privateToken: '<my private token>'; yourself.

githubImporter importGroup: 'moosetechnology'.
```

#### More commits extracted

> GitLab API only

You might want to gather more commits for a specific repository.
To do so in GitLab, we added the following API

```st
myProject := ((glhModel allWithType: GLHProject) select: [ :project | project name = '<my projectName>' ]) anyOne.

glhImporter importCommitsOf: myProject withStats: true until: '2023-01-01' asDate.
```

### Visualize

To visualize the group "health"

```st
dritGroup := (glhModel allWithType: GLHGroup) detect: [ :group | group id = 137 ].
canvas := (GLHGroupVisualization new forGroup: dritGroup).
canvas open.
```

### Export

To export the visualization as a svg image

```st
dritGroup := (glhModel allWithType: GLHGroup) detect: [ :group | group id = 137 ].
canvas := (GLHGroupVisualization new forGroup: dritGroup).
canvas open.

canvas svgExporter
  withoutFixedShapes;
  fileName: 'drit-group-health';
  export.
```

## Metamodel

Here is the metamodel used in this project

```mermaid
classDiagram
    class Group {
        avatar_url
        name
        id
        web_url
        description
        visibility
    }
    class Repository
    class Branch {
        name
    }
    class FileDirectory {
        name
    }
    class Pipeline {
        status
    }
    class FileBlob {
        name
    }
    class File {
        name
    }
    class Project {
        creator_id
        avatar_url
        name
        id
        readme_url
        web_url
        archived
        description
    }
    class User {
        created_at
        pronouns
        twitter
        linkedin
        avatar_url
        name
        id
        work_information
        bot
        job_title
        public_email
        following
        web_url
        bio
        website_url
        skype
        username
        state
        followers
        organization
        location
    }
    File <|-- FileDirectory
    File <|-- FileBlob
    Group *-- Group : group
    Repository *-- Branch : repository
    Project *-- Pipeline : project
    Branch *-- File : branch
    FileDirectory *-- File : directoryOwner
    Repository -- Project : repository
    Group *-- Project : group
    User -- Project : creator
```



## Contributor

This work has been first developed by the [research department of Berger-Levrault](https://www.research-bl.com/)


## Running metrics with docker 

### running locally
```smalltalk

|glphModel glphApi glhImporter beforeExp duringExp usersWithProjects gme|

"This example set up and run a GitProjectHealth metrics over two period of time of a given set of users and their projects.
It ouputs a csv files containing : churn code, commits frequencies, code addition and deletion, comments added (e.g. // # /**/ ), avg delay before first churn and merge request duration.
"

"load githealth project into your image"
Metacello new
  repository: 'github://moosetechnology/GitProjectHealth:GLPH-importer-new-changes/src';
  baseline: 'GitLabHealth';
  onConflict: [ :ex | ex useIncoming ];
  onUpgrade: [ :ex | ex useIncoming ];
  onDowngrade: [ :ex | ex useLoaded ];
  ignoreImage;
  load.

"set up a log at your root"
TinyLogger default
    addFileLoggerNamed: 'pharo-code-churn.log'.

"new model instance"
glphModel := GLPHEModel new.

"new API class instance"
glphApi := GLPHApi new
    privateToken: '<YOUR_TOKEN_KEY>';
    baseAPIUrl:'https://gitlab.com/api/v4';
    yourself.

"new importer instance"
glhImporter := GLPHModelImporter new
    glhApi: glphApi;
    glhModel: glphModel;
        withFiles: false;
        withCommitDiffs: true.

"setting up the period to compare (e.g. before a experience and during an experience)"
beforeExp := {
                                        #since -> ('1 march 2023' asDate).
                                        #until -> ('24 may 2023' asDate).
                                        } asDictionary .
duringExp := {
                                        #since -> ('1 march 2024' asDate).
                                        #until -> ('24 may 2024' asDate).
                                        } asDictionary .

usersWithProjects := {
"  'dev nameA' -> {  projectID1 . projectID2 }."
"  'dev nameB' -> {  projectID3 . projectID2 }."
'John Do' -> { 14 . 543 . 2455 }.
 } asDictionary.


gme := GitMetricExporter new glhImporter: glhImporter;
            initEntitiesFromUserProjects: usersWithProjects;
            beforeDic: beforeExp; duringDic: duringExp; label: 'GitLabHealth'.

"select among the following calendar class (at least one) "
gme exportOver: { Date . Week . Month . Year .}.

"the output files are located at 'FileLocator home/*.csv' "
Smalltalk snapshot: true andQuit: true.
```

### deploying with docker

```dockerfile
# Use the official smalltalkci image from Docker Hub
FROM hpiswa/smalltalkci

# Set environment variables
ENV ORIGIN_IMAGE_NAME=Moose64-11
ENV IMAGE_NAME=PharoServer

# Set the working directory
WORKDIR /usr/src/app

# Copy your Smalltalk project files into the container
COPY . .

# Run the CI script commands
RUN smalltalkci -s "${ORIGIN_IMAGE_NAME}" .smalltalk.ston
RUN mkdir ${IMAGE_NAME}
RUN mv /root/smalltalkCI-master/_builds/* ./${IMAGE_NAME}
RUN mv ./${IMAGE_NAME}/*/* ./${IMAGE_NAME}
RUN mv ${IMAGE_NAME}/TravisCI.changes ${IMAGE_NAME}/${IMAGE_NAME}.changes
RUN mv ${IMAGE_NAME}/TravisCI.image ${IMAGE_NAME}/${IMAGE_NAME}.image
RUN rm ${IMAGE_NAME}/build_status.txt
RUN rm -rf ${IMAGE_NAME}/vm

# Expose any ports the application might need (if applicable)
# EXPOSE 8080

# Set the command to run your Smalltalk application
CMD ["/root/smalltalkCI-master/_cache/vms/Moose64-11/pharo", "--headless", "PharoServer/PharoServer.image", "st", "./launchAnalyze.st"]
# the output csv files will be under /root/*.csv

```


