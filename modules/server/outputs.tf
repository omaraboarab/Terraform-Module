output "instance"{

    value = aws_instance.myapp-server
}
output "ami_id" {
value = data.aws_ami.amazon-linux-image.id

} 