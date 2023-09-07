output "bastion_host_public_ip" {
    description = "Public IP of the bastion host"
    value = module.bastion_host.public_ip 
}

output "bastion_host_ssh_user" {
    description = "SSH username of the bastion host"
    value = module.bastion_host.ssh_user
}

output "bastion_host_role" {
    description = "ARN of the attached role used by the bastion host. Necessary for assuming role to use cli on the bastion host instance."
    value = aws_iam_role.bastion_host_role.arn
}