# Generate HTML5 and PDF from the Markdown source files
#
# Derived from:
#   https://gist.github.com/bertvv/e77e3a5d24d8c2a9bcc4
#   https://gist.github.com/prwhite/8168133
#
# In order to use this makefile, you need some tools:
# - GNU make
# - Pandoc >= 2.2
# - XeLaTeX
#   - KOMA-Script
# - Python >= 3.6
#   - panflute
#   - MarkdownPP

# Variables {{{
# Directory containing source (Markdown) files

source := $(CURDIR)

# Miscellaneous files to copy or process into HTML5 directory.

staticfiles := pandoc.css Home_Plan.zip print.css
staticfiles := $(foreach var, $(staticfiles), $(source)/$(var))
# $(info staticfiles is $(staticfiles))

# Directory containing pdf files
# make large overides location, etc.

output := print$(large)

# Select default fontsize for XeLaTeX.
fontsize := 12pt

# All markdown files in $(source) are considered sources

sources := $(wildcard $(source)/*.md)
sources := $(subst $(source),$(source)/tmp,$(sources))
# $(info sources is $(sources))

# Directory containing HTML5 files
#
# For files in /Content droppages.com strips the extension and relocates
# to the root directory.
# For files in /Public, droppages.com copies files and folders as-is to root.
# href and script src relative URL's should assume root.
# make draft overides location.

remodel := remodel_richland.droppages.com
htmloutput := $(remodel)/Content$(drafts)
staticoutput := $(remodel)/Public$(drafts)
templates := $(remodel)/Templates$(drafts)
staticobjects := $(subst $(source),$(staticoutput),$(staticfiles))

# drafts := $(subst $(remodel),$(remodel)/_drafts,$(htmloutput)/index.html $(staticobjects) $(htmloutput)/README.txt $(templates)/base.html)
# Convert the list of source files into a list of output files (PDF in
# directory print/).
# $(info staticobjects is $(staticobjects))

# End Variables }}}

# Rules {{{
# Help {{{
.DEFAULT_GOAL := help
.PHONY : help
## Show the help message
# COLORS
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)


TARGET_MAX_CHAR_NUM=20
## Show help
help:
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  ${YELLOW}%-$(TARGET_MAX_CHAR_NUM)s${RESET} ${GREEN}%s${RESET}\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)
# End Help }}}
.PHONY : all
## Generate HTML5 and PDF from the Markdown source files
all: pdf html

.PHONY : pdf
## Generate PDF from the Markdown source files
pdf: $(output)/Richland_Prefab_2BR.pdf | $(output)/

.PHONY : html
## Geneate HTML with CSS, JavaScript and SweetHome3D plan on website.
html: $(htmloutput)/index.html $(htmloutput)/Phase1.html $(staticobjects) $(htmloutput)/README.txt $(templates)/base.html | $(htmloutput)/

.PHONY : draft
## Generate draft html output in webpage/_drafts
draft:
	$(MAKE) html drafts:=/_drafts

.PHONY : large
## Generate PDF with larger fonts for accessibility.
large:
	$(MAKE) pdf large:=large fontsize:=17pt

.PHONY : tex
## Generate intermediate LaTeX for reviewing pdf recipe.
tex: $(output)/Richland_Prefab_2BR.tex | $(output)/

# Recipe for converting a Markdown file into PDF using Pandoc {{{
$(output)/%.pdf : $(source)/%.md biblio.bib ieee-with-url.csl pandoc.tex link_filter.py date.lua | $(output)/
	pandoc \
		--variable fontsize=$(fontsize) \
		--variable papersize=letter \
		--variable links-as-notes \
		--variable colorlinks \
		--filter link_filter.py \
		--lua-filter date.lua \
		--table-of-contents \
		--number-sections \
		--bibliography="biblio.bib" --csl="ieee-with-url.csl" \
		--template="pandoc.tex" \
		--from=markdown  $< \
		--pdf-engine=xelatex \
		--output $@
# Recipe for converting a Markdown file into LaTeX using Pandoc {{{
$(output)/%.tex : $(source)/%.md biblio.bib ieee-with-url.csl pandoc.tex link_filter.py date.lua | $(output)/
	pandoc \
		--variable fontsize=$(fontsize) \
		--variable papersize=letter \
		--variable links-as-notes \
		--variable colorlinks \
		--filter link_filter.py \
		--lua-filter date.lua \
		--table-of-contents \
		--number-sections \
		--bibliography="biblio.bib" --csl="ieee-with-url.csl" \
		--template="pandoc.tex" \
		--from=markdown  $< \
		--output $@
# }}}
# }}}

# Recipe for converting a Markdown file into HTML5 using Pandoc {{{
.INTERMEDIATE : $(htmloutput)/Richland_Prefab_2BR.html
$(htmloutput)/index.html : $(htmloutput)/Richland_Prefab_2BR.html | $(htmloutput)/
	cp $< $@

.SECONDARY : $(staticobjects)
$(htmloutput)/%.html : $(source)/%.md biblio.bib ieee-with-url.csl pandoc.html5 link_filter.py date.lua | $(htmloutput)/
	pandoc \
		--standalone \
		--shift-heading-level-by=1 \
		--filter link_filter.py \
		--lua-filter date.lua \
		--table-of-contents \
		--bibliography="biblio.bib" --csl="ieee-with-url.csl" \
		--highlight-style=breezedark \
		--template="pandoc.html5" \
		--css="pandoc.css" \
		--from=markdown  $< \
		--to="html5" \
		--output $@

$(staticoutput)/Home_Plan.zip : $(source)/Home_Plan.zip | $(staticoutput)/
	$(MAKE) cleanhome
	unzip Home_Plan.zip lib/* Home_Plan.zip -d $(staticoutput)
	touch $(staticoutput)/Home_Plan.zip
# }}}

$(source)/%.md : $(source)/%.mdpp $(sources)
	markdown-pp $< --output $@

$(source)/Phase1.mdpp : $(source)/Electrical.md $(source)/Walls_Doors_Cabinets.md

$(source)/tmp/%.md : $(source)/%.md | $(source)/tmp/
	pandoc \
	--from=markdown $< \
	--markdown-headings=atx \
	--to=markdown \
	--output $@

$(staticoutput)/% : $(CURDIR)/% | $(staticoutput)/
	cp $< $@

$(templates)/% : $(CURDIR)/% | $(templates)/
	cp $< $@

$(htmloutput)/% : $(CURDIR)/% | $(htmloutput)/
	cp $< $@
# }}}

# Order out rule to create directories if needed {{{

.INTERMEDIATE : $(source)/tmp/
$(output)/ $(staticoutput)/ $(htmloutput)/ $(templates)/ $(source)/tmp/ :
	mkdir -p  $@
# }}}

# Recipe for clean {{{
.PHONY : clean cleanall cleanhtml cleanhome cleanpdf cleandraft cleanlarge
## Remove build cruft: cleanpy cleantmp
clean:
	rm -rf tex2pdf.[0-9]*
	rm -rf __pycache__
	rm -rf $(source)/tmp

## Remove all output: clean cleanhtml cleanhome cleanpdf cleandraft cleanlarge.
cleanall: clean cleanhtml cleanhome cleanpdf cleandraft cleanlarge

## Remove HTML output.
cleanhtml :
	rm -f $(htmloutput)/*
	rm -f $(staticoutput)/*.css
	rm -f $(templates)/*

## Remove SweetHome 3D Home Plan from output.
cleanhome :
	rm -rf $(staticoutput)/Home_Plan.zip
	rm -rf $(staticoutput)/lib

## Remove pdf output.
cleanpdf :
	rm -rf $(output)

## Remove draft
cleandraft :
	rm -rf $(htmloutput)/_drafts
	rm -rf $(staticoutput)/_drafts
	rm -rf $(templates)/_drafts

## Remove large pdf output.
cleanlarge :
	rm -rf $(output)large
# }}}

# Recipe for web-browser {{{
.PHONY : browse
## Open default web browser to website.
browse:
	"$$BROWSER" https://$(remodel)
# browse:
# 	cd HTML5 && (python -m http.server &) && "$$BROWSER" http://localhost:8000/README.html
# }}}
# End Rules }}}
