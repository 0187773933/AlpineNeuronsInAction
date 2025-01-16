#!/bin/bash

# Directory to scan
SCAN_DIR="/Users/morpheous/WORKSPACE/MISC/AlpineNeuronsInAction/NIA2PC/Contents/X_NIA2"

# Start YAML output
echo "tutorials:"

# Function to extract and clean title
get_title() {
    local file="$1"
    # Try to get title from HTML, remove tags, trim whitespace
    title=$(grep -i "<title>" "$file" | sed 's/<[^>]*>//g' | sed 's/^[ \t]*//;s/[ \t]*$//')
    if [ -z "$title" ]; then
        # Fallback to filename without extension if no title found
        title=$(basename "$file" .htm)
    fi
    # Clean up title for YAML
    echo "$title" | sed 's/"/\\"/g'
}

# Function to process each file
process_file() {
    local htm_file="$1"
    
    # Only process if file contains .nrm links
    if grep -q '\.nrm' "$htm_file"; then
        # Get tutorial title
        title=$(get_title "$htm_file")
        
        # Output tutorial entry
        echo "  \"$title\":"
        echo "    path: \"$htm_file\""
        echo "    simulations:"
        
        # Extract and format .nrm paths
        grep -o 'href="[^"]*\.nrm"' "$htm_file" | \
        sed 's/href="//' | \
        sed 's/"//' | \
        while read -r nrm; do
            # Convert relative paths to absolute if needed
            if [[ "$nrm" == ./* ]]; then
                # Get directory of HTM file
                base_dir=$(dirname "$htm_file")
                # Resolve the relative path
                full_path=$(cd "$base_dir" && realpath --relative-to="$SCAN_DIR" "$nrm" 2>/dev/null || echo "$nrm")
                echo "      - \"$full_path\""
            else
                echo "      - \"$nrm\""
            fi
        done
        echo ""
    fi
}

# Find all .htm files and process them
find "$SCAN_DIR" -type f -name "*.htm" | sort | while read -r htm_file; do
    process_file "$htm_file"
done