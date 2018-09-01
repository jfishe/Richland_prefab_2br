#! /usr/bin/env python
"""pandoc filter converts .md URL to match destination extension.

    E.g., destination extension of .pdf or .html

    Usage:
        pandoc --filter=link_filter.py
"""

import panflute as pf

def action(elem, doc):
    docformats = ['html', 'pdf']
    if isinstance(elem, pf.Link) and elem.url.endswith('.md'):
        if doc.format in docformats:
            elem.url = elem.url[:-3] + '.' + doc.format
            return elem
        else:
            return None

    return None

if __name__ == '__main__':
    pf.run_filter(action)
