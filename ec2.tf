resource "aws_instance" "db" {
    ami = "ami-041e2ea9402c46c32"
    #vpc_security_group_ids = ["sg-0fea5e49e962e81c9"]
    instance_type = "t3.micro"

   provisioner "local-exec" {
    command = "echo ${self.public_ip} > public_ips.txt"

    # above command is, we ask for db private id ,in the provisioners
    # will create a file called private_ips.txt and keep the ip address in it.
  }

#   provisioner "local-exec" {
#     #     command = "ansible-playbook -i private_ips.txt web.yaml"
#     # }

## remote exec

# here what we did is db server we created through terraform and db itself connected with ansible 
# and connected through SSH and it will do the configuration

 connection {
        type     = "ssh"
        user     = "ec2-user"
        password = "DevOps321"
        host     = self.public_ip
    }

    provisioner "remote-exec" {
        inline = [
            "sudo dnf install ansible -y",
            "sudo dnf install nginx -y",
            "sudo systemctl start nginx"
        ]
    } 
}
