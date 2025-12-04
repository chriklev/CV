#!/bin/bash
# build.sh - Compile CV to PDF
# Usage: ./build.sh [--clean]

set -e

# Configuration
MAIN_FILE="cv"
OUTPUT_DIR="build"
OUTPUTS_DIR="outputs"
CV_NAME="christoffer-kleven-berg"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

clean_build() {
    log_info "Cleaning build artifacts..."
    rm -rf "$OUTPUT_DIR"
    rm -rf "$OUTPUTS_DIR"
    rm -f "${MAIN_FILE}.aux" "${MAIN_FILE}.log" "${MAIN_FILE}.out" "${MAIN_FILE}.pdf"
    log_info "Clean complete."
}

build_cv() {
    log_info "Building CV in multiple languages..."

    # Create output directory
    mkdir -p "$OUTPUT_DIR"
    mkdir -p "$OUTPUTS_DIR"

    DATE=$(date +%Y-%m-%d)

    # Build for each language
    for LANG in en no; do
        log_info "Building ${LANG} version..."

        JOBNAME="${MAIN_FILE}_${LANG}"

        # Run pdflatex twice for proper references
        log_info "  First pass (${LANG})..."
        pdflatex -jobname="$JOBNAME" -interaction=nonstopmode -output-directory="$OUTPUT_DIR" "\\def\\LANGUAGE{${LANG}}\\input{${MAIN_FILE}.tex}" > /dev/null 2>&1 || {
            log_error "First pass failed for ${LANG}. Running with full output:"
            pdflatex -jobname="$JOBNAME" -interaction=nonstopmode -output-directory="$OUTPUT_DIR" "\\def\\LANGUAGE{${LANG}}\\input{${MAIN_FILE}.tex}"
            exit 1
        }

        log_info "  Second pass (${LANG})..."
        pdflatex -jobname="$JOBNAME" -interaction=nonstopmode -output-directory="$OUTPUT_DIR" "\\def\\LANGUAGE{${LANG}}\\input{${MAIN_FILE}.tex}" > /dev/null 2>&1 || {
            log_error "Second pass failed for ${LANG}."
            exit 1
        }

        # Copy with dated filename
        OUTPUT_FILENAME="${JOBNAME}_${DATE}.pdf"
        cp "${OUTPUT_DIR}/${JOBNAME}.pdf" "${OUTPUTS_DIR}/${OUTPUT_FILENAME}"
        log_info "  Created: ${OUTPUTS_DIR}/${OUTPUT_FILENAME}"
    done

    log_info "Build complete for all languages!"
}

# Main
case "${1:-}" in
    --clean|-c)
        clean_build
        ;;
    --help|-h)
        echo "Usage: $0 [OPTIONS]"
        echo ""
        echo "Options:"
        echo "  --clean, -c    Remove build artifacts"
        echo "  --help, -h     Show this help message"
        echo ""
        echo "Without options, builds the CV to PDF."
        ;;
    *)
        build_cv
        ;;
esac