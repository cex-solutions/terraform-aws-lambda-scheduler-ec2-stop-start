variable "account_id" {
  description = "AWS Account ID"
}
variable "region" {
  description = "AWS Region"
}

variable "prefix_name" {
  description = "Prefix name used in order to avoid multiple regions deployment issues"
}


#### Start Instance variables
variable "start_ec2_enabled" {
  default = false
}

variable "start_ec2_schedule_expression" {
  description = "Represents the cron expression used to Start EC2 Instance"
}

variable "start_ec2_tag_name" {
  description = "Represents tag key/name of EC2s that needs to be started"
}
variable "start_ec2_tag_value" {
  description = "Represents tag value of EC2s that needs to be started"
}



#### STOP Instance variables
variable "stop_ec2_enabled" {
  default = false
}

variable "stop_ec2_schedule_expression" {
  description = "Represents the cron expression used to Stop EC2 Instance"
}

variable "stop_ec2_tag_name" {
  description = "Represents tag key/name of EC2s that needs to be stopped"
}

variable "stop_ec2_tag_value" {
  description = "Represents tag value of EC2s that needs to be stopped"
}
