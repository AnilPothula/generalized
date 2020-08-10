import crhelper
import boto3
import os

# initialise logger
logger = crhelper.log_config({"RequestId": "CONTAINER_INIT"})
logger.info('Logging configured')
# set global to track init failures
init_failed = False

try:
    # Place initialization code here
    logger.info("Container initialization completed")
except Exception as e:
    logger.error(e, exc_info=True)
    init_failed = e


def create(event, context):
    """
    Place your code to handle Create events here.

    To return a failure to CloudFormation simply raise an exception, the exception message will be sent to CloudFormation Events.
    """
    physical_resource_id = 'alb_rules_count'

    logger.info('Cloudformation Custom: ALB rules check')
    client = boto3.client('elbv2')
    response = client.describe_rules(ListenerArn=event['ResourceProperties']['ListenerArn'])
    print(response)
    priorities = get_priorities(response['Rules'])
    print(priorities)
    logger.info('Cloudformation Custom: ALB rules check finished')

    rts = check_available_priorities(priorities)

    tomcat = check_available_priorities(priorities)

    metrics = check_available_priorities(priorities)

    response_data = {
        "RtsCountRule": rts,
        "TomcatCountRule": tomcat,
        "MetricsCountRule": metrics
    }
    return physical_resource_id, response_data


def delete(event, context):
    """
    Place your code to handle Delete events here

    To return a failure to CloudFormation simply raise an exception, the exception message will be sent to CloudFormation Events.
    """
    return

def update(event, context):
    """
    Place your code to handle Update events here

    To return a failure to CloudFormation simply raise an exception, the exception message will be sent to CloudFormation Events.
    """
    physical_resource_id = event['PhysicalResourceId']
    response_data = {}
    return physical_resource_id, response_data


def get_priorities(rules):
    priorities = []
    for r in rules:
        if r['Priority'] != 'default':
            priorities.append(int(r['Priority']))
    priorities.sort()
    return priorities

def check_available_priorities(priorities):
    x = 1
    for p in priorities:
        if p != x:
            priorities.append(x)
            priorities.sort()
            return x
        x = x + 1
    priorities.append(x)
    priorities.sort()
    return x

def handler(event, context):
    """
    Main handler function, passes off it's work to crhelper's cfn_handler
    """
    # update the logger with event info
    global logger
    logger = crhelper.log_config(event)
    print(event)
    return crhelper.cfn_handler(event, context, create, update, delete, logger,
                                init_failed)
