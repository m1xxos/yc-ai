resource "yandex_vpc_network" "ai-network" {
  name   = "ai-network"
  labels = var.default_variable
}