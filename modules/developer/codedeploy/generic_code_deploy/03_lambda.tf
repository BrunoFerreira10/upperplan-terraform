## --------------------------------------------------------------------------------------------------------------------
## Criação da função lambda via arquivo python.
## --------------------------------------------------------------------------------------------------------------------
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/scripts/lambda_function.py"
  output_path = "lambda_function.zip"  
}

resource "aws_lambda_function" "codedeploy_trigger_lambda" {  
  function_name = "CodeDeployTriggerLambda"
  role          = aws_iam_role.lambda_codedeploy_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"

  filename         = "lambda_function.zip" 
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      APPLICATION_NAME       = var.codedeploy_settings.application_name
      DEPLOYMENT_GROUP_NAME  = var.codedeploy_settings.application_name
    }
  }
}

## --------------------------------------------------------------------------------------------------------------------
## Subscrição do lambda ao SNS topic
## --------------------------------------------------------------------------------------------------------------------
# Criação da associação entre o SNS e a Lambda
resource "aws_sns_topic_subscription" "lambda_subscription" {
  topic_arn = aws_sns_topic.s3_deployment_notifications.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.codedeploy_trigger_lambda.arn
}

# Permissão para que o SNS invoque a função Lambda
resource "aws_lambda_permission" "allow_sns_invoke" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.codedeploy_trigger_lambda.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.s3_deployment_notifications.arn
}
