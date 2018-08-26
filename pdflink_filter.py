#! /usr/bin/env python
"""pandoc filter converts .md URL to .pdf

    Usage:
        pandoc --filter=pdflink_filter.py
"""

import panflute as pf

def action(elem, doc):
    if isinstance(elem, pf.Link) and elem.url.endswith('.md'):
        elem.url = elem.url[:-3] + '.pdf'
        return elem

if __name__ == '__main__':
    pf.run_filter(action)
