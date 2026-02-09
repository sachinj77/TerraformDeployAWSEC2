resource "aws_security_group" "demo-sg" {
  name   = "${var.env_prefix}-demo-sg"
  vpc_id = var.vpc_id

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
  tags = {
    Name = "${var.env_prefix}-demo-sg"
  }
}

resource "aws_key_pair" "ssh-key" {
  key_name   = "server-key"
  public_key = file(var.public_key_location)
}

resource "aws_instance" "server-one" {
  ami                         = var.ami_zabbix # referencing variable and prompt for ami image details and instance type
  instance_type               = var.inst_type_zabbix
  associate_public_ip_address = true
  private_ip                  = var.private_ip # specify an ip the subnet range for local network (private ip)
  availability_zone           = var.avail_zone
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.demo-sg.id]
  key_name                    = "server-key"
  #key_name = "new-ubuntu1"

  #user_data = file("nginx.sh")           # to use aws user data , mention the script to execute

  /*   provisioner "file" {			  # copy the script folder to the instance created using the connection block details to connect to the instance
    source = "script"
    destination = "/tmp"
  }
  provisioner "file" {
    source = "zabbix_demo.sql"		 # copy the zabbix demo DB backup to target server /tmp (using same connection block)
    destination = "/tmp/zabbix_demo.sql"
  }
  provisioner "remote-exec" {		 # execute the copied scripts in target /tmp directory
    inline = [
        "sudo chmod +x /tmp/script/*",
        "sudo /tmp/script/zabbix.sh"
    ]
  }
  connection {
    type = "ssh"			# connect using the self instance public ip after getting created and the aws key file .
    host = self.public_ip
    user = "ubuntu"
    private_key = file("demo-key.pem")
  } */

  tags = {
    Name = "${var.env_prefix}-Zabbix-server-main"
  }
}
