output "net_sg_webserver_id" {
  value = "${aws_security_group.webserver-sg.id}"
}

output "net_subnet_1_id" {
  value = "${aws_subnet.subnet_1.id}"
}

output "net_subnet_2_id" {
  value = "${aws_subnet.subnet_2.id}"
}

output "net_elb_id" {
  description = "DNS Name of the ELB"
  value       = "${aws_elb.web_elb.id}"
}