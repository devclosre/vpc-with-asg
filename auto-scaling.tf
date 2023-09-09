### Creating a Null resource
resource "null_resource" "nginx_server" {
    count = aws_autoscaling_group.web-asg.desired_capacity

  triggers = {
    instance_id = aws_autoscaling_group.web-asg.id
  }

  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host     = data.aws_instances.asg_instances[*].public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y nginx",
      "sudo service nginx start",
      "sudo service nginx enable",
      "echo 'Hello World' >> /var/www/html/index.html"
    ]
  }
}

### Launch Configuration for ASG
resource "aws_launch_configuration" "web-instance-lc" {
  name_prefix     = "web-instance-lc"
  image_id        = data.aws_ami.ubuntu.id # Ubuntu AMI from ap-southeast-4
  instance_type   = var.instance_type
  key_name        = var.instance_keypair
  security_groups = [aws_security_group.web-sg.id]
    
}

### Auto Scaling Group
resource "aws_autoscaling_group" "web-asg" {
  name = "web-asg"
  # Attach ASG to public subnets for external access
  # availability_zones = [ "ap-southeast-4a" ]
  launch_configuration = aws_launch_configuration.web-instance-lc.name
  min_size             = 1
  max_size             = 10
  desired_capacity     = 1
  #vpc_zone_identifier = aws_subnet.public_subnets[*].id
  vpc_zone_identifier = [
    for subnet in aws_subnet.public_subnets : subnet.id
  ]


  tag {
    key                 = "Name"
    value               = "Asg-web-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}



data "aws_instances" "asg_instances" {
  filter {
    name = "tag.aws.autoscaling.web-asg"
    values = ["web-asg"]
    /*
    count = aws_autoscaling_group.web-asg.desired_capacity
    instance_id = data.aws_instances.asg_instances[*] 
    */
  }
}


