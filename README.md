# GitLab Health

This project includes a model, an importer, and some visulization to evaluate the health of a GitLab group.

## Installation

Download a [Moose image](https://modularmoose.org/moose-wiki/Beginners/InstallMoose) (or better, a [Moose-BL image](https://gitlab.forge.berger-levrault.com/Benoit.VERHAEGHE/bl-moose)).

In the Moose image, in a playground (`Ctrl+O`, `Ctrl+W`), perform:

```st
Metacello new
  repository: 'gitlab://gitlab.forge.berger-levrault.com:bl-drit/bl.moose/gitlabhealth:main/src';
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
	baseAPIUrl: 'https://gitlab.forge.berger-levrault.com/api/v4';
	privateToken: 'YOU PRIVATE KEY';
	glhModel: glhModel.


"137 is the ID of the DRIT Group, you can find the number in the webpage of every project and group"
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
