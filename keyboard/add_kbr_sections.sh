#!/bin/bash

# Path to your XML file
XML_FILE=$1

# Check if the specific variant 'real-prog-dvorak' already exists
VARIANT_EXISTS=$(xmlstarlet sel -t -v "count(//variant/configItem[name='real-prog-dvorak'])" "$XML_FILE")

if [ "$VARIANT_EXISTS" -eq "0" ]; then
    xmlstarlet ed --inplace \
        -s "//variant/configItem[description='Polish (programmer Dvorak)']/../.." -t elem -n "variantTMP" -v "" \
        -s "//variantTMP" -t elem -n "configItem" -v "" \
        -s "//variantTMP/configItem" -t elem -n "name" -v "real-prog-dvorak" \
        -s "//variantTMP/configItem" -t elem -n "description" -v "Polish (Real Programmers Dvorak)" \
        -s "//variantTMP/configItem" -t elem -n "vendor" -v "MichaelPaulson" \
        -r "//variantTMP" -v "variant" \
        "$XML_FILE"

    echo "Variant 'real-prog-dvorak' added!"
else
    echo "Variant 'real-prog-dvorak' already exists!"
fi



# ----------------------
# ----------------------


FILE_PATH="$2"  # Replace with the path of your file
SECTION_FILE="./real-prog-dvorak-pl"
SECTION=$(<"${SECTION_FILE}")

if grep -Fq "xkb_symbols \"real-prog-dvorak\"" "$FILE_PATH"; then
    echo "Section already exists!"
else
    awk -v section="${SECTION}" 'BEGIN {print section}' >> "${FILE_PATH}"
fi

