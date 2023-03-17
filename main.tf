terraform {
  required_version = ">= 1.2.1"

  cloud {
    organization = "def-elalib-ivado-tfcloud-org"

    workspaces {
      name = "alliancecan-ivado-dev-ca-east"
    }
  }

}


variable "pool" {
  description = "Slurm pool of compute nodes"
  default = []
}

module "openstack" {
  source         = "./openstack"
  config_git_url = "https://github.com/ComputeCanada/puppet-magic_castle.git"
  config_version = "12.3.0"

  cluster_name = "phoenix"
  domain       = "calculquebec.cloud"
  image        = "Rocky-8.7-x64-2023-02"

  instances = {
    mgmt   = { type = "p4-6gb", tags = ["puppet", "mgmt", "nfs"], count = 1 }
    login  = { type = "p2-3gb", tags = ["login", "public", "proxy"], count = 1 }
    # node   = { type = "p2-3gb", tags = ["node"], count = 1 }
    gpu-node   = { type = "g1-8gb-c4-22gb", tags = ["node"], count = 1 }
  }

  # var.pool is managed by Slurm through Terraform REST API.
  # To let Slurm manage a type of nodes, add "pool" to its tag list.
  # When using Terraform CLI, this parameter is ignored.
  # Refer to Magic Castle Documentation - Enable Magic Castle Autoscaling
  pool = var.pool

  volumes = {
    nfs = {
      home     = { size = 100 }
      project  = { size = 50 }
      scratch  = { size = 50 }
    }
  }

  # public_keys = [file("~/.ssh/id_rsa_wsl_hp_perso_cc.pub")]
  public_keys = [file("~/.ssh/id_rsa_hp655g9_wsl_arbutus.pub"), file("~/.ssh/id_rsa_wsl_hp_perso_cc.pub")]
  generate_ssh_key = false

  nb_users = 2
  # Shared password, randomly chosen if blank
  guest_passwd = ""

  os_floating_ips = {
    login1 = "206.12.89.223"
  }

  hieradata = {
    "profile::ceph::share_name"   : "def-elalib-ivado-cephFS-test-rw"
    "profile::ceph::access_key"   : "AQCOBhJkogYUNRAAs5jC7laXx/HgbRrsrBT2Zw=="
    "profile::ceph::export_path"  : "10.30.201.3:6789,10.30.202.3:6789,10.30.203.3:6789:/volumes/_nogroup/0ece7193-9fc1-4bed-91b8-0ebc97fb2a32"
    "profile::ceph::mon_host"     : "10.30.201.3:6789,10.30.202.3:6789,10.30.203.3:6789"
    "profile::ceph::mount_binds"  : "/mnt/ceph"
    "profile::ceph::mount_name"   : "def-elalib-ivado-cephFS-test-rw"
    "profile::ceph::binds_fcontext_equivalence" : "/def-elalib-ivado-cephFS-test-rw"

  }
}

output "accounts" {
  value = module.openstack.accounts
}

output "public_ip" {
  value = module.openstack.public_ip
}

## Uncomment to register your domain name with CloudFlare
# module "dns" {
#   source           = "./dns/cloudflare"
#   email            = "you@example.com"
#   name             = module.openstack.cluster_name
#   domain           = module.openstack.domain
#   public_instances = module.openstack.public_instances
#   ssh_private_key  = module.openstack.ssh_private_key
#   sudoer_username  = module.openstack.accounts.sudoer.username
# }

## Uncomment to register your domain name with Google Cloud
# module "dns" {
#   source           = "./dns/gcloud"
#   email            = "you@example.com"
#   project          = "your-project-id"
#   zone_name        = "you-zone-name"
#   name             = module.openstack.cluster_name
#   domain           = module.openstack.domain
#   public_instances = module.openstack.public_instances
#   ssh_private_key  = module.openstack.ssh_private_key
#   sudoer_username  = module.openstack.accounts.sudoer.username
# }

# output "hostnames" {
#   value = module.dns.hostnames
# }
