provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "scan_role" {
  name = "x"
}

resource "aws_iam_policy" "scan_policy" {
  name = "x"
}

resource "aws_iam_role_policy_attachment" "scan_attach" {
  name = "x"
}

resource "aws_security_group" "web" {
  name = "x"
}

resource "aws_security_group_rule" "web_in" {
  name = "x"
}

resource "random_uuid" "suffix" {
  keepers = {}
}

data "aws_caller_identity" "me" {}
