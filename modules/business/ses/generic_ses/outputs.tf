## ---------------------------------------------------------------------------------------------------------------------
## Credenciais SMTP
## ---------------------------------------------------------------------------------------------------------------------

# Para gerar as credenciais SMTP, você pode fazer isso manualmente usando a CLI da AWS ou via script Terraform. 
# No entanto, o SES não fornece uma maneira direta de gerar as credenciais via Terraform. 
# O processo para converter as credenciais IAM em credenciais SMTP é feito manualmente.
#
# O comando seria algo como:
# aws ses create-smtp-credentials --username <AccessKeyID> --password <SecretAccessKey>
#
# Alternativamente, você pode utilizar as credenciais IAM diretamente no GLPI.

# Outputs para visualizar as chaves de acesso
output "ses_user_access_key_id" {
  value = nonsensitive(aws_iam_access_key.ses_smtp_access_key)
  sensitive = false
}

output "ses_user_secret_access_key" {
  value = nonsensitive(aws_iam_access_key.ses_smtp_access_key)
  sensitive = false
}
## ---------------------------------------------------------------------------------------------------------------------