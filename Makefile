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

# Pandoc peripheral files for conversion.
pandoc_pdf := biblio.bib ieee-with-url.csl link_filter.py date.lua
pandoc_html := $(pandoc_pdf) pandoc.html5

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
.PHONY: all pdf html large tex
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
# }}}

# Recipe for converting a Markdown file to pdf or LaTeX using Pandoc {{{
$(pdfoutput)/%.pdf $(pdfoutput)/%.tex : $(source)/%.md $(pandoc_pdf) | $(pdfoutput)/
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
		--bibliography="biblio.bib" --csl="ieee-with-url.csl" \
		--from=markdown  $< \
		--pdf-engine=xelatex \
		--output $@
# }}}

# Recipe for converting a Markdown file into HTML5 using Pandoc {{{
.SECONDARY: $(staticobjects)
$(htmloutput)/%.html : $(source)/%.md $(pandoc_html) | $(htmloutput)/
	pandoc \
		--standalone \
		--citeproc \
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

$(source)/tmp/%.md : $(source)/%.md | $(source)/tmp/
	pandoc \
	--from=markdown $< \
	--markdown-headings=atx \
	--to=markdown \
	--output $@

%.md : %.mdpp $(markdown)
	markdown-pp $< --output $@

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
