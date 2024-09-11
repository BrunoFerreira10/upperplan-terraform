output "certificate" {
  description = "ACM Certificate information"
  value       = module.acm_ssl.certificate
}