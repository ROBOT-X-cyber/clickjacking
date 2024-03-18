#!/bin/bash

echo "Bot started..."

# Function to generate random 4-digit number
generate_random_number() {
    echo $((RANDOM % 10000))
}

# Function to extract domain from URL
extract_domain() {
    url="$1"
    # Check if the URL contains "google", if yes, skip processing
    if [[ $url == *google* ]]; then
        return 1
    fi
    domain=$(echo "$url" | grep -oP '(?<=://)([a-zA-Z0-9.-]+)')
    echo "$domain"
}

# Continuously monitor the current directory for .txt files
while true; do
    for file in *.txt; do
        if [ -f "$file" ]; then
            # Generate a random 4-digit number
            random_number=$(generate_random_number)
            # Construct new file name with random number
            new_file_name="${file%.*}_${random_number}.txt"
            # Rename the file
            mv "$file" "$new_file_name"
            echo "Renamed $file to $new_file_name"

            # Process the file: extract domain from each line
            output_file="domains_${random_number}"
            while IFS= read -r line; do
                if domain=$(extract_domain "$line"); then
                    echo "$domain" >> "$output_file"
                fi
            done < "$new_file_name"
            echo "Domain names extracted and saved to $output_file"

            # Remove the processed file
            rm "$new_file_name"
            echo "Removed $new_file_name"
        fi
    done
    sleep 3  # Check every 3 seconds
done
