# Generate HTML5 and PDF from the Markdown source files
#
# Derived from:
#   https://gist.github.com/bertvv/e77e3a5d24d8c2a9bcc4
#   https://gist.github.com/prwhite/8168133
#
# In order to use this makefile, you need some tools:
# - GNU make
# - Pandoc >= 3.5
# - XeLaTeX
#   - KOMA-Script
# - Python >= 3.9
#   - panflute
#   - MarkdownPP
#   - ghp-import

.SUFFIXES:

# Variables {{{
# Directory containing source files
source := $(CURDIR)

# Select default fontsize for XeLaTeX.
fontsize := 12pt

# Select default Citation Style Language for Pandoc.
# See https://www.zotero.org/styles for more options.
CSL ?= ieee.csl

# Pandoc peripheral files for conversion.
pandoc_pdf := biblio.bib $(CSL) link_filter.py date.lua
pandoc_html := $(pandoc_pdf) pandoc.html5 pandoc.css

# Output paths.
remodel := docs
htmloutput := $(remodel)
staticoutput := $(remodel)
templates := $(remodel)
# Directory containing pdf files
# make large overrides location, etc.
pdfoutput := print$(large)

# Static files to copy or process into docs directory.
staticfiles := $(wildcard $(source)/*.css)
staticfiles += $(wildcard $(source)/*.zip)
staticfiles += $(wildcard $(source)/*.html)

staticobjects := $(subst $(source),$(staticoutput),$(staticfiles))
# $(info staticobjects is $(staticobjects))

# All MarkdownPP files in $(source)
# Assume  Markdown files are pre-requisites for MarkdownPP files.
# Otherwise, specify MarkdownPP dependencies (!INCLUDE directives)
markdownpp := $(wildcard $(source)/*.mdpp)
markdown := $(wildcard $(source)/*.md)
markdown := $(subst $(source),$(source)/tmp,$(markdown))
# $(info markdown is $(markdown))

# Map MarkdownPP files to html and pdf targets.
htmloutputs := $(subst .mdpp,.html,$(markdownpp))
htmloutputs := $(subst $(source),$(htmloutput),$(htmloutputs))
pdfoutputs := $(subst .mdpp,.pdf,$(markdownpp))
pdfoutputs := $(subst $(source),$(pdfoutput),$(pdfoutputs))
# $(info pdfoutputs is $(pdfoutputs))
texoutputs := $(subst .pdf,.tex,$(pdfoutputs))
# $(info pdfoutputs is $(pdfoutputs))
# End Variables }}}

# Help {{{
.DEFAULT_GOAL := help
.PHONY: help
.SILENT: help
## Show the help message
help:
	$(HELP_MESSAGE)

# COLORS
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)
TARGET_MAX_CHAR_NUM=20

define HELP_MESSAGE
echo ''
echo 'Usage:'
echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
echo ''
echo 'Targets:'
awk '/^[a-zA-Z\-_0-9]+:/ { \
	helpMessage = match(lastLine, /^## (.*)/); \
	if (helpMessage) { \
		helpCommand = substr($$1, 0, index($$1, ":")-1); \
		helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
		printf "  ${YELLOW}%-$(TARGET_MAX_CHAR_NUM)s${RESET} ${GREEN}%s${RESET}\n", helpCommand, helpMessage; \
	} \
} \
{ lastLine = $$0 }' $(MAKEFILE_LIST)
endef
# End Help }}}

# Explicit Rules {{{
.PHONY: all pdf html large tex publish
## Generate HTML5 and PDF from the Markdown source files
all: pdf html

## Generate PDF from the Markdown source files
pdf: $(pdfoutput)/Richland_Prefab_2BR.pdf $(pdfoutput)/Phase1.pdf | $(pdfoutput)/

## Generate HTML with CSS, JavaScript and SweetHome3D plan on website.
html: $(htmloutputs) $(staticobjects) | $(htmloutput)/

## Generate PDF with larger fonts for accessibility.
large:
	$(MAKE) pdf large:=large fontsize:=17pt

## Generate intermediate LaTeX for reviewing pdf recipe.
tex: $(texoutputs) | $(pdfoutput)/

## Publish HTML5 to Github Pages.
publish: html
	./gh-pages.sh
# }}}

# Recipe for converting a Markdown file to pdf or LaTeX using Pandoc {{{
# Note: pdf and tex are declared as separate pattern rules (not a single
# multi-target rule) because pandoc's output format is chosen from $@'s
# extension, so one invocation never produces both files. A shared
# multi-target rule would make Make expect both peer targets to be
# updated by every recipe run, which they aren't -- hence
# "pattern recipe did not update peer target" warnings.
define pandoc_to_pdf_or_tex
	pandoc \
		--citeproc \
		--variable fontsize=$(fontsize) \
		--variable papersize=letter \
		--variable links-as-notes \
		--variable colorlinks \
		--filter link_filter.py \
		--lua-filter date.lua \
		--table-of-contents \
		--number-sections \
		--bibliography="biblio.bib" --csl="$(CSL)" \
		--from=markdown  $< \
		--pdf-engine=xelatex \
		--output $@
endef

$(pdfoutput)/%.pdf : $(source)/%.md $(pandoc_pdf) | $(pdfoutput)/
	$(pandoc_to_pdf_or_tex)

$(pdfoutput)/%.tex : $(source)/%.md $(pandoc_pdf) | $(pdfoutput)/
	$(pandoc_to_pdf_or_tex)
# }}}

# Recipe for converting a Markdown file into HTML5 using Pandoc {{{
define pandoc_to_html
	pandoc \
		--standalone \
		--citeproc \
		--shift-heading-level-by=1 \
		--filter link_filter.py \
		--lua-filter date.lua \
		--table-of-contents \
		--bibliography="biblio.bib" --csl="$(CSL)" \
		--syntax-highlighting=breezedark \
		--template="pandoc.html5" \
		--css="pandoc.css" \
		--from=markdown  $< \
		--to="html5" \
		--output $@
endef

.SECONDARY: $(staticobjects)
$(htmloutput)/%.html : $(source)/%.md $(pandoc_html) | $(htmloutput)/
	$(pandoc_to_html)

$(staticoutput)/Home_Plan.zip : $(source)/Home_Plan.zip | $(staticoutput)/
	$(MAKE) cleanhome
	unzip Home_Plan.zip lib/* Home_Plan.zip -d $(staticoutput)
	touch $(staticoutput)/Home_Plan.zip

$(source)/tmp/%.md : $(source)/%.md | $(source)/tmp/
	pandoc \
	--from=markdown $< \
	--markdown-headings=atx \
	--to=markdown \
	--output $@

%.md : %.mdpp $(markdown)
	uv tool run --from=MarkdownPP markdown-pp $< --output $@

$(staticoutput)/% : $(CURDIR)/% | $(staticoutput)/
	cp $< $@

$(templates)/% : $(CURDIR)/% | $(templates)/
	cp $< $@

$(htmloutput)/% : $(CURDIR)/% | $(htmloutput)/
	cp $< $@
# }}}

# Order out rule to create directories if needed {{{
$(pdfoutput)/ $(htmloutput)/ $(source)/tmp/ :
	mkdir -p  $@
# }}}

# Recipe for clean {{{
.PHONY: clean cleanall cleanhtml cleanhome cleanpdf cleanlarge
## Remove all output: cleanhtml cleanhome cleanpdf cleanlarge.
clean: cleanhtml cleanhome cleanpdf cleanlarge cleantmp

## Remove HTML output.
cleanhtml :
	rm -rf $(htmloutput)

## Remove SweetHome 3D Home Plan from output.
cleanhome :
	rm -rf $(staticoutput)/Home_Plan.zip
	rm -rf $(staticoutput)/lib

## Remove pdf output.
cleanpdf :
	rm -rf $(pdfoutput)

## Remove large pdf output.
cleanlarge :
	rm -rf $(pdfoutput)large

## Remove large intermediate tmp directory.
cleantmp :
	rm -rf $(source)/tmp/
# }}}

# Test recipe {{{
.PHONY: test

test :
	$(MAKE)
	$(MAKE) help
# }}}
