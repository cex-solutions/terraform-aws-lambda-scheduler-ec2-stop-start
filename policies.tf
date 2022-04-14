resource "aws_iam_policy" "stop_start_ec2_policy" {
  name = var.prefix_name ? "${var.prefix_name}-StopStartEC2Policy": "StopStartEC2Policy"
  path = "/"
  description = "IAM policy for stop and start EC2 from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:${var.region}:${var.account_id}:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Start*",
        "ec2:Stop*",
        "ec2:DescribeInstances*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "stop_start_ec2_role" {
  name = var.prefix_name ? "${var.prefix_name}-StopStartEC2Role" : "StopStartEC2Role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_role_policy" {
  role = aws_iam_role.stop_start_ec2_role.name
  policy_arn = aws_iam_policy.stop_start_ec2_policy.arn
}
