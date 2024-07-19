#!/bin/bash

PARAMS=('-m 6 -q 70 -mt -af -progress')

if [ $# -ne 0 ]; then
    PARAMS=$@;
fi

# Check if content/posts directory exists
if [ ! -d "content/posts" ]; then
    echo "Error: content/posts directory not found"
    exit 1
fi

# Function to update index.md
update_index_md() {
    local old_file="$1"
    local new_file="$2"
    local index_file="$3"
    
    if [ "$(uname)" == "Darwin" ]; then
        # macOS version (using sed -i '')
        sed -i '' "s|$old_file|$new_file|g" "$index_file"
    else
        # Linux version
        sed -i "s|$old_file|$new_file|g" "$index_file"
    fi
}

# Function to convert images in a directory
convert_images() {
    local dir="$1"
    cd "$dir" || return

    # Enable extended globbing
    shopt -s extglob nullglob nocaseglob

    for FILE in *.jpg *.jpeg *.tif *.tiff *.png; do 
        if [ -f "$FILE" ]; then
            # Convert image to WebP
            cwebp $PARAMS "$FILE" -o "${FILE%.*}.webp"
            
            if [ $? -eq 0 ]; then
                echo "Converted $FILE to ${FILE%.*}.webp"
                
                # Update references in index.md
                if [ -f "index.md" ]; then
                    update_index_md "$FILE" "${FILE%.*}.webp" "index.md"
                    echo "Updated reference in index.md: $FILE -> ${FILE%.*}.webp"
                fi
                
                # Delete original file
                rm "$FILE"
                echo "Deleted original file: $FILE"
            else
                echo "Failed to convert $FILE"
            fi
        fi
    done

    # Process subdirectories
    for subdir in */; do
        if [ -d "$subdir" ]; then
            convert_images "$subdir"
        fi
    done

    cd ..
}

# Start conversion from content/posts
convert_images "content/posts"