#! /usr/bin/env python
"""pandoc filter converts URL extension to match destination extension.

    Convert .md extension to .pdf or .html, depending on output format.

    Usage:
        pandoc --filter=link_filter.py
"""

from os.path import splitext
from urllib.parse import urlparse

# import sys
import panflute as pf


def action(elem, doc):
    """Convert URL extensions to correct extension for output format"""
    # docformats = dict([('html5', '.html'),
    #                    ('html', '.html'),
    #                    ('latex', '.pdf')]
    #                  )
    docformats = dict([("html5", ".html"), ("html", ".html"), ("latex", ".pdf")])
    extensions = ".md"
    # extensions = ('.sh3d', '.md')
    if isinstance(elem, pf.Link) and elem.url.endswith(extensions):
        if doc.format in docformats:
            extension = splitext(urlparse(elem.url).path)[1]
            # pf.debug(docformats[doc.format])
            elem.url = elem.url[: -len(extension)] + docformats[doc.format]
            # pf.debug(elem.url)
            return elem

    return None


if __name__ == "__main__":
    # pf.debug(str(sys.argv))
    pf.run_filter(action)
