provider "aws" {
  region = "ap-northeast-1"
}

// terraform {
//   required_version = ">= 0.11.3"
// 
//   backend "s3" {
//     bucket = "yoan-terraform"
//     key    = "terraform.tf"
//     region = "ap-northeast-1"
//   }
// }

data "terraform_remote_state" "network" {
  backend = "s3"
  config {
    bucket = "yoan-terraform"
    key    = "terraform.tf"
    region = "ap-northeast-1"
  }
}
