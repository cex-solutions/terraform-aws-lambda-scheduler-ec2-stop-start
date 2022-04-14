import boto3
import os

# Reading environment variables
region = os.getenv("REGION")
start_tag_name = os.getenv("START_TAG_NAME")
start_tag_value = os.getenv("START_TAG_VALUE")
stop_tag_name = os.getenv("STOP_TAG_NAME")
stop_tag_value = os.getenv("STOP_TAG_VALUE")

# Initializing the EC2 boto client
ec2 = boto3.client('ec2', region_name=region)

# Getting instances tagged with Start tag
start_instances_response = ec2.describe_instances(Filters=[
    {
        'Name': f'{start_tag_name}',
        'Values': [
            f'{start_tag_value}',
        ]
    },
])

# Getting instances tagged with Start tag
stop_instances_response = ec2.describe_instances(Filters=[
    {
        'Name': f'{stop_tag_name}',
        'Values': [
            f'{stop_tag_value}',
        ]
    },
])


def _get_instance_ids(response):
    instances = []
    for reservation in response["Reservations"]:
        for instance in reservation["Instances"]:
            instances.append(instance["InstanceId"])
    return instances


start_instances = _get_instance_ids(start_instances_response)
stop_instances = _get_instance_ids(stop_instances_response)


def stop(event, context):
    ec2.stop_instances(InstanceIds=stop_instances)
    print('stopped instances: ' + str(stop_instances))


def start(event, context):
    ec2.start_instances(InstanceIds=start_instances)
    print('started  instances: ' + str(start_instances))
