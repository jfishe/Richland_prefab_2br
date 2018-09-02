# Generate HTML5 and PDFs from the Markdown source files
#
# Derived from https://gist.github.com/bertvv/e77e3a5d24d8c2a9bcc4
#
# In order to use this makefile, you need some tools:
# - GNU make
# - Pandoc >= 2.2
# - XeLaTeX
# - Python >= 3.6
#   - panflute

# Variables {{{
# Directory containing source (Markdown) files
source := $(CURDIR)

# Directory containing pdf files
output := print

# All markdown files in src/ are considered sources
sources := $(wildcard $(source)/*.md)
# $(info sources is $(sources))

# Directory containing HTML5 files
htmloutput := HTML5

# Convert the list of source files (Markdown files in current directory)
# into a list of output files (PDFs in directory print/).
objects := $(patsubst %.md,%.pdf,$(subst $(source),$(output),$(sources)))
htmlobjects := $(patsubst %.md,%.html,$(subst $(source),$(htmloutput),$(sources)))

# End Variables }}}

# Rules {{{
.PHONY : all
all: pdf html

.PHONY : pdf
pdf: $(objects)

.PHONY : html
html : $(htmlobjects)

# Recipe for converting a Markdown file into PDF using Pandoc {{{
$(output)/%.pdf : $(source)/%.md biblio.bib ieee.csl pandoc.tex link_filter.py
	pandoc \
		--variable fontsize=12pt \
		--variable geometry:"top=0.5in, bottom=0.5in, left=0.5in, right=0.5in" \
		--variable papersize=letterpaper \
		--variable links-as-notes \
		--filter link_filter.py \
		--table-of-contents \
		--number-sections \
		--bibliography="biblio.bib" --csl="ieee-with-url.csl" \
		--template="pandoc.tex" \
		--from=markdown  $< \
		--pdf-engine=xelatex \
		--output $@
	rm -rf tex2pdf.[0-9]*
# }}}
#		--variable documentclass=article \

# Recipe for converting a Markdown file into HTML5 using Pandoc {{{
.SECONDARY : $(htmloutput)/pandoc.css $(htmloutput)/Home_Plan.zip
$(htmloutput)/%.html : $(source)/%.md biblio.bib ieee.csl pandoc.html5 $(htmloutput)/pandoc.css link_filter.py $(htmloutput)/Home_Plan.zip
	pandoc \
		--standalone \
		--filter link_filter.py \
		--table-of-contents \
		--number-sections \
		--bibliography="biblio.bib" --csl="ieee.csl" \
		--highlight-style=breezedark \
		--template="pandoc.html5" \
		--css="pandoc.css" \
		--from=markdown  $< \
		--to="html5" \
		--output $@

$(htmloutput)/%.css : $(CURDIR)/%.css
	cp $< $@

$(htmloutput)/Home_Plan.zip : $(source)/Home_Plan.zip
	unzip Home_Plan.zip lib/* Home_Plan.zip -d $(htmloutput)
	touch $(htmloutput)/Home_Plan.zip

# }}}

# Recipe for clean {{{
.PHONY : clean
clean:
	rm -f $(objects)
	rm -f $(htmloutput)/*.css
	rm -f $(htmlobjects)
	rm -rf $(htmloutput)/Home_Plan.zip
	rm -rf $(htmloutput)/lib
	rm -rf __pycache__
# }}}
# End Rules }}}
