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
    # Query EC2 Instances base on a tag name & value
    # Returns list of found EC2 Instances based on filters
    return ec2.describe_instances(Filters=[
        {
            'Name': f'tag:{tag_name}',
            'Values': [
                f'{tag_value}',
            ]
        },
    ])


def _get_instance_ids(tag_name: str, tag_value: str):
    response = _get_instances_by_tag(tag_name, tag_value)
    instance_ids = []
    if len(response["Reservations"]):
        logger.info("Matching instance were found. Parsing response to extract Instance Ids")
        # Parsing the describe instances response in order to extract EC2 Instance Ids
        for reservation in response["Reservations"]:
            for instance in reservation["Instances"]:
                instance_ids.append(instance["InstanceId"])
    return instance_ids


def stop(event, context):
    tag_name = os.getenv("STOP_TAG_NAME")
    tag_value = os.getenv("STOP_TAG_VALUE")
    instance_ids = _get_instance_ids(tag_name, tag_value)
    if instance_ids:
        ec2.stop_instances(InstanceIds=instance_ids)
        logger.info('Successfully stopped instances: ' + str(instance_ids))
    else:
        logger.info(f'No matching Instances were found using tag name: {tag_name} and value: {tag_value}')


def start(event, context):
    tag_name = os.getenv("START_TAG_NAME")
    tag_value = os.getenv("START_TAG_VALUE")
    instance_ids = _get_instance_ids(tag_name, tag_value)
    if instance_ids:
        ec2.start_instances(InstanceIds=instance_ids)
        logger.info('Successfully started instances: ' + str(instance_ids))
    else:
        logger.info(f'No matching Instances were found using tag name: {tag_name} and value: {tag_value}')
