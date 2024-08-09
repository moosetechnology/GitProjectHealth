# GitProject health

[![CI Moose 11](https://github.com/moosetechnology/GitProjectHealth/actions/workflows/ci-moose11.yml/badge.svg)](https://github.com/moosetechnology/GitProjectHealth/actions/workflows/ci-moose11.yml)
[![Coverage Status](https://coveralls.io/repos/github/moosetechnology/GitProjectHealth/badge.svg?branch=main)](https://coveralls.io/github/moosetechnology/GitProjectHealth?branch=main)


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

![GitProject meta-model png](https://raw.githubusercontent.com/moosetechnology/GitProjectHealth/v1/doc/gitproject.png)

## Connectors

This project comes with connectors to others metamodel to increase its powerfullness.

### Jira Connector

The Jira connector connect this project to the [Pharo Jira API project](https://github.com/Evref-BL/Jira-Pharo-API).
It basically looks for commit and merge request links to Jira Issue.

To install the connector, please perform:

```st
Metacello new
  repository: 'github://moosetechnology/GitProjectHealth:main/src';
  baseline: 'GitLabHealth';
  onConflict: [ :ex | ex useIncoming ];
  onUpgrade: [ :ex | ex useIncoming ];
  onDowngrade: [ :ex | ex useLoaded ];
  load: #( 'default' 'Jira' )
```

> loading default is optional if you already loaded it.

Then, it is possible to connect two models using

```st
GPJCConnector new
  gpModel: aGpModel; "or glh model"
  jiraModel: aJiraModel;
  connect
```

### Famix Connector

> The project exists and some code already exists, but it is not released yet.
> Raise an issue if you want us to investigate more on this

## Contributor

This work has been first developed by the [research department of Berger-Levrault](https://www.research-bl.com/)

## Running metrics with docker

### Running locally

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

```bash
git clone https://github.com/moosetechnology/GitProjectHealth.git
cd GitProjectHealth
git checkout GLPH-importer-new-changes

sudo docker build -t code-churn-pharo .
sudo docker run  code-churn-pharo &
```

Locate and retrieve csv output files:

```bash
sudo docker ps
sudo docker exec -it <container-id> find / -type f -name 'IA4Code*.csv' 2>/dev/null
```
