import json
import pprint
import boto3
import pprint
import datetime

def lambda_handler(event, context):
    # TODO implement
    old_s3_bucket = event["old_s3_bucket"]
    new_s3_bucket = event["new_s3_bucket"]
    cloudfront =  event["cloudfront"]
    update_distribution(old_s3_bucket, new_s3_bucket, cloudfront)
    apply_lifecycle_policy(old_s3_bucket)
    create_invalidation(cloudfront)
    
    
def update_distribution(old_s3_bucket, new_s3_bucket, cloudfront):
    client = boto3.client('cloudfront')
    get_distribution_response = client.get_distribution(Id=cloudfront)
    distribution_config = get_distribution_response['Distribution']['DistributionConfig']
    domain_name = distribution_config['Origins']['Items'][0]['DomainName']
    new_domain_name = domain_name.replace(old_s3_bucket, new_s3_bucket)
    distribution_config['Origins']['Items'][0]['DomainName'] = new_domain_name
    etag = get_distribution_response['ETag']
    response = client.update_distribution(DistributionConfig=distribution_config, Id=cloudfront, IfMatch=etag)
    print(response)
    
def apply_lifecycle_policy(old_s3_bucket):
    client = boto3.client('s3')
    response = client.put_bucket_lifecycle_configuration(
        Bucket=old_s3_bucket,
        LifecycleConfiguration={
            'Rules': [
                {
                    'Expiration': {
                        'Days': 1,
                    },                
                    'Filter': {},
                    'ID': 'expiration-rule',
                    'Status': 'Enabled',
                },
            ]
        }
    )
    print(response)

def create_invalidation(cloudfront_id):
    client = boto3.client('cloudfront')
    current_time = datetime.datetime.now()
    current_time_str = str(current_time)
    chars = "-:. "
    for char in chars:
        current_time_str = current_time_str.replace(char,"")
    response = client.create_invalidation(
        DistributionId=cloudfront_id,
        InvalidationBatch={
            'Paths': {
                'Quantity': 1,
                'Items': [
                    '/',
                ]
            },
        'CallerReference': current_time_str
        }
    )
    print(response)