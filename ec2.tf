provider "aws" {
  region     = "us-east-1"
}
resource "aws_instance" "example" {
  count         = var.instance_count
  ami           = "ami-0eb5f3f64b10d3e0e"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.ubuntu_allow_http_ssh.name}"]
  tags = {
    Name = "terra-${count.index + 1}"
  }
}
resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.example.id
  instance_id = aws_instance.example.id
}
resource "aws_ebs_volume" "example" {
  availability_zone = "us-east-1"
  size              = 10
}

resource "aws_iam_user" "test" {
  name = "terraform"
  path = "/terraform/"
}

resource "aws_iam_access_key" "test" {
  user = aws_iam_user.test.name
}
resource "aws_security_group" "ubuntu_allow_http_ssh" {
  name = "ubuntu_allow_http_ssh"
  description = "Allow HTTP and SSH inbound traffic"
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
variable "instance_count" {
  default ="2"
}
output "ip" {
  value = "${aws_instance.example.public_ip}"
}