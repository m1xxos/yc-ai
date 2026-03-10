include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "infra" {
  config_path = "../0-infra"

  mock_outputs = {
    kubeconfig = "mock-kubeconfig"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init", "destroy"]
}

inputs = {
  kubeconfig = dependency.infra.outputs.kubeconfig
}
