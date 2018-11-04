# Generate HTML5 and PDFs from the Markdown source files
#
# Derived from:
#   https://gist.github.com/bertvv/e77e3a5d24d8c2a9bcc4
#   https://gist.github.com/prwhite/8168133
#
# In order to use this makefile, you need some tools:
# - GNU make
# - Pandoc >= 2.2
# - XeLaTeX
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

output := print

# All markdown files in $(source) are considered sources

sources := $(wildcard $(source)/*.md)
# $(info sources is $(sources))

# Directory containing HTML5 files
#
# For files in /Content droppages.com strips the extension and relocates
# to the root directory.
# For files in /Public, droppages.com copies files and folders as-is to root.
# href and script src relative URL's should assume root.

remodel := remodel_richland.droppages.com
htmloutput := $(remodel)/Content$(drafts)
staticoutput := $(remodel)/Public$(drafts)
templates := $(remodel)/Templates$(drafts)
staticobjects := $(subst $(source),$(staticoutput),$(staticfiles))

# drafts := $(subst $(remodel),$(remodel)/_drafts,$(htmloutput)/index.html $(staticobjects) $(htmloutput)/README.txt $(templates)/base.html)
# Convert the list of source files into a list of output files (PDFs in
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
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
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
## Generate HTML5 and PDFs from the Markdown source files
all: pdf html

.PHONY : pdf
## Generate PDFs from the Markdown source files
pdf: $(output)/Richland_Prefab_2BR.pdf | $(output)/

.PHONY : html
## Geneate HTML with CSS, JavaScript and SweetHome3D plan on website.
html: $(htmloutput)/index.html $(staticobjects) $(htmloutput)/README.txt $(templates)/base.html | $(htmloutput)/

.PHONY : draft
## Generate draft html output in webpage/_drafts
draft:
	$(MAKE) html drafts:=/_drafts

# Recipe for converting a Markdown file into PDF using Pandoc {{{
$(output)/%.pdf : $(source)/%.md biblio.bib ieee-with-url.csl pandoc.tex link_filter.py date.lua $(sources) | $(output)/
	pandoc \
		--variable fontsize=12pt \
		--variable geometry:"top=0.5in, bottom=0.5in, left=0.5in, right=0.5in" \
		--variable papersize=letter \
		--variable links-as-notes \
		--variable colorlinks \
		--variable documentclass=article \
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

# Recipe for converting a Markdown file into HTML5 using Pandoc {{{
.SECONDARY : $(staticobjects)
$(htmloutput)/%.html : $(source)/%.md biblio.bib ieee-with-url.csl pandoc.html5 link_filter.py date.lua $(sources) | $(htmloutput)/
	pandoc \
		--standalone \
		--base-header-level=2 \
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
	make cleanhome
	unzip Home_Plan.zip lib/* Home_Plan.zip -d $(staticoutput)
	touch $(staticoutput)/Home_Plan.zip

$(source)/%.md : $(source)/%.mdpp
	markdown-pp $< --output $@

.INTERMEDIATE : $(htmloutput)/Richland_Prefab_2BR.html
$(htmloutput)/index.html : $(htmloutput)/Richland_Prefab_2BR.html | $(htmloutput)/
	cp $< $@

$(staticoutput)/% : $(CURDIR)/% | $(staticoutput)/
	cp $< $@

$(templates)/% : $(CURDIR)/% | $(templates)/
	cp $< $@

$(htmloutput)/% : $(CURDIR)/% | $(htmloutput)/
	cp $< $@
# }}}

# Order out rule to create directories if needed {{{

$(output)/ $(staticoutput)/ $(htmloutput)/ $(templates)/ :
	mkdir -p  $@
# }}}

# Recipe for clean {{{
.PHONY : clean cleanhtml cleanhome cleanpdf cleandraft
## Remove all output.
clean : cleanhtml cleanhome cleanpdf cleandraft
	rm -rf __pycache__

## Remove HTML output.
cleanhtml:
	rm -f $(htmloutput)/*
	rm -f $(staticoutput)/*.css
	rm -f $(templates)/*

## Remove SweetHome 3D Home Plan from output.
cleanhome:
	rm -rf $(staticoutput)/Home_Plan.zip
	rm -rf $(staticoutput)/lib

## Remove pdf output.
cleanpdf:
	rm -f $(output)/*.pdf

## Remove draft
cleandraft:
	rm -rf $(htmloutput)/_drafts
	rm -rf $(staticoutput)/_drafts
	rm -rf $(templates)/_drafts
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
