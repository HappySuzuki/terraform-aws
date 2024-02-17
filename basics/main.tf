
resource "aws_vpc" "vpc_demo" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "public_subnet_demo" {
  vpc_id                  = aws_vpc.vpc_demo.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2a"

  tags = {
    Name = "dev-public"
  }
}

resource "aws_internet_gateway" "igw-demo" {
  vpc_id = aws_vpc.vpc_demo.id

  tags = {
    Name = "dev-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc_demo.id

  tags = {
    Name = "dev_public_rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw-demo.id
}


resource "aws_route_table_association" "public_rt_association" {
  subnet_id      = aws_subnet.public_subnet_demo.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "sg_demo" {
  name        = "sg_dev"
  description = "dev security group"
  vpc_id      = aws_vpc.vpc_demo.id


  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_key_pair" "keypair_demo" {
  key_name   = "keypair_demo"
  public_key = file("~/.ssh/aws_keypair.pub")
}


resource "aws_instance" "demo_instance" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.server_ami.id
  key_name               = aws_key_pair.keypair_demo.id
  vpc_security_group_ids = [aws_security_group.sg_demo.id]
  subnet_id              = aws_subnet.public_subnet_demo.id
  user_data              = file("userdata.tpl")

  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "dev-instance"
  }

  provisioner "local-exec" {
    command = templatefile("${var.host_os}-ssh-config.tpl", {
      hostname     = self.public_ip,
      user         = "ubuntu",
      identifyfile = "~/.ssh/aws_keypair"
    })

    interpreter = var.host_os == "mac" ? ["bash", "-c"] : ["Powershell", "-Command"]
  }
}


