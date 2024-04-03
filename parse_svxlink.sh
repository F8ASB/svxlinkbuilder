#!/bin/bash

input_file="svxlink.conf"
output_file="svxlink.db"

header_written=false

while IFS= read -r line; do
    line=$(echo "$line" | tr -d '\r\n') # Remove carriage return and newline characters
    if [[ $line == \[*]* ]]; then
        category=${line:1:-1}
        # Write header category without parameters if not already written
        if [ "$category" == "Header" ] && [ "$header_written" = false ]; then
            echo "$category" >> "$output_file"
            header_written=true
        fi
    elif [[ $line == \#* ]]; then
        # Parameter heading
        parameter_heading=$(echo "$line" | cut -d '=' -f 1 | sed 's/# *//')
        parameter=$(echo "$line" | cut -d '=' -f 2-)
        echo "$category,$parameter_heading,$parameter" >> "$output_file"
    elif [[ -n "$line" ]]; then
        # Regular parameter
        parameter_heading=$(echo "$line" | cut -d '=' -f 1)
        parameter=$(echo "$line" | cut -d '=' -f 2-)
        echo "$category,$parameter_heading,$parameter" >> "$output_file"
    fi
done < "$input_file"
