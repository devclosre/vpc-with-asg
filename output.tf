### AMI ID Output
output "ubuntu_ami_id" {
  description = "Latest Ubuntu AMI ID"
  value       = data.aws_ami.ubuntu.id
}

output "asg_instances_id" {
  value = data.aws_instances.asg_instances.ids
}