---
title: README
subtitle: Richland Prefab 2BR
author: John D. Fisher
email: jdfenw@gmail.com
summary: Richland, WA, 2 bedroom Prefab Remodel starting from the original floor plans, which are available from [@columbiaabc]. The dimensions have been updated to match the actual house.
header-includes:
- |
  ```{=html}
    <!--
       viewHomeInOverlay.html  version 1.2
    -->
    <script type="text/javascript" src="lib/big.min.js"></script>
    <script type="text/javascript" src="lib/gl-matrix-min.js"></script>
    <script type="text/javascript" src="lib/jszip.min.js"></script>
    <script type="text/javascript" src="lib/core.min.js"></script>
    <script type="text/javascript" src="lib/geom.min.js"></script>
    <script type="text/javascript" src="lib/triangulator.min.js"></script>
    <script type="text/javascript" src="lib/viewmodel.min.js"></script>
    <script type="text/javascript" src="lib/viewhome.min.js"></script>

    <style type="text/css">
    /* The class of components handled by the viewer */
        .viewerComponent {
        }
    </style>
  ```
---

# Richland Prefab 2BR

The [home page](http://remodel_richland.droppages.com/README) shows the layout
and general idea of the color choices, materials, fittings and furnishings in
a format viewable from modern web browsers (Chrome and Edge have been tested).
[SweetHome 3D Home Plan](Home_Plan.sh3d) contains the native drawing format.

See [Third party notices](#third-party-notices) for the SweetHome 3D free and
open source software required to view/edit the Home Plan. The dimensions are
close to actual, but there may be discrepancies.

<div>
  <!-- Copy the following button in your page -->
  <!-- Mouse and keyboard navigation explained at 
       http://sweethome3d.cvs.sf.net/viewvc/sweethome3d/SweetHome3D/src/com/eteks/sweethome3d/viewcontroller/resources/help/en/editing3DView.html 
       You may also switch between aerial view and virtual visit with the space bar -->
  <!-- For browser compatibility, see http://caniuse.com/webgl -->
  <button onclick='viewHomeInOverlay("Home_Plan.zip", 
              {roundsPerMinute:    1,                        /* Rotation speed of the animation launched once home is loaded in rounds per minute, no animation if missing */ 
               widthByHeightRatio: 4/3,                      /* Size ratio of the displayed canvas */
               navigationPanel: "none",                      /* Displayed navigation arrows, "none" or "default" for default one or an HTML string containing elements with data-simulated-key 
                                                                attribute set "UP", "DOWN", "LEFT", "RIGHT"... to replace the default navigation panel, "none" if missing */ 
               aerialViewButtonText: "Aerial view",          /* Text displayed for aerial view radio button, no radio buttons if missing */ 
               virtualVisitButtonText: "Virtual visit",      /* Text displayed for virtual visit radio button, no radio buttons if missing */
            /* selectableLevels: ["Level 0", "Level 1"], */  /* Uncomment to choose the list of displayed levels, no select component if empty array */
               viewerControlsAdditionalHTML: "",             /* Additional HTML text appended to controls displayed below the canvas 3D, by default empty */
               readingHomeText: "Reading",                   /* Comment displayed while reading home */
               readingModelText: "Model",                    /* Comment displayed while reading models */
               noWebGLSupportError: "No WebGL support"       /* Error message displayed if the browser do not support WebGL */
              })'>View home</button>
</div>

The [`Makefile`](Makefile.md) builds printable PDF's and local HTML5 files with a javascript viewer of the Sweet Home 3D plan. A Sweet Home 3D plugin is required to generate the javascript viewer. See [Third Party Notices](#third-party-notices) for information about downloading the plugin.

## Electrical

Lighting, wiring, outlets and irrigation controls are discussed below.

* [Electrical Upgrade](Electrical.md)

## Walls, Doors and Cabinets and Fixtures

Plumbing, flooring, walls, cabinets (kitchen and bath) and fixtures, such as faucets and shower head, are discussed below.

- [Walls, Doors and Cabinets and Fixtures](Walls_Doors_Cabinets.md)

## Third Party Notices

* [Third Party Notices](THIRD-PARTY-NOTICES.md)

## Errata

- The Sweet Home 3D viewer plugin does not show the horizontal KALLAX shelf in
  Bedroom #2 correctly; rather it renders the shelf vertically, instead of
  horizontal. The plants show the correct elevation of the shelf. The Sweet
  Home 3D application renders correctly.

## References

<!--
pandoc  --to="html5" --output="README.html" --standalone
        --template="pandoc.html5"
        --bibliography="biblio.bib" --csl="ieee.csl" "README.md"

. md_htmldoc/md_htmldoc.sh  # Convert *.md to Remodel_htmldoc\*.html
-->

---
link-citations: true
---
