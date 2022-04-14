locals {
  environment_variables = {
    REGION          = var.region
    START_TAG_NAME  = var.start_ec2_tag_name
    START_TAG_VALUE = var.start_ec2_tag_value
    STOP_TAG_NAME   = var.stop_ec2_tag_name
    STOP_TAG_VALUE  = var.stop_ec2_tag_value
  }

  python_version = "python3.8"
  memory_size    = "128"
  timeout        = "60"
}
