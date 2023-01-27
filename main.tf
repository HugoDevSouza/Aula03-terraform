terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = "dop_v1_b4583c6cd78f2e494bdc74abec541c0bcb6e5892d960056927678fceb4aa1243"
}

resource "digitalocean_droplet" "jenkins" {
  image  = "ubuntu-22-04-x64"
  name   = "jenkins"
  region = "nyc1"
  size   = "s-2vcpu-2gb"
  ssh_keys = [data.digitalocean_ssh_key.Aula-03-terraform.id]
}

data "digitalocean_ssh_key" "Aula-03-terraform" {
  name = "Aula-03-terraform"
}

resource "digitalocean_kubernetes_cluster" "k8s" {
  name   = "k8s"
  region = "nyc1"
  version = "1.25.4-do.0"

  node_pool {
    name       = "default"
    size       = "s-2vcpu-2gb"
    node_count = 2
  }
}


output "jenkins_IP" {
  value = digitalocean_droplet.jenkins.ipv4_address
}

resource "local_file" "foo" {
  content  = digitalocean_kubernetes_cluster.k8s.kube_config.0.raw_config
  filename = "kube_config.yaml"
}