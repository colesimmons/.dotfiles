#!/bin/bash

# Set source and target directories
fonts_dir=$( cd "$( dirname "$0" )" && pwd )
find_command="find \"$fonts_dir\" \( -name '*.[o,t]tf' -or -name '*.pcf.gz' \) -type f -print0"

target_font_dir="$HOME/Library/Fonts"

# Copy all fonts to user fonts directory
echo "Copying fonts..."
eval $find_command | xargs -0 -I % cp "%" "$target_font_dir/"

echo "All fonts installed to $target_font_dir"
