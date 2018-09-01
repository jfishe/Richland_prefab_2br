#! /usr/bin/env python
"""pandoc filter converts .md URL to match destination extension.

    E.g., destination extension of .pdf or .html

    Usage:
        pandoc --filter=link_filter.py
"""

import panflute as pf
import sys

def action(elem, doc):
    docformats = dict([('html5', 'html'),
                       ('html', 'html'),
                       ('latex', 'pdf')]
                     )
    if isinstance(elem, pf.Link) and elem.url.endswith('.md'):
        if doc.format in docformats:
            pf.debug(docformats[doc.format])
            elem.url = elem.url[:-3] + '.' + docformats[doc.format]
            pf.debug(elem.url)
            return elem
        else:
            return None

    return None

if __name__ == '__main__':
    pf.debug(str(sys.argv))
    pf.run_filter(action)
