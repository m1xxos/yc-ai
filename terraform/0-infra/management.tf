resource "selectel_vpc_project_v2" "ai-project" {
  name = "ai-project"
  lifecycle {
    prevent_destroy = true
  }
}

resource "random_password" "sa-pass" {
  length = 20
}

resource "selectel_iam_serviceuser_v1" "ai-sa" {
  name         = "ai-sa"
  password     = random_password.sa-pass.result
  role {
    role_name  = "member"
    scope      = "project"
    project_id = selectel_vpc_project_v2.ai-project.id
  }
}
