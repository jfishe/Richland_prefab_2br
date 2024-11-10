---
title: README
subtitle: Richland Prefab 2BR
author: John D. Fisher
email: jdfenw@gmail.com
---

# Description

The [home page](https://jfishe.github.io/Richland_prefab_2br/) shows the layout
and general idea of the color choices, materials, fittings and furnishings in
a format viewable from modern web browsers (Chrome and Edge have been tested).
[SweetHome 3D Home Plan](Home_Plan.sh3d) contains the native drawing format,
available from the
[Github project site](https://github.com/jfishe/Richland_prefab_2br "jfishe/Richland_prefab_2br").

## Installation

See [Third party notices](#third-party-notices) for the free and open source
software required to view/edit the Home Plan and CAD drawings.

### Build PDF and HTML5

The [`Makefile`][makefile] builds a printable PDF and local HTML5 files with
a JavaScript viewer of the Sweet Home 3d plan. A Sweet Home 3d plugin is
required to generate the JavaScript viewer. See
[Third Party Notices](#third-party-notices) for information about downloading
the plugin. Refer to the [`Makefile`][makefile] for build software.

The PDF defaults to `KOMA-Script` `scrartcl`, specified in
`Richland_Prefab_2BR.mdpp` `YAML` meta-data.

The [`Makefile`][makefile] generates the web site the `docs/` folder.
`pre-commit` includes a `pre-push` hook to generate and update the Github pages
site. Update `remodel` variable in the `Makefile` to change the location.
`htmloutput, staticoutput, templates` and `staticobjects` may also need
adjusting if your static web page server has a different folder layout than
[Github Pages](https://pages.github.com/)

[makefile]: Makefile

### Track Changes with PDF Comments

When sharing the PDF, generated by `make pdf` with a contractor, it is helpful
to highlight changes. `difftoolpdf.sh` generates a PDF using PDF comments to
mark changes.

```man
Usage: difftoolpdf.sh <old> [<new>]

Old and new can be any commit reference recognized by git checkout.
E.g., difftoolpdf.sh v1.0 v1.1
If <new> is omitted, use the current branch & commit.

Recommend tagging the commit that is shared with the contractor, e.g.,
git tag v1.0. Append the commit ID if the tag isn't for the current commit.
```

### Anaconda or Miniconda

The make file relies on several tools, available through a `conda` environment
specified in [`environment.yml`](environment.yml). To create the necessary
environment, isolated from system versions, `environment.yml` may be used to
create a `conda` environment called `Remodel`.

- [Install Anaconda3 or Miniconda3](https://conda.io/docs/). Pandoc and
  `link_filter.py` were tested using Python 3.
- From a `bash` prompt, enter `conda env create --file environment.yml`.
- Follow the instructions in the output to `conda activate Remodel`.

  <!-- >  TODO:  <17-11-18, JD Fisher>
       > Add installation instructions for Ubuntu make, XeLaTeX, etc.
  <!-- >  TODO:  <09-11-24, JD Fisher>
       > Convert pandoc.css to use:
       > pandoc --print-default-data-file=templates/styles.html
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
