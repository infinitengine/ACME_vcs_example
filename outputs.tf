output "instance_ami" {
  value = aws_instance.ubuntu.ami
}

output "instance_arn" {
  value = aws_instance.ubuntu.arn
}

# Output a StackPath compute workload's instances' name, internal IP addresses, 
# location, and status
output "my-compute-workload-instances" {
  value = {
    for instance in stackpath_compute_workload.my-compute-workload.instances:
    instance.name => {
      ip_address = instance.external_ip_address
      phase      = instance.phase
      location   = instance.location
    }
  }
}
