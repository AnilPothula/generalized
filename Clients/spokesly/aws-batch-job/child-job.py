#!/usr/bin/env python


import os
from generate_file import create_file
from upload_file import upload_to_s3

BUCKET_NAME = os.environ['bucketName']
dataToWriteInHTML = {"a":"dummy text a", "ab":"dummy text ab", "baa":"dummy text b","c":"dummy text b","d":"dummy text d","e":"dummy text e","f":"dummy text f","g":"dummy text g","h":"dummy text h","i":"dummy text i","j":"dummy text j","k":"dummy text k","l":"dummy text l","m":"dummy text m","n":"dummy text n","o":"dummy text o","p":"dummy text p","q":"dummy text q","r":"dummy text r","s":"dummy text s","t":"dummy text t","u":"dummy text u","v":"dummy text v","w":"dummy text w","x":"dummy text x","y":"dummy text y","z":"dummy text z"}
keyTogetFromElastic = os.environ['elasticKey']

for (key, value) in dataToWriteInHTML.items():
    # Step 1: Find data from dict
    ifMatch = key.startswith(keyTogetFromElastic)
    if(ifMatch):
        # Step 2: Create HTML File, with content
        # fileDetails = create_file(value, BUCKET_NAME)

        # Step 3: Upload file to defined s3 bucket
        file = upload_to_s3(value, BUCKET_NAME)
        if isinstance(file,dict):
            print(file['link'])

        # Step 4: Remove file from instance
        # os.remove(file['file'])