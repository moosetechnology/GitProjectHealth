|glphModel glphApi glhImporter beforeExp duringExp usersWithProjects gme|

"This example set up and run a GitProjectHealth metrics over two period of time of a given set of users and their projects.
It ouputs a csv files containing : churn code, commits frequencies, code addition and deletion, comments added (e.g. // # /**/ ), avg delay before first churn and merge request duration.
"

"load githealth project into your image"
Metacello new
  repository: 'github://moosetechnology/GitProjectHealth:main/src';
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
