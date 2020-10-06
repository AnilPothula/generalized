#!/usr/bin/env python
import boto3
import os
import random 
import string
import json
from datetime import date

# Grab data from environment
jobqueue = os.environ['JobQueue']
jobdef = os.environ['JobDefinition']
bucketPrefix = os.environ['bucketPrefix']
cfOriginAccessIdentity = os.environ['cfOriginAccessIdentity']
bucketRegion = 'us-west-2'

'''
This lambda handler submits a job to a AWS Batch queue.
JobQueue, and JobDefinition environment variables must be set. 
These environment variables are intended to be set to the Name, not the Arn. 
'''
def lambda_handler(event,context):
   # get data to trigger batch job
   strategy_list = get_hashing_strategy()
   # Submit the job
   run_jobs(strategy_list)


'''
run_jobs trigger aws batch job and number of job depends upon strategy_list(array) provided
''' 
def run_jobs(strategy_list):
   # Set up a batch client 
   session = boto3.session.Session()
   client = session.client('batch')
   # create bucket name with prefix & date
   bucket_name = get_bucketname()
   # loop on strategy_list and trigger same number of jobs 
   for strategy in strategy_list:
      print("Key: " + strategy)
      job_name = 'job' + ''.join(random.choices(string.ascii_uppercase + string.digits, k=4))
      job = client.submit_job(
         jobName=job_name,
         jobQueue=jobqueue,
         jobDefinition=jobdef,
         containerOverrides={
            'environment': [
               {
                  'name': 'elasticKey',
                  'value': strategy
               },
               {
                  'name': 'bucketName',
                  'value': bucket_name
               },
            ],
         }
      )
      print("Started Job: {}".format(job['jobName']))

'''
This get_hashing_strategy method will return array
Number of aws batch job is directly propotional to number of element in returned array 
'''    
def get_hashing_strategy():
   strategy_list = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
   return strategy_list

'''
This function will create s3 bucket & return bucket name after creation
'''
def get_bucketname():
   # Use current date to get a bucket name.
   bucket_name = bucketPrefix+ "-" + str(date.today())
   s3 = boto3.resource('s3')
   s3.create_bucket(Bucket=bucket_name, CreateBucketConfiguration={'LocationConstraint': bucketRegion})

   # Set the new policy
   s3 = boto3.client('s3')
   bucketPolicy = json.dumps(get_bucketpolicy(bucket_name))
   s3.put_bucket_policy(Bucket=bucket_name, Policy=bucketPolicy)
   return bucket_name

def get_bucketpolicy(bucket_name):
  return {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
               "AWS": cfOriginAccessIdentity
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::"+ bucket_name +"/*"
        }
    ]
}