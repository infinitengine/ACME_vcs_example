# declare your service account variable here or within a variables.tf file
variable "GOOGLE_CREDENTIALS" {
	type = string
	default = ""
}
variable "stackpath_stack_id" {
	type = string
	default = ""
}
variable "stackpath_client_id" {
        type = string
}
variable "stackpath_client_secret" {
        type = string
}


# Specify StackPath Provider and your access details
provider "stackpath" {
  stack_id      = var.stackpath_stack_id
  client_id     = var.stackpath_client_id
  client_secret = var.stackpath_client_secret
}

provider "aws" {
  region = var.region
}

provider "google" {
  credentials = var.GOOGLE_CREDENTIALS

  project = "265583671093"
  region  = "us-central1"
  zone    = "us-central1-c"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ubuntu" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  tags = {
    Name                 = var.instance_name
    "Linux Distribution" = "Ubuntu"
  }
}

# Create a new Ubuntu virtual machine workload
resource "stackpath_compute_workload" "erik" {
  name = "Erik Workload"
  slug = "erik"

  # Define multiple labels on the workload VM.
  labels = {
    "role"        = "web-server"
    "environment" = "production"
  }
	
  # Define the network interface.
  network_interface {
    network = "default"
  }

  # Define an Ubuntu virtual machine
  virtual_machine {
    # Name that should be given to the VM
    name = "app"

    # StackPath image to use for the VM
    image = "stackpath-edge/ubuntu-2104-hirsute:v202104291503"

    # Hardware resources dedicated to the VM
    resources {
      requests = {
        # The number of CPU cores to allocate
        "cpu" = "1"
        # The amount of memory the VM should have
        "memory" = "2Gi"
      }
    }

    # The ports that should be publicly exposed on the VM.
    port {
      name = "ssh"
      port = 22
      protocol = "TCP"
      enable_implicit_network_policy = true
    }

    port {
      name = "http"
      port = 80
      protocol = "TCP"
      enable_implicit_network_policy = true
    }

    port {
      name =  "https"
      port = 443
      protocol = "TCP"
      enable_implicit_network_policy = true
    }

    # Cloud-init user data. Provide at least a public key
    user_data = <<EOT
#cloud-config
ssh_authorized_keys:
 - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDE2jqFrA3jzB8IYL/hJXexTTfRyhEq6tW1GDvYMlD21vclkxOYbwGtxfPA8YWy9+Z+bmoDvOd2Gjw88eosXGdbQvWCpPa52qP26sgXRyZxhaBSdIPj70mGUbwu2sPzy8uWR80xs5FFzjSa+frAInjFroBXrKnsZOAP50ApzwgNUcODi42GU6Fkb1J2Szz8nQ9q/Yy749x5+06qlzSmY7TYQOABj/9vwAczxniseMWpZaCGeGirigaDxHU+Y5HmO7Sunv3fdiIHvXawQZ1110zKYp4tNJacbjPkh1Fyo2D8aF3GyuVy2RmjQANUbMdrYvStGqFxCUDMS44G6ypDQ9r6ChjveS0v1/5DEb+HWY6coDKE1C0FBWx+aKgwrswjDHEkx8ETnFjo4KuJ44444zUtQlW10e+pHDGOwn6cC0cS6iL0pz3Hf5y+H0d32e5m6gdwd13tXQpt0SLAr81F86E91pOnJOxkN4FoAh8HpDvhpmYn3v5OCp/we3ZS6ZOYK80=
EOT

    liveness_probe {
      period_seconds = 60
      success_threshold = 1
      failure_threshold = 4
      initial_delay_seconds = 60
      http_get {
        port = 80
        path = "/"
        scheme = "HTTP"
        http_headers = {
          "content-type" = "application/json"
        }
      }
    }

    # Define a probe to determine when the instance is ready to serve traffic.
    readiness_probe {
      tcp_socket {
        port = 80
      }
      period_seconds = 60
      success_threshold = 1
      failure_threshold = 4
      initial_delay_seconds = 60
    }

    # Mount an additional volume into the virtual machine.
    volume_mount {
      slug       = "logging-volume"
      mount_path = "/var/log"
    }
  }

  # Define the target configurations
  target {
    name = "us"
    deployment_scope = "cityCode"
    min_replicas = 1
    selector {
      key = "cityCode"
      operator = "in"
      values = [
        "SEA",
        "JFK",
	"DFW",
	"MIA",
	"ORD",
	"SJC",
	"NRT",
	"AMS",
	"GRU",
      ]
    }
  }

  # Provision a new additional volume that can be mounted to the containers and
  # virtual machines defined in the workload.
  volume_claim {
    name = "Logging volume"
    slug = "logging-volume"
    resources {
      requests = {
        storage = "100Gi"
      }
    }
  }
}

#Google Cloud
resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "default"
    access_config {
    }
  }
}
