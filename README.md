# Terraform AWS

Infrastructure as Code and AWS cloud examples.

## Terraform Commands

```
terraform init
terraform plan

terraform apply
terraform apply -replace aws_instance.demo_instance
terraform apply -refresh-only

terraform state list
terraform state show aws_vpc.vpc_demo

terraform destroy
terraform destroy -auto-approve

terraform output
```
