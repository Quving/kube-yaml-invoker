#!/bin/bash

# Read the file path from the command line argument
file_path="$1"

# Define regex pattern to match environment variables
pattern='\$\{([A-Za-z_][A-Za-z0-9_]*)\}'

# Initialize an empty array to store the results
results=()

# Read the file line by line
while IFS= read -r line; do
  # Check if the line contains a matching environment variable
  if [[ $line =~ $pattern ]]; then
    # Extract the variable name from the matched pattern
    variable_name="${BASH_REMATCH[1]}"

    # Store the variable name in the results array
    results+=("$variable_name")
  fi
done < "$file_path"

# Check if each variable in the results array is set
for variable in "${results[@]}"; do
  value=$(printf '%s\n' "${!variable}")
  if [ ! "$(printf '%s\n' "${!variable}")" ]; then
    echo "Environment variable '$variable' is not set. Aborting."
    exit 1
  fi
done
