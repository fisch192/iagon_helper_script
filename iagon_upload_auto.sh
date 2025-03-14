#!/bin/bash

API_KEY="Your Api KEY"
DIRECTORY_ID="Your Folder ID"
FILE_PATH="Your path"
BASE_NAME="File name"
PREVIOUS_FILE_ID=""  # To store the ID of the last uploaded file

while true; do
  # Step 1: Verify the file exists and display its content
  if [ ! -f "$FILE_PATH" ]; then
    echo "Error: $FILE_PATH does not exist."
    exit 1
  fi
  echo "File content before upload:"
  cat "$FILE_PATH"

  # Step 2: Upload the file and capture the response
  RESPONSE=$(curl -s -X POST "https://gw.iagon.com/api/v2/storage/upload" \
    -H "x-api-key: $API_KEY" \
    -H "Content-Type: multipart/form-data" \
    -F "file=@$FILE_PATH" \
    -F "directoryId=$DIRECTORY_ID" \
    -F "file-name=$BASE_NAME" \
    -F "index_listing=false" \
    -F "visibility=public")

  # Step 3: Extract the file ID from the response
  CURRENT_FILE_ID=$(echo "$RESPONSE" | grep -o '"_id":"[^"]*' | cut -d'"' -f4)
  if [ -z "$CURRENT_FILE_ID" ]; then
    echo "Failed to get file ID. Response: $RESPONSE"
    exit 1
  fi
  echo "Uploaded file with ID: $CURRENT_FILE_ID"

  # Step 4: If there�s a previous file ID, delete it
  if [ -n "$PREVIOUS_FILE_ID" ]; then
    echo "Deleting previous file with ID: $PREVIOUS_FILE_ID"
    DELETE_RESPONSE=$(curl -s -X DELETE "https://gw.iagon.com/api/v2/storage/delete" \
      -H "x-api-key: $API_KEY" \
      -d "{\"fileId\": \"$PREVIOUS_FILE_ID\"}")
    echo "Delete response: $DELETE_RESPONSE"
 fi

  # Step 5: Update PREVIOUS_FILE_ID for the next iteration
  PREVIOUS_FILE_ID="$CURRENT_FILE_ID"

  # Step 6: Wait 60 seconds
  echo "Waiting 60 seconds..."
  sleep 60
done
