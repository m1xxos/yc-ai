resource "openstack_blockstorage_volume_v2" "ai_data_volume" {
  name        = "ai-data-volume"
  description = "Persistent volume for AI models and data"
  size        = 100
  volume_type = "fast.ru-9a"
  metadata = {
    "managed-by" = "terraform"
  }
}