output "bastion" {
  description = "Bastion host information"
  value = {
    id        = aws_instance.bastion.id
    public_ip = aws_instance.bastion.public_ip
  }
}