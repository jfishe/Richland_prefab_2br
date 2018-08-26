# Generate PDFs from the Markdown source files
#
# In order to use this makefile, you need some tools:
# - GNU make
# - Pandoc
# - LuaLaTeX
# - DejaVu Sans fonts

# Directory containing source (Markdown) files
source := $(CURDIR)

# Directory containing pdf files
output := print

# All markdown files in src/ are considered sources
sources := $(wildcard $(source)/*.md)

# Convert the list of source files (Markdown files in current directory)
# into a list of output files (PDFs in directory print/).
objects := $(patsubst %.md,%.pdf,$(subst $(source),$(output),$(sources)))

all: $(objects)

# Recipe for converting a Markdown file into PDF using Pandoc
$(output)/%.pdf: $(source)/%.md biblio.bib ieee.csl pandoc.tex pdflink_filter.py
	pandoc \
		--filter pdflink_filter.py \
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

.PHONY : clean

clean:
	rm -f $(output)/*.pdf
