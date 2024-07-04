#!/bin/bash


find_next_backup_folder() {
    local next_folder="$(ls "${dest_dir}" | sort -n | tail -n 1)"
    while [ -d "${dest_dir}/${next_folder}" ]; do
        (( next_folder++ ))
    done
    echo "$next_folder"
}


find_current_backup_folder() {
    for folder in $(ls "${dest_dir}" | grep '^[0-9]*$' | sort -n); do
        file_count=$(find "${dest_dir}/${folder}" -maxdepth 1 -type f -name "*.tar.gz" | wc -l)
        if [ "$file_count" -lt 5 ]; then
            echo "$folder"
            return
        fi
    done
    echo ""
}

# Check if two arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <source_directory_or_file> <destination_directory>"
    exit 1
fi

# Assign arguments to variables
source_path="$1"
dest_dir="$2"

# Check if source path exists
if [ ! -e "$source_path" ]; then
    echo "Error: Source path '$source_path' not found."
    exit 1
fi
 next_folder="$(ls "${dest_dir}" | sort -n | tail -n 1)"
echo "$next_folder"
# Create timestamp
timestamp=$(date +%Y%m%d_%H%M%S)

# Construct archive filename
archive_file="$timestamp.tar.gz"

current_backup_folder=$(find_current_backup_folder)

if [ -z "$current_backup_folder" ]; then
    current_backup_folder=$(find_next_backup_folder)
    mkdir -p "${dest_dir}/${current_backup_folder}"
fi

backup_folder="${dest_dir}/${current_backup_folder}"
folder_count=$(find "${dest_dir}" -mindepth 1 -maxdepth 1 -type d | sort -n | wc -l)
if [ "$folder_count" -gt 5 ]; then
    oldest_folder=$(ls -tr1d "${dest_dir}"/*/ | head -n 1)
    echo "$oldest_folder"
    rm -rf "${oldest_folder}"
    echo "Oldest folder deleted successfully"
fi 

# Archive and compress into the current backup folder
tar -czf "${backup_folder}/${archive_file}" -C "$(dirname "$source_path")" "$(basename "$source_path")"

echo "Backup successful: ${backup_folder}/${archive_file} created"
