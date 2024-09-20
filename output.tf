# output "ami_id" {
# value = data.aws_ami.amazon-linux-image.id

# }
output "server-ip"{

    value = module.myapp-server.instance.public_ip
}

output "ami_amazon"{
value = module.myapp-server.ami_id

}