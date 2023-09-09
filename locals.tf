### This is a file for the local variables 
locals {
  inbound_ports  = [22, 80, 443]
  outbound_ports = [0]
  tcp            = "tcp"
  any_where      = "0.0.0.0/0"

}