terraform {
  backend "s3" {
    bucket         = "terraform-state-aakash-482311061933"
    key            = "ecs-capstone/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}