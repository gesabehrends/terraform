provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "my_instance" {
  ami                    = "ami-0c55b159cbfafe1f0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
    #!/bin/bash
    echo "Hello world" > index.html
    nohup busybox httpd -f -p ${var.server_port} &
    EOF

  tags = {
    Name = "terraform-base-example"
  }
}
resource "aws_security_group" "instance" {
  name = "terraform-base-example-instance"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
variable "server_port" {
  description = "Port used for HTTP requests"
  type = number
  default = 8080
}

output "public_ip" {
  value = aws_instance.my_instance.public_ip
  description = "The public IP address of the web server"
}
