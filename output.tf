output "ubuntu_ami_id" {
  value = data.aws_ssm_parameter.ubuntu_ami.value
  sensitive = true
}

output "instance_id" {
  value = aws_instance.ubuntu_server.id
  sensitive = true
}

output "public_ip" {
  value = aws_instance.ubuntu_server.public_ip
  sensitive = true
}

output "ami_used" {
  value = data.aws_ssm_parameter.ubuntu_ami.value
    sensitive = true

}