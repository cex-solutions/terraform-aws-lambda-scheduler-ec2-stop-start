resource "aws_lambda_function" "start_ec2_lambda" {
  count         = var.start_ec2_enabled ? 1 : 0
  filename      = data.archive_file.python_lambda_package.output_path
  function_name = var.prefix_name != null ? "${var.prefix_name}-startEC2Lambda" : "startEC2Lambda"
  role          = aws_iam_role.stop_start_ec2_role.arn
  handler       = "ec2_lambda_handler.start"

  source_code_hash = filebase64sha256(data.archive_file.python_lambda_package.output_path)

  runtime     = local.python_version
  memory_size = local.memory_size
  timeout     = local.timeout

  environment {
    variables = local.environment_variables
  }
}

resource "aws_cloudwatch_event_rule" "ec2_start_rule" {
  count               = var.start_ec2_enabled ? 1 : 0
  name                = var.prefix_name != null  ? "${var.prefix_name}-StartEC2Instances" : "StartEC2Instances"
  schedule_expression = var.start_ec2_schedule_expression
}

resource "aws_cloudwatch_event_target" "ec2_start_rule_target" {
  count = var.start_ec2_enabled ? 1 : 0
  rule  = aws_cloudwatch_event_rule.ec2_start_rule[count.index].name
  arn   = aws_lambda_function.start_ec2_lambda[count.index].arn
}

resource "aws_lambda_permission" "allow_cloudwatch_start" {
  count         = var.start_ec2_enabled ? 1 : 0
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.start_ec2_lambda[count.index].function_name
  principal     = "events.amazonaws.com"
}
