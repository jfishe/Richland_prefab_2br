---
title: README
subtitle: Richland Prefab 2BR
author: John D. Fisher
email: jdfenw@gmail.com
---

# Description

The [home page](https://remodel_richland.droppages.com/) shows the layout
and general idea of the color choices, materials, fittings and furnishings in
a format viewable from modern web browsers (Chrome and Edge have been tested).
[SweetHome 3D Home Plan](Home_Plan.sh3d) contains the native drawing format,
available from the
[Github project site](https://github.com/jfishe/Richland_prefab_2br "jfishe/Richland_prefab_2br").

## Installation

See [Third party notices](#third-party-notices) for the free and open source
software required to view/edit the Home Plan and CAD drawings.

The [`Makefile`][makefile] builds printable PDF's and local HTML5 files with
a javascript viewer of the Sweet Home 3D plan. A Sweet Home 3D plugin is
required to generate the javascript viewer. See
[Third Party Notices](#third-party-notices) for information about downloading
the plugin. Refer to the [`Makefile`][makefile] for build software.

The pdf defaults to KOMA-Script scrartcl, specified in
`Richland_Prefab_2BR.mdpp` YAML meta-data.

[makefile]: Makefile

### Anaconda or Miniconda

The make file relies on several tools, available through a `conda` environment
specified in [`environment.yml`](environment.yml). To create the necessary
environment, isolated from system versions, `environment.yml` may be used to
create a `conda` environment called `Remodel`.

- [Install Anaconda3 or Miniconda3](https://conda.io/docs/). Pandoc and
  `link_filter.py` were tested using Python 3; they may or may not work in
  Python 2.7.
- From a `bash` prompt, enter `conda env create --file environment.yml`.
- Follow the instructions in the output to `conda activate Remodel`.

  <!-- >  TODO:  <17-11-18, JD Fisher> > Add installation instructions for Ubuntu make, XeLaTeX, etc.
  -->

## Overview

[`Richland_Prefab_2BR.mdpp`](Richland_Prefab_2BR.mdpp) contains an overview of
the project and defines the content for the PDF and HTML5 versions.

## Electrical Phase 1

Lighting, wiring, outlets and irrigation controls are discussed below.

[Electrical Upgrade](Electrical.md)

## Walls, Doors and Cabinets and Fixtures Phase 1

Plumbing, flooring, walls, cabinets (kitchen and bath) and fixtures, such as
faucets and shower head, are discussed below.

[Walls, Doors and Cabinets and Fixtures](Walls_Doors_Cabinets.md)

## Bathroom Phase 2

[Bathroom](Bathroom.md)

## Doors Phase 2

[Doors](Doors_Phase2.md)

## Third Party Notices

[Third Party Notices](THIRD-PARTY-NOTICES.md)
