#!/bin/bash
set -e
if [[ "$#" != "1" ]]; then
    echo "Terraform summary action internal error: you must pass a single parameter to the 'format-output' script."
    exit 11
fi
FILE_PATH="$1"
WORKING_FILE_PATH="__tmp/$FILE_PATH"
mkdir -p "$(dirname "$WORKING_FILE_PATH")"
cp "$FILE_PATH" "$WORKING_FILE_PATH"
# Remove ANSI colors
sed 's/\x1b\[[0-9;]*m//g' -i'' "$WORKING_FILE_PATH"
# Remove "reading... lines"
grep -v "Refreshing state...\|[rR]eading...\|Read complete after\|::debug:\|[command]" "$WORKING_FILE_PATH" > "$WORKING_FILE_PATH-tmp" && mv "$WORKING_FILE_PATH-tmp" "$WORKING_FILE_PATH"
# Extract summary of planned changes
NO_CHANGES=$(grep "No changes" "$WORKING_FILE_PATH" || echo "")
if [[ ${#NO_CHANGES} -gt 0 ]]; then
    echo "$NO_CHANGES" | sed 's|No changes|<span style="font-weight:bold;color:darkgreen">No changes</span>|g'
    exit 0
fi
PLANNED_CHANGES=$(grep "Plan: " "$WORKING_FILE_PATH")
# Delete after the ──────────... line
sed '/──────/Q' -i'' $WORKING_FILE_PATH
echo "<span style='font-size:1.25rem;font-weight:semibold'>$PLANNED_CHANGES</span>"
echo "---------------"
echo "Below you'll find the complete plan output."
echo '```tf'
cat "$WORKING_FILE_PATH"
echo '```'
rm "$WORKING_FILE_PATH"