#!/bin/bash

# Configuration
API_KEY="YOUR API KEY"
DIRECTORY_ID=" YOUR DIRECTORY ID"
FILE_PATH="Location of the file" 
BASE_NAME="file name "

while true; do
  # Step 1: Upload the file and capture the response
  RESPONSE=$(curl -s -X POST "https://gw.iagon.com/api/v2/storage/upload" \
    -H "x-api-key: $API_KEY" \
    -H "Content-Type: multipart/form-data" \
    -F "file=@$FILE_PATH" \
    -F "directoryId=$DIRECTORY_ID" \
    -F "file-name=$BASE_NAME" \
    -F "index_listing=false" \
    -F "visibility=public")

  # Step 2: Extract the file ID from the response
  FILE_ID=$(echo "$RESPONSE" | grep -o '"_id":"[^"]*' | cut -d'"' -f4)
  if [ -z "$FILE_ID" ]; then
    echo "Failed to get file ID. Response: $RESPONSE"
    exit 1
  fi
  echo "Uploaded file with ID: $FILE_ID"

  # Step 3: Wait 60 seconds
  echo "Waiting 60 seconds..."
  sleep 60

  # Step 4: Delete the file using the file ID
  DELETE_RESPONSE=$(curl -s -X DELETE "https://gw.iagon.com/api/v2/storage/file/$FILE_ID" \
    -H "Content-Type: application/json" \
    -H "x-api-key: $API_KEY")
  if echo "$DELETE_RESPONSE" | grep -q '"success":true'; then
    echo "Deleted file with ID: $FILE_ID"
  else
    echo "Failed to delete file. Response: $DELETE_RESPONSE"
  fi

  # Step 5: Loop continues to upload the same JSON file
  echo "Starting next upload cycle..."
done

