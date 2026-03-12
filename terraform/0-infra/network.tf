resource "openstack_networking_network_v2" "ai_network" {
  name           = "ai-private-network"
  admin_state_up = "true"
  region         = var.region
}

resource "openstack_networking_subnet_v2" "ai_subnet" {
  name            = "ai-private-subnet"
  network_id      = openstack_networking_network_v2.ai_network.id
  cidr            = "192.168.199.0/24"
  dns_nameservers = ["188.93.16.19", "188.93.17.19"]
  enable_dhcp     = false
  region          = var.region
}

data "openstack_networking_network_v2" "ai_external_network" {
  external = true
  region   = var.region
}

resource "openstack_networking_router_v2" "ai_router" {
  name                = "ai-router"
  external_network_id = data.openstack_networking_network_v2.ai_external_network.id
  region              = var.region
}

resource "openstack_networking_router_interface_v2" "ai_router_interface" {
  router_id = openstack_networking_router_v2.ai_router.id
  subnet_id = openstack_networking_subnet_v2.ai_subnet.id
  region    = var.region
}
