
# 🚀 Terraform AWS Infrastructure Project

This project builds a full AWS VPC-based infrastructure using **Terraform**. It includes:

- A custom **VPC**
- Public & private **subnets**
- **Internet Gateway** and **NAT Gateway**
- An **EC2 instance** in the public subnet
- A secure **S3 bucket** for remote state storage
- A **DynamoDB table** for state locking

## 🧱 Technologies Used

- Terraform
- AWS VPC, EC2, S3, DynamoDB
- IAM Roles & Security Groups

## 📂 Project Structure

main.tf               # Provider and EC2 setup
vpc.tf                # VPC, subnets, and networking resources
s3_backend.tf         # S3 backend and DynamoDB setup
outputs.tf            # Output variables
variables.tf          # Input variables
.gitignore            # Git ignored files

## ⚙️ How to Use

1. Clone the repo
2. Run `terraform init`
3. Run `terraform apply`

Make sure you have AWS CLI configured and your credentials set.

## 🗄️ Remote Backend

This project uses:
- **S3 bucket**: to store `.tfstate` remotely
- **DynamoDB table**: to lock state and avoid race conditions

## 📌 Best Practices Followed

- Remote state management
- Clean resource naming
- `.gitignore` includes all sensitive files
- Modular and organized codebase

## 👨‍💻 Author

Made with ☕ and Terraform by Akash J Nair

## 📝 License

This project is licensed under the [MIT License](./LICENSE).
