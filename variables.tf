variable "account_id" {
  type        = string
  description = "AWS Account ID"
}
variable "region" {
  type        = string
  description = "AWS Region"
}

variable "prefix_name" {
  type        = string
  description = "Prefix name used in order to avoid multiple regions deployment issues"
  default     = null
}


#### Start Instance variables
variable "start_ec2_enabled" {
  type    = bool
  default = false
}

variable "start_ec2_schedule_expression" {
  type        = string
  description = "Represents the cron expression used to Start EC2 Instance"
  default     = "cron(30 6 ? * 2-6 *)"
}

variable "start_ec2_tag_name" {
  type        = string
  description = "Represents tag key/name of EC2s that needs to be started"
  default     = "Auto-Start"
}
variable "start_ec2_tag_value" {
  type        = string
  description = "Represents tag value of EC2s that needs to be started"
  default     = "true"
}



#### STOP Instance variables
variable "stop_ec2_enabled" {
  type    = bool
  default = false
}

variable "stop_ec2_schedule_expression" {
  type        = string
  description = "Represents the cron expression used to Stop EC2 Instance"
  default     = "cron(0 19 ? * 2-6 *)"
}

variable "stop_ec2_tag_name" {
  type        = string
  description = "Represents tag key/name of EC2s that needs to be stopped"
  default     = "Auto-Stop"
}

variable "stop_ec2_tag_value" {
  type        = string
  description = "Represents tag value of EC2s that needs to be stopped"
  default     = "true"
}
