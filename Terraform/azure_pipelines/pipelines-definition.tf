locals {
  build_definitions = yamldecode(file("vars_yamls/variables.yaml"))
  project = yamldecode(file("vars_yamls/project.yaml"))
}

output "build_definitions" {
  value = local.build_definitions.build_definitions
}

output "project" {
  value = local.project
}



module "definitions" {
  source = "./modules"
  for_each = local.build_definitions["build_definitions"]
  # Common settings (from project.yaml)
  agent_pool_name       = local.project.agent_pool_name
  project_id            = local.project.project_id
  repo_type             = local.project.repo_type
  service_connection_id = local.project.service_connection_id
  yml_path              = local.project.yml_path

  # Pipeline-specific settings (from variables.yaml)
  ci_trigger_exclude_branches = each.value.ci_trigger_exclude_branches
  pull_request_trigger_use_yaml            = each.value.pull_request_trigger_use_yaml
  pull_request_trigger_forks_enabled       = each.value.pull_request_trigger_forks_enabled
  pull_request_trigger_forks_share_secrets = each.value.pull_request_trigger_forks_share_secrets
  name                        = each.value.pipeline_name
  path                        = each.value.pipeline_folder
  repo_id                     = each.value.repo
  branch_name                 = each.value.branch_name
  ci_trigger_include_branches = each.value.ci_trigger
}