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
#   - MarkdownPP

# # Variables {{{
# Directory containing source (Markdown) files
source := $(CURDIR)

# Miscellaneous files to copy or process into HTML5 directory.
staticfiles := pandoc.css Home_Plan.zip print.css
staticfiles := $(foreach var, $(staticfiles), $(source)/$(var))
# $(info staticfiles is $(staticfiles))

# Directory containing pdf files
output := print

# All markdown files in src/ are considered sources
sources := $(wildcard $(source)/*.md)
sources += $(source)/Makefile.md
# $(info sources is $(sources))

# Directory containing HTML5 files
htmloutput := remodel_richland.droppages.com/Content
staticoutput := remodel_richland.droppages.com/Public

# Convert the list of source files (Markdown files in current directory)
# into a list of output files (PDFs in directory print/).
objects := $(patsubst %.md,%.pdf,$(subst $(source),$(output),$(sources)))
htmlobjects := $(patsubst %.md,%.html,$(subst $(source),$(htmloutput),$(sources)))
staticobjects := $(subst $(source),$(staticoutput),$(staticfiles))
# $(info staticobjects is $(staticobjects))

# End Variables }}}

# Rules {{{
.PHONY : all
all: pdf html

.PHONY : pdf
pdf: $(objects)

.PHONY : html
html : $(htmlobjects)

# Recipe for converting a Markdown file into PDF using Pandoc {{{
$(output)/%.pdf : $(source)/%.md biblio.bib ieee.csl pandoc.tex link_filter.py date.lua
	pandoc \
		--variable fontsize=12pt \
		--variable geometry:"top=0.5in, bottom=0.5in, left=0.5in, right=0.5in" \
		--variable papersize=letterpaper \
		--variable links-as-notes \
		--filter link_filter.py \
		--lua-filter date.lua \
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
.SECONDARY : $(staticobjects)
$(htmloutput)/%.html : $(source)/%.md biblio.bib ieee.csl pandoc.html5 link_filter.py date.lua $(staticobjects)
	pandoc \
		--standalone \
		--filter link_filter.py \
		--lua-filter date.lua \
		--table-of-contents \
		--number-sections \
		--bibliography="biblio.bib" --csl="ieee-with-url.csl" \
		--highlight-style=breezedark \
		--template="pandoc.html5" \
		--css="pandoc.css" \
		--from=markdown  $< \
		--to="html5" \
		--output $@

# $(htmloutput)/%.css : $(CURDIR)/%.css
# 	cp $< $@

$(staticoutput)/Home_Plan.zip : $(source)/Home_Plan.zip
	unzip Home_Plan.zip lib/* Home_Plan.zip -d $(staticoutput)
	touch $(staticoutput)/Home_Plan.zip

$(source)/%.md : $(source)/%.mdpp
	markdown-pp $< --output $@

$(staticoutput)/% : $(CURDIR)/%
	cp $< $@
# }}}

# Recipe for clean {{{
.PHONY : clean
clean:
	rm -f $(objects)
	rm -f $(htmloutput)/*.html
	rm -f $(staticoutput)/*.css
	rm -rf $(staticoutput)/Home_Plan.zip
	rm -rf $(staticoutput)/lib
	rm -rf __pycache__
# }}}
# Recipe for web-browser {{{
.PHONY : browse
browse:
	"$$BROWSER" http://remodel_richland.droppages.com
# browse:
# 	cd HTML5 && (python -m http.server &) && "$$BROWSER" http://localhost:8000/README.html
# }}}
# End Rules }}}
