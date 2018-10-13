---
title: Third Party Notices
subtitle: Richland Prefab 2BR
author: John D. Fisher
email: jdfenw@gmail.com
link-citations: true
header-includes:
  - |
    ```{=html}
      <link rel="stylesheet" type="text/css" media="print" href="print.css" />
    ```
---

# Third Party Notices

- The floor plan drawings include dimensions from @columbiaabc. They have not
  placed a copyright notice on the book.
- `link_filter.py` was adapted from [md_htmldoc][md_htmldoc] for use with GNU
  make to convert markdown to HTML5 and PDF.
- The [date lua filter](date.lua), to add today's date to the pdf and html
  output, is taken from [pandoc lua filters][date_lua]. The filter is modified
  to print UTC date/time.
  <!-- markdownlint-disable MD013 -->
  <!-- TODO:  <30-09-18, jfishe>
  Use CSS media per [I totally forgot about print style sheets](https://uxdesign.cc/i-totally-forgot-about-print-style-sheets-f1e6604cfd6 "Manuel Matuzovic")
  -->
- The style sheet `print.css` is taken from the recommendations of [CSS Design: Going to Print by Eric Meyer May 10, 2002](https://alistapart.com/article/goingtoprint).
  - Incorporate Phil Archer's [Automatic Heading Numbers with CSS](https://philarcher.org/diary/2013/headingnumbers/) from [numberheadings.css](http://philarcher.org/css/numberheadings.css). [License Creative Commons v3.0](http://creativecommons.org/licenses/by/3.0/)
    <!-- markdownlint-enable MD013 -->
- [LibreCAD][librecad] was used to create the 2D drawings.
- [Sweet Home 3D][sweethome3d] was used to develop the interior layout and fixtures.
  - Use [Export to HTML5 plug-in][html5_plug] to export Home_Plan.zip, which the
    Makefile uses to build HTML5 from the Markdown files.

[sweethome3d]: http://www.sweethome3d.com/ "Sweet Home 3D - Draw floor plans and arrange furniture freely"
[html5_plug]: http://www.sweethome3d.com/blog/2016/05/05/export_to_html5_plug_in.html "Export to HTML5 plug-in"
[librecad]: https://librecad.org/ "LibreCAD Open Source 2D-CAD"
[md_htmldoc]: https://github.com/MatrixManAtYrService/md_htmldoc "MatrixManAtYrService/md_htmldoc"
[date_lua]: https://pandoc.org/lua-filters.html#setting-the-date-in-the-metadata "Setting the date in the metadata"
