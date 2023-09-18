output "managePublicAddress" {
  value = "ssh ec2-user@${aws_instance.manage-node.public_ip}"
}

output "LienDeConnexionAuClusterCeph" {
  value = "https://${aws_instance.manage-node.public_ip}:8443"
}

output "LienDeConnexionGrafana" {
  value = "https://${aws_instance.worker-node[3].public_ip}:3000"
}

output "workerPublicAddress" {
  value = aws_instance.worker-node[*].public_ip
}

output "clientPublicAddress" {
  value = aws_instance.client.public_ip
}

output "managePrivateAddress1" {
  value = "${aws_instance.manage-node.private_ip}   manage.example.com   manage"
}

output "Server1-server2-server3-grafana_privateIPAddress" {
  value = aws_instance.worker-node[*].private_ip
}

output "clientPrivateAddress1" {
  value = "${aws_instance.client.private_ip}   client.example.com   client"
}