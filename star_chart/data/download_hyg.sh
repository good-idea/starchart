#!/bin/bash

# Create directory if it doesn't exist
mkdir -p "$(dirname "$0")"

# Download the gzipped CSV file
echo "Downloading HYG Database..."
curl -L "https://codeberg.org/astronexus/hyg/media/branch/main/data/hyg/CURRENT/hyg_v42.csv.gz" -o "$(dirname "$0")/hyg.csv.gz"

# Check if download was successful
if [ $? -ne 0 ]; then
    echo "Error: Download failed"
    exit 1
fi

# Unzip the file
echo "Extracting CSV file..."
gunzip -f "$(dirname "$0")/hyg.csv.gz"


# Check if extraction was successful
if [ $? -ne 0 ]; then
    echo "Error: Extraction failed"
    exit 1
fi

echo "Download and extraction complete!"
echo "HYG Database is now available at: $(dirname "$0")/hyg.csv"
