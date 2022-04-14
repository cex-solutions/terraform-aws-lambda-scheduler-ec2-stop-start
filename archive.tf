data "archive_file" "python_lambda_package" {
  type = "zip"
  source_file = "${path.module}/code/ec2_lambda_handler.py"
  output_path = "ec2_lambda_handler.zip"
}
