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

In a playground (`Ctrl+O`, `Ctrl+W`).

```st
glhModel := GLHModel new.
glhImporter := GLHModelImporter new
  baseAPIUrl: 'https://gitlab.myPrivateHost.com/api/v4';
  privateToken: 'YOU PRIVATE KEY';
  glhModel: glhModel.


"137 is the ID of the a Group, you can find the number in the webpage of every project and group"
glhImporter importGroup: 137.

```

To export a svg image

```st
dritGroup := (glhModel allWithType: GLHGroup) detect: [ :group | group id = 137 ].
canvas := (GLHGroupVisualization new forGroup: dritGroup).
canvas open
canvas svgCairoExporter
  noFixedShapes;
  fileName: 'd:/drit-health';
  export
```

## Usages GitHub

In a playground (`Ctrl+O`, `Ctrl+W`).

```st
glhModel := GLHModel new.

githubImporter := GHModelImporter new glhModel: glhModel; privateToken: '<my private token>'; yourself.

githubImporter importGroup: 'moosetechnology'.
```

## Contributor

This work has been first developed by the [research department of Berger-Levrault](research-bl.com/)
