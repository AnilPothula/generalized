import json
import os
import botocore
import boto3
import logging
import datetime
import ecsClean
from datetime import timezone
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    try:
        response = {}
        Message = ""
        # ###############################
        logger.info('CleanUp >> ------------ ECS CLEANING ---------------------')
        ecs_dict = {
            "terminated":[],
            "running":[],
            "errors":[],
            "logs": 'https://console.aws.amazon.com/cloudwatch/home?region='+os.environ['AWS_REGION']+'#logEventViewer:group='+context.log_group_name+';stream='+context.log_stream_name
        }
        ecsClean.ecs_cleaning(ecs_dict)
        # ###############################
        response = {"statusCode": 200,"Message": "Succesful"}
        response['ECS'] = ecs_dict
        return response
    except Exception as e:
        logger.info('CleanUp >> ERROR '+str(e))
        response = {"statusCode": 500,"Message": str(e)}
        return response
