

data "template_file" "master_user_data" {
  template = "${file("${path.module}/master.tpl")}"
}

data "template_file" "worker_user_data" {
  template = "${file("${path.module}/worker.tpl")}"
}

resource "aws_key_pair" "key" {
  //ssh-keygen -t rsa
  key_name   = "k8s"
  public_key = file("k8s.pub")
}
//https://gist.github.com/rkaramandi/44c7cea91501e735ea99e356e9ae7883
resource "aws_instance" "master_instance" {
  key_name      = aws_key_pair.key.key_name
  ami           = lookup(var.ami,var.aws_region)
  instance_type = var.master_instance_type
  user_data      = data.template_file.master_user_data.rendered
  security_groups = [aws_security_group.security_group.name]
  tags = {
    Name = "Master"
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("key")
    host        = self.public_ip
  }

}

resource "aws_security_group" "security_group" {
  name        = "kops_sg"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = var.protocol
    cidr_blocks = ["124.123.173.27/32"]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = var.protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = var.protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "kops_sg"
  }
}

resource "aws_instance" "worker_instances" {
  count         = var.instance_count
  ami           = lookup(var.ami,var.aws_region)
  instance_type = var.worker_instance_type
  key_name      = aws_key_pair.key.key_name
  user_data     = data.template_file.worker_user_data.rendered
  security_groups = [aws_security_group.security_group.name]
  tags = {
    Name  = "Worker-${count.index + 1}"
  }
  
    depends_on = [aws_instance.master_instance]

}