import boto3
import os
import random 
import string
import logging
import time
from botocore.exceptions import ClientError
from generate_file import create_file
current_milli_time = lambda: str(round(time.time() * 1000))

'''
HTML file will be uploaded on predefined s3 bucket
S3 write access is required by this code
'''

def upload_to_s3(value, bucket, object_name=None):
    """Upload a file to an S3 bucket

    :param file_name: File to upload
    :param bucket: Bucket to upload to
    :param object_name: S3 object name. If not specified then file_name is used
    :return: True if file was uploaded, else False
    """

    randomFileName = 'file' + ''.join(random.sample(string.ascii_uppercase + string.digits, k=5))+current_milli_time()+'.html'

    # Upload the file
    s3_client = boto3.client('s3')
    try:
        message = """<html>
                <head></head>
                <body><p>"""+value+"""</p></body>
                </html>"""
        response = s3_client.put_object(Body=message, Bucket=bucket, Key=randomFileName, ContentType='text/html')
        print(randomFileName+' uploaded to s3')
        file_url = '%s/%s/%s' % (s3_client.meta.endpoint_url, bucket, randomFileName)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
        d = dict()
        d['file'] = randomFileName
        d['link'] = file_url
        return d
    except ClientError as e:
        print("Error while uploaded file on s3", e)