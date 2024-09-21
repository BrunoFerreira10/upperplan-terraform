## ---------------------------------------------------------------------------------------------------------------------
## Lambda - Função que processa e-mails do SES e envia para o GLPI
## ---------------------------------------------------------------------------------------------------------------------

# - Preparar o pacote Lambda com dependências --------------------------------------------------------------------------
resource "null_resource" "package_lambda" {
  provisioner "local-exec" {
    command = <<EOT
    mkdir -p ${path.module}/build
    pip install requests -t ${path.module}/build
    cp ${path.module}/files/create-ticket.py ${path.module}/build/
    EOT
  }

  # Isso garante que sempre seja executado.
  triggers = {
    always_run = "${timestamp()}"
  }
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/build"
  output_path = "${path.module}/files/create-ticket.zip"

  depends_on = [null_resource.package_lambda]
}

# - Função Lambda -----------------------------------------------------------------------------------------------------
resource "aws_lambda_function" "create_ticket" {
  function_name = "${var.shortname}-create-ticket"
  role          = aws_iam_role.lambda_ses_role.arn
  handler       = "create-ticket.lambda_handler"
  runtime       = "python3.12"
  timeout       = 60

  # Caminho do código da função Lambda
  filename = "${path.module}/files/create-ticket.zip"

  # Variáveis de ambiente que serão usadas pela função Lambda
  environment {
    variables = {
      GLPI_API_URL   = var.glpi_api_url
      GLPI_USERNAME  = var.glpi_username
      GLPI_PASSWORD  = data.aws_ssm_parameter.glpi_password.value
      GLPI_APP_TOKEN = data.aws_ssm_parameter.glpi_app_token.value
      S3_BUCKET_NAME = var.project_bucket_name
    }
  }

  # Forçar a atualização sempre que o arquivo zip mudar
  #source_code_hash = filebase64sha256("${path.module}/files/create-ticket.zip")

  depends_on = [
    null_resource.package_lambda,
    data.archive_file.lambda_zip
  ]
}

# - Permissões para o SES acionar a função Lambda -----------------------------------------------------------------
resource "aws_lambda_permission" "allow_ses_invoke" {
  statement_id  = "AllowExecutionFromSES"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_ticket.function_name
  principal     = "ses.amazonaws.com"
}
