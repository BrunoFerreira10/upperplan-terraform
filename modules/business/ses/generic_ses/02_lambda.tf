## ---------------------------------------------------------------------------------------------------------------------
## Lambda - Função que processa e-mails do SES e envia para o GLPI
## ---------------------------------------------------------------------------------------------------------------------

# - Função Lambda -----------------------------------------------------------------------------------------------
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/files/create-ticket.py.tpl"
  output_path = "${path.module}/files/create-ticket.zip"
}

resource "aws_lambda_function" "create_ticket" {
  function_name = "${var.shortname}-create-ticket"
  role          = aws_iam_role.lambda_ses_role.arn
  handler       = "create-ticket.lambda_handler"
  runtime       = "python3.8"

  # Caminho do código da função Lambda
  filename = "${path.module}/files/create-ticket.zip"

  # Variáveis de ambiente que serão usadas pela função Lambda
  environment {
    variables = {
      GLPI_API_URL       = var.glpi_api_url
      GLPI_USERNAME      = var.glpi_username
      GLPI_PASSWORD      = data.aws_ssm_parameter.glpi_password.value
      GLPI_APP_TOKEN     = data.aws_ssm_parameter.glpi_app_token.value
    }
  }

  # Dependência para garantir que a política esteja associada antes de criar a função Lambda
  depends_on = [aws_iam_role_policy_attachment.lambda_ses_policy_attachment]
}

# - Permissões para o SES acionar a função Lambda -----------------------------------------------------------------
resource "aws_lambda_permission" "allow_ses_invoke" {
  statement_id  = "AllowExecutionFromSES"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_ticket.function_name
  principal     = "ses.amazonaws.com"
}
