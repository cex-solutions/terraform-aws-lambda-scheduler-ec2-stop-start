import boto3
import os
import logging as logger


# Reading environment variables
region = os.getenv("REGION")
start_tag_name = os.getenv("START_TAG_NAME")
start_tag_value = os.getenv("START_TAG_VALUE")
stop_tag_name = os.getenv("STOP_TAG_NAME")
stop_tag_value = os.getenv("STOP_TAG_VALUE")

# Initializing the EC2 boto client
ec2 = boto3.client('ec2', region_name=region)


def _get_instances_by_tag(tag_name: str, tag_value: str):
    return ec2.describe_instances(Filters=[
        {
            'Name': f'{tag_name}',
            'Values': [
                f'{tag_value}',
            ]
        },
    ])


def _get_instance_ids(tag_name: str, tag_value: str):
    response = _get_instances_by_tag(tag_name, tag_value)
    instance_ids = []
    for reservation in response["Reservations"]:
        for instance in reservation["Instances"]:
            instance_ids.append(instance["InstanceId"])
    return instance_ids


def stop(event, context):
    tag_name = os.getenv("STOP_TAG_NAME")
    tag_value = os.getenv("STOP_TAG_VALUE")
    instances = _get_instance_ids(tag_name, tag_value)
    ec2.stop_instances(InstanceIds=instances)
    logger.info('stopped instances: ' + str(instances))


def start(event, context):
    tag_name = os.getenv("START_TAG_NAME")
    tag_value = os.getenv("START_TAG_VALUE")
    instances = _get_instance_ids(tag_name, tag_value)
    ec2.start_instances(InstanceIds=instances)
    logger.info('started  instances: ' + str(instances))
