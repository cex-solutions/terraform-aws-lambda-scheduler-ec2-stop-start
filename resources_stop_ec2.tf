resource "aws_lambda_function" "stop_ec2_lambda" {
  count         = var.stop_ec2_enabled ? 1 : 0
  filename      = "${path.module}/ec2_lambda_handler.zip"
  function_name = var.prefix_name ? "${var.prefix_name}-stopEC2Lambda" : "stopEC2Lambda"
  role          = aws_iam_role.stop_start_ec2_role.arn
  handler       = "ec2_lambda_handler.stop"

  source_code_hash = filebase64sha256("ec2_lambda_handler.zip")

  runtime     = local.python_version
  memory_size = local.memory_size
  timeout     = local.timeout

  environment {
    variables = local.environment_variables
  }
}

resource "aws_cloudwatch_event_rule" "ec2_stop_rule" {
  count               = var.stop_ec2_enabled ? 1 : 0
  name                = var.prefix_name ? "${var.prefix_name}-StopEC2Instances" : "StopEC2Instances"
  schedule_expression = var.stop_ec2_schedule_expression
}

resource "aws_cloudwatch_event_target" "ec2_stop_rule_target" {
  count = var.stop_ec2_enabled ? 1 : 0
  rule  = aws_cloudwatch_event_rule.ec2_stop_rule.name
  arn   = aws_lambda_function.stop_ec2_lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_stop" {
  count         = var.stop_ec2_enabled ? 1 : 0
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stop_ec2_lambda.function_name
  principal     = "events.amazonaws.com"
}
