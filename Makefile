# Generate PDFs from the Markdown source files
#
# Derived from https://gist.github.com/bertvv/e77e3a5d24d8c2a9bcc4
#
# In order to use this makefile, you need some tools:
# - GNU make
# - Pandoc
# - XeLaTeX

# Variables {{{
# Directory containing source (Markdown) files
source := $(CURDIR)

# Directory containing pdf files
output := print

# All markdown files in src/ are considered sources
sources := $(wildcard $(source)/*.md)

# Convert the list of source files (Markdown files in current directory)
# into a list of output files (PDFs in directory print/).
objects := $(patsubst %.md,%.pdf,$(subst $(source),$(output),$(sources)))

# Directory containing pdf files
htmloutput := HTML5

# Convert the list of source files (Markdown files in current directory)
# into a list of output files (PDFs in directory HTML5/).
htmlobjects := $(patsubst %.md,%.html,$(subst $(source),$(htmloutput),$(sources)))

# End Variables }}}

# Rules {{{
all: pdf html

.PHONY : all pdf html clean

pdf: $(objects)

html : $(htmlobjects)

# Recipe for converting a Markdown file into PDF using Pandoc {{{
$(output)/%.pdf: $(source)/%.md biblio.bib ieee.csl pandoc.tex pdflink_filter.py
	pandoc \
		--filter link_filter.py \
		--table-of-contents \
		--number-sections \
		--bibliography="biblio.bib" --csl="ieee.csl" \
		--template="pandoc.tex" \
		--variable documentclass=article \
		--variable papersize=letterpaper \
		--variable fontsize=12pt \
		--variable geometry:"top=0.5in, bottom=0.5in, left=0.5in, right=0.5in" \
		--from=markdown  $< \
		--pdf-engine=xelatex \
		--output $@
# }}}

# Recipe for converting a Markdown file into HTML5 using Pandoc {{{
$(htmloutput)/%.html: $(source)/%.md biblio.bib ieee.csl pandoc.html5 $(htmloutput)/pandoc.css link_filter.py
	pandoc \
		--filter link_filter.py \
		--table-of-contents \
		--number-sections \
		--bibliography="biblio.bib" --csl="ieee.csl" \
		--highlight-style=breezedark \
		--template="pandoc.hml5" \
		--css="pandoc.css" \
		--from=markdown  $< \
		--to="html5" \
		--standalone \
		--output $@

$(htmloutput)/%.css : $(CURDIR)/%.css
	cp $< $@

# }}}

# Recipe for clean {{{
clean:
	rm -f $(output)/*.pdf
	rm -f $(html)/*.css
	rm -f $(html)/*.html
# }}}
# End Rules }}}
