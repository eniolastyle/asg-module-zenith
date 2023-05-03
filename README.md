# Provisioning AWS Load balancer and ASG with Terraform and Deploying with GHA

This project uses Terraform to provision an AWS Load Balancer and ASG, and uses GitHub Actions to automate the deployment of the infrastructure. The infrastructure can be deployed to multiple environments (e.g. dev, stage, prod) by using different Terraform workspaces.

## Outputs and GHA Process

## Pre-requisites

- An AWS account.
- Terraform CLI installed.
- AWS CLI installed and configured with access and secret keys.

## Usage

1. Clone this repository:

git clone https://github.com/eniolastyle/terraform-lb-asg.git

2. Change into the project directory:

cd terraform-one

3. Create a `terraform.tfvars` file to define your variables:

- region = "us-east-1"
- key_name = "your-keypair-name"

4. Initialize the Terraform project:

terraform init -backend-config="bucket=<s3_bucket_name>"

5. Preview the changes that Terraform will make:

terraform plan --var-file="terraform.tfvars"

6. Apply the changes to create the resources:

terraform apply --var-file="terraform.tfvars"

7. When you're finished with the resources, destroy them:

terraform destroy --var-file="terraform.tfvars"

## Variables

The following variables can be defined in your `Github Secrets` file:

| Variable   | Description                                      | Type   |
| ---------- | ------------------------------------------------ | ------ |
| access_key | AWS access key                                   | string |
| secret_key | AWS secret key                                   | string |
| region     | AWS region where resources will be created       | string |
| key_name   | Name of an existing key pair in your AWS account | string |
| public_key | Your generated pub key with ssh-keygen           | string |

## GitHub Actions

This project uses GitHub Actions to automate the deployment of the infrastructure. There are four jobs defined in the `.github/workflows/deploy.yml` file:

1. **lint:** This job lints the Terraform code using the tflint tool.

2. **terraform-plan-feature-a:** This job runs `terraform init` and `terraform plan` when a push is made to the `feature-a` branch. This job will only plan changes, it will not apply them.

3. **terraform-apply-main:** This job runs `terraform apply` when a pull request is closed and merged to the `main` branch. This job will apply the changes.

4. **terraform-destroy-feature-b:** This job runs `terraform destroy` when a pull request is closed and merged to the `feature-b` branch. This job will destroy the infrastructure.

## Conclusion

This project demonstrates how to use Terraform to provision an AWS Load Balancer and ASG, and how to automate the deployment of the infrastructure using GitHub Actions. Feel free to customize the code and workflows to fit your needs.

If you have any further clarification, kindly reach out to me with the below information.

## Author

Lawal Eniola Abdullateef  
Twitter: [@eniolaamiola\_](https://twitter.com/eniolaamiola_).
linkedIn: [Lawal Abdullateef\_](https://www.linkedin.com/in/abdullateef-lawal-b46786214).
Blog: [devopsnode\_](https://devopsnode.hashnode.dev).
