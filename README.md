UPLOAD FILES TO A WEBSITE FOLDER HOSTED ON IAGON

First you need to sign up to IAGON and subscribe to a storage plan. 

In your Account under Settings you can create your API KEY

This key can be validated /checked with: 

curl -X POST "https://gw.iagon.com/api/v2/key/verify" -H "Content-Type: application/json" -d '{"api_key": "YOUR KEY"}'

FIND THE DIRECTORY ID FOR YOUR WEBSITE
curl -X GET "https://wh.iagon.com/api/v1/site/explore/YOUR FOLDER NAME" -H "x-api-key: API KEY" -H "Content-Type: multipart/form-data"  

for example 
curl -X GET "https://wh.iagon.com/api/v1/site/explore/map" -H "x-api-key: ll.IAG-SN.RGhlSmT4BBZ=oShMKF4JwOijz90NfvbDHjq/RfaOjKraBnahrYb" -H "Content-Type: multipart/form-data" 
In the response look for the parent_directory_id":"",

UPLOAD A FILE TO SPECIFIC FOLDER
curl -X POST "https://gw.iagon.com/api/v2/storage/upload" -H "x-api-key: YOUR KEY" -H "Content-Type: multipart/form-data" -F "file=@/YOUR FILE DIRECTORY+NAME" -F "directoryId=6YOUR DIRECTORY ACCOUNT" -F "file-name=YOUR FILE NAME" -F "index_listing=false" -F "visibility=public"

When you Upload a file you get also the FILE ID . With this one you can then cancel again the file 
curl -X DELETE "https://gw.iagon.com/api/v2/storage/file/fileid" -H "Content-Type: application/json" -H "x-api-key: YOUR API KEY"
