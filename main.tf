provider "aws" {
  region = var.aws_region
}

# Define AWS Region
variable "aws_region" {
  default = "us-east-1"
}

# Define base, dev, and prod configurations
variable "base_config" {
  default = {
    instance_type = "t2.micro"
    tags = {
      owner = "team-infra"
    }
  }
}

variable "dev_config" {
  default = {
    instance_type = "t2.small"
    tags = {
      environment = "dev"
    }
  }
}

variable "prod_config" {
  default = {
    instance_type = "m5.large"
    tags = {
      environment = "prod"
    }
  }
}

# Output the merged configurations
output "dev_combined" {
  value = merge(var.base_config, var.dev_config)
}

output "prod_combined" {
  value = merge(var.base_config, var.prod_config)
}

# Create an EC2 instance for the development environment
resource "aws_instance" "dev_instance" {
  ami           = "ami-0c02fb55956c7d316" # Replace with a valid AMI for your region
  instance_type = merge(var.base_config, var.dev_config)["instance_type"]

  tags = merge(
    var.base_config["tags"],
    var.dev_config["tags"]
  )
}

# Create an EC2 instance for the production environment
resource "aws_instance" "prod_instance" {
  ami           = "ami-0e86e20dae9224db8"
  subnet_id = "subnet-02efa144df0a77c13" 
  instance_type = merge(var.base_config, var.prod_config)["instance_type"]

  tags = merge(
    var.base_config["tags"],
    var.prod_config["tags"]
  )
}
