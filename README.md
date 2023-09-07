# ghtt230906

Architecture repository to satisfy the requirements of [tech test found here](https://docs.google.com/document/d/1sEG_pjnYEejehUwmMegBXX9wuyF26Dfb/edit?usp=sharing&ouid=110046131455741196059&rtpof=true&sd=true)

## Required Inputs

Inputs should be provided via a local .tfvars file or manually entered.

> [!WARNING]
> Do not push sensitive data to your remote repository

| Variable | Type | Expected |
| --- | --- | --- |
| **local_ssh_path** | `string` | Path to the .ssh folder on the local system |
| **name_one** | `string` | Name for an IAM user |
| **name_two** | `string` | Name for an IAM user |
| **primary_email_target** | `string` | Email target for S3 notifications |
| **secondary_email_target** | `string` | Email target for S3 notifications |
| **whitelisted_ips** | `list(string)` | List of IPs to be granted access to the bastion host |

## Architecture

![Architecture diagram](https://i.imgur.com/qDY1zau.png)
