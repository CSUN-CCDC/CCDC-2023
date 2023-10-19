#!/bin/bash

# Set the directory to search
search_directory="/home/"

# Use plocate to find all files in the specified directory
files=$(find "$search_directory" -type f)

# Iterate through each file and check if it's a multimedia file
for file in $files
do
    # Use the file command to determine the file type
    file_type=$(file -b "$file")

    # Check if the file type contains the word "video" or "audio"
    if [[ $file_type == *"video"* || $file_type == *"audio"* ]]; then
        echo "Multimedia file found: $file"
    fi
done

