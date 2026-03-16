| glhModel gitlabApi glhImporter |

"This example shows how to set up and run GitProjectHealth metrics for a given set of users and their projects over two periods of time.
It ouputs a csv files containing: code churn, commit frequencies, code additions and deletions, comments added (e.g., `//`, `#`, `/**/`), average delay before first churn, and merge request duration."

"load GitProjectHealth into your image"
Metacello new
    repository: 'github://moosetechnology/GitProjectHealth:main/src';
    baseline: 'GitLabHealth';
    onConflict: [ :ex | ex useIncoming ];
    onUpgrade: [ :ex | ex useIncoming ];
    onDowngrade: [ :ex | ex useLoaded ];
    ignoreImage;
    load.

"set up a log at your root"
TinyLogger default addFileLoggerNamed: 'pharo-code-churn.log'.

"new model instance"
glhModel := GLHModel new.

"new API class instance"
gitlabApi := GitlabApi new
    privateToken: '<YOUR_TOKEN_KEY>';
    hostUrl: 'https://gitlab.com/api/v4'.

"new importer instance"
glhImporter := GitlabModelImporter new
    repoApi: gitlabApi;
    glhModel: glhModel;
    withFiles: false;
    withCommitDiffs: true.

"export metrics, the output files are located at `FileLocator home / *.csv`"
GitMetricExporter new
    glhImporter: glhImporter;
    addAPeriodFrom: '1 march 2023' to: '24 may 2023';
    addAPeriodFrom: '1 march 2024' to: '24 may 2024';
    setupAnalysisForUsersWithNames: { 'John Doe' };
    setupAnalysisForProjectsWithIds: { 14. 543. 2455 };
    label: 'GitLabHealth';
    exportInCSV.

Smalltalk snapshot: true andQuit: true.
