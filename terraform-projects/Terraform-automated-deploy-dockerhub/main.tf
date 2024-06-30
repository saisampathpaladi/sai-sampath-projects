provider "aws" {
  region = "us-east-1"  # Change this to your desired AWS region
}

# Define variables for easier configuration
variable "docker_image" {
  description = "DockerHub image name for your application"
  default     = "yourusername/yourapp:latest"  # Replace with your DockerHub image
}

variable "instance_type" {
  description = "Instance type for the EC2 instances"
  default     = "t2.micro"  # Adjust as needed
}

variable "key_name" {
  description = "Name of the SSH key pair to use for the instances"
  default     = "your-key-pair"  # Replace with your key pair name
}

# Create security group allowing SSH and HTTP access
resource "aws_security_group" "instance_sg" {
  name        = "instance_sg"
  description = "Security group for EC2 instances"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch EC2 instances
resource "aws_instance" "ec2_instance" {
  count         = 2
  ami           = "ami-12345678"  # Replace with your desired AMI ID
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [aws_security_group.instance_sg.name]
  
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",  # Update packages (for Amazon Linux)
      "sudo yum install -y docker",  # Install Docker (for Amazon Linux)
      "sudo service docker start",  # Start Docker service
      "sudo usermod -a -G docker ec2-user"  # Add ec2-user to docker group (for Amazon Linux)
    ]
  }
  
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/your-key-pair.pem")  # Replace with your private key path
    host        = self.public_ip
  }
}

# Deploy Docker container on instances
resource "null_resource" "deploy_app" {
  depends_on = [aws_instance.ec2_instance]
  
  provisioner "local-exec" {
    command = <<EOF
      ssh -i ~/.ssh/your-key-pair.pem ec2-user@${aws_instance.ec2_instance.*.public_ip} "docker run -d -p 80:80 ${var.docker_image}"
    EOF
  }
}
