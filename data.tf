# data "aws_ami" "ubuntu" {
#     most_recent = true

#     filter{
#         name = "name"
#         values = 
#     }
  
# }
// Get latest official Ubuntu 22.04 AMI from SSM
data "aws_ssm_parameter" "ubuntu_ami" {
  name = "/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
 

}

