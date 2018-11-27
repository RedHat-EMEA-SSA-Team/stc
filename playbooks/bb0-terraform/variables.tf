

variable "openstack_user_name"   { type    = "string" }
variable "openstack_tenant_name" { type    = "string" }
variable "openstack_password"    { type    = "string" }
variable "openstack_auth_url"    { type    = "string" }
variable "openstack_region"      { type    = "string" default = "RegionOne" }

variable "master_count" {
  type    = "string"
  default = "1"
}


variable "infra_count" {
  type    = "string"
  default = "1"
}


variable "node_count" {
  type    = "string"
  default = "1"
}

