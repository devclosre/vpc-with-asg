### Using Template file
data "template_file" "ansible_userdata" {
  template = file("ansible_install.sh")
}

### Install Ansible Server
resource "aws_instance" "ansible_master" {
  ami                         = data.aws_ami.ubuntu.id
  key_name                    = var.instance_keypair
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public_subnets[0].id
  vpc_security_group_ids      = [aws_security_group.web-sg.id]
  /* user_data                   = data.template_file.ansible_userdata.rendered */

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y software-properties-common",
      "sudo add-apt-repository --yes --update ppa:ansible/ansible",
      "sudo apt install -y ansible",
      "ansible --version"
    ]
  }

  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host     = aws_instance.ansible_master.public_ip
  }

 tags = {
    Name = "ansible_master"
  }
}







