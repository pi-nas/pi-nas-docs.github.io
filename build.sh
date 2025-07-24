#!/bin/bash

# Get the name of the current directory
current_dir=$(basename "$PWD")

# Define directories to check and remove
dirs_to_remove=("assets" "img" "search")

# Define target dir
target_dir="./src"

# Check if the current directory is linuxonarm64.github.io
if [ "$current_dir" = "willzcloud.github.io" ]; then
  for dir in "${dirs_to_remove[@]}"; do
    if [ -d "$dir" ]; then
      echo "Removing $dir directory..."
      rm -rf "$dir"
      echo "$dir directory removed."
    else
      echo "No $dir directory found."
    fi
  done
else
  echo "Error: You are not in the willzcloud.github.io directory."
  exit 1
fi

# Check that all specified directories no longer exist
all_removed=true
for dir in "${dirs_to_remove[@]}"; do
  if [ -d "$dir" ]; then
    all_removed=false
    echo "$dir still exists."
  fi
done

# Run the build only if all directories are gone
if [ "$all_removed" = true ]; then
  if [ -d "$target_dir" ]; then
    echo "Changing to $target_dir..."
    cd "$target_dir" || { echo "Failed to change directory."; exit 1; }

    echo "Building mkdocs."
    mkdocs build

    echo "Moving docs."
    mv site/* ../

    echo "Removing site dir."
    rm -rf site
  else
    echo "Target directory '$target_dir' does not exist."
    exit 1
  fi
else
  echo "Not all directories were removed. Aborting..."
  exit 1
fi
