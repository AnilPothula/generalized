import json
import boto3
import os

def lambda_handler(event, context):
    try:
        message = json.loads(event['Records'][0]['Sns']['Message'])
        # variables:
        instance_id = message['EC2InstanceId']
        autoscaling_name = message['AutoScalingGroupName']
        ec2_name = instance_name(get_id_from_instance_id(instance_id), autoscaling_name)
        change_instance_name(ec2_name, instance_id)
    except Execption as e:
        print('Naming Lambda >> error '+str(e))


def get_id_from_instance_id(instance_id):
    try:
        print('Naming Lambda >> getting instance hash id')
        return str(hash(instance_id))[1:5]
    except Exception as e:
        print('Naming Lambda >> error on getting instance id: '+str(e))


def instance_name(hash_id, autoscaling_name):
    try:
        print('Naming Lambda >> getting instance name')
        env = os.environ['ENVIRONMENT']
        identifier = os.environ['IDENTIFIER']
        return identifier + '-' + env + '-' + get_server_name(autoscaling_name) + '-' + str(hash_id)
    except Exception as e:
        print('Naming Lambda >> error on getting instance new name: '+str(e))


def get_server_name(autoscaling_name):
    try:
        print('Naming Lambda >> getting server name for '+str(autoscaling_name))
        if 'tomcat' in autoscaling_name:
            return 'tomcat'
        if 'rts' in autoscaling_name:
            return 'rts'
        if 'tomcatvideo' in autoscaling_name:
            return 'tomcatvideo'
    except Exception as e:
        print('Naming Lambda >> error on getting server name: '+str(e))

def change_instance_name(ec2_name, instance_id):
    try:
        print('Naming Lambda >> naming the instance: '+str(ec2_name))
        client = boto3.client('ec2')
        client.create_tags(Resources=[instance_id], Tags=[{'Key': 'Name', 'Value': ec2_name}])
    except Exception as e:
        print('Naming Lambda >> error on getting server name: '+str(e))
        