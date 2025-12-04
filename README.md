# CV LaTeX Project

A clean, professional CV template with complete separation of content and styling.

## Project Structure

cv-project/
├── cv.tex          # Main document (combines style + content)
├── cv-style.sty    # All formatting and styling
├── cv-content.tex  # Your CV content (edit this!)
├── build.sh        # Build script
├── .gitignore      # Git ignore rules
└── README.md       # This file

## Quick Start

1. Edit `cv-content.tex` with your information
2. Run `./build.sh` to generate the PDF
3. Find your CV at `cv.pdf`

## How It Works

**Content/Form Separation:**
- `cv-content.tex` - Edit this file to update your CV content
- `cv-style.sty` - Contains all formatting (change fonts, margins, colors here)
- `cv.tex` - The main document that pulls everything together

## Building

# Build the CV
./build.sh

# Clean build artifacts
./build.sh --clean

### Requirements
- pdflatex (included in TeX Live or MiKTeX)

## ATS Compatibility

This template is ATS-friendly:
- Standard fonts (Latin Modern)
- Simple structure (no tables/columns)
- Text extracts cleanly
- Standard section headers