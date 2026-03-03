//
// Create a new Compute Disk and put it to the specific Placement Group.
//
resource "yandex_compute_disk" "my_vm" {
  name = "non-replicated-disk-name"
  size = 93 // Non-replicated SSD disk size must be divisible by 93G
  type = "network-ssd-nonreplicated"
  zone = "ru-central1-b"
}

resource "yandex_compute_instance" "default" {
  name        = "test"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    disk_id = yandex_compute_disk.my_vm.id
  }

  network_interface {
    index     = 1
    subnet_id = yandex_vpc_subnet.foo.id
  }

}

// Auxiliary resources for Compute Instance
resource "yandex_vpc_network" "foo" {}

resource "yandex_vpc_subnet" "foo" {
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.foo.id
  v4_cidr_blocks = ["10.5.0.0/24"]
}
