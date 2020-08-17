#!/bin/bash
sed -i'' -e 's/.*requiretty.*//' /etc/sudoers
#pip install --upgrade awscli

INSTANCE_ID=$(/usr/bin/aws opsworks register --use-instance-profile --infrastructure-class ec2 --region us-east-1 --stack-id ${StackId} --override-hostname ${Identifier}$(tr -cd '0-9' < /dev/urandom |head -c3) --local 2>&1 |grep -o 'Instance ID: .*' |cut -d' ' -f3)
/usr/bin/aws opsworks wait instance-registered --region us-east-1 --instance-id $INSTANCE_ID
/usr/bin/aws opsworks assign-instance --region us-east-1 --instance-id $INSTANCE_ID --layer-ids ${LayerId}
/usr/bin/aws configure set default.region ${AWS::Region}

echo "ssm agent"
sudo start amazon-ssm-agent

# installing jq
sudo yum install -y jq

# updating aws cli
sudo yum update -y aws-cli

# getting db credentials
echo export USER_DB=$(/usr/bin/aws secretsmanager get-secret-value --secret-id database/${IdentifierRds}/${Environment}/DbCredentials --query 'SecretString' --output text | jq -r .username) >> /etc/environment
echo export PASSWORD_DB=$(/usr/bin/aws secretsmanager get-secret-value --secret-id database/${IdentifierRds}/${Environment}/DbCredentials --query 'SecretString' --output text | jq -r .password) >> /etc/environment
echo export DB_ENDPOINT=${DbEndpoint} >> /etc/environment

# getting dw credentials
echo export USER_DW=$(/usr/bin/aws secretsmanager get-secret-value --secret-id database/${IdentifierRds}/${Environment}/DwCredentials --query 'SecretString' --output text | jq -r .username) >> /etc/environment
echo export PASSWORD_DW=$(/usr/bin/aws secretsmanager get-secret-value --secret-id database/${IdentifierRds}/${Environment}/DwCredentials --query 'SecretString' --output text | jq -r .password) >> /etc/environment
echo export DW_ENDPOINT=${DwEndpoint} >> /etc/environment

# settinig redis endpoint and port
echo export REDIS_ENDPOINT=${RedisEndpoint} >> /etc/environment
echo export REDIS_PORT=${RedisPort} >> /etc/environment

# settinig rabbit mq information
echo export RABBITMQ_HOST=${RabbitMqHost} >> /etc/environment
echo export RABBITMQ_PORT=${RabbitMqPort} >> /etc/environment
echo export RABBITMQ_USER=$(/usr/bin/aws secretsmanager get-secret-value --secret-id metrics/${IdentifierMetrics}/${Environment}/RabbitmqCredentials --query 'SecretString' --output text | jq -r .username) >> /etc/environment
echo export RABBITMQ_PASSWORD=$(/usr/bin/aws secretsmanager get-secret-value --secret-id metrics/${IdentifierMetrics}/${Environment}/RabbitmqCredentials --query 'SecretString' --output text | jq -r .password) >> /etc/environment

# setting region and memcache name to grab the nodes
echo export REGION=${AWS::Region} >> /etc/environment
echo export MEMCACHE_CLUSTER=${MemcacheClusterId} >> /etc/environment
echo export MEMPORT=${MemcachePort} >> /etc/environment

# setting the type configuration for the nodes
echo export CONF_TYPE=${ConfigurationType} >> /etc/environment
echo export ENV=${Environment} >> /etc/environment

# setting the efs endpoint
echo export EFS_ENDPOINT=${EfsEndpoint} >> /etc/environment
echo export MOUNT_EFS=${MountEfs} >> /etc/environment

# grabbing the files from s3 to set everything
echo "configuration files"
sudo /usr/bin/aws s3 sync s3://${S3ConfigFiles}/${Environment}/configuration_files /home/configuration
cd /home/configuration
sudo sh configuration.sh.template