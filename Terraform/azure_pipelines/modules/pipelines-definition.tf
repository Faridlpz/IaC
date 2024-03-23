resource "azuredevops_build_definition" "azure_pipeline" {
 agent_pool_name = var.agent_pool_name
 name            = var.name
 path            = var.path
 project_id      = var.project_id

    ci_trigger {
        
        override {
            batch = false
            branch_filter {
            exclude = var.ci_trigger_exclude_branches
            include = var.ci_trigger_include_branches

            }
        }
    }

        lifecycle {
        ignore_changes = [
          ci_trigger[0].override[0].path_filter,
        ]
      }


    pull_request_trigger {
        use_yaml       = var.pull_request_trigger_use_yaml
        forks {
            enabled       = var.pull_request_trigger_forks_enabled
            share_secrets = var.pull_request_trigger_forks_share_secrets
        }
    }

    repository {
        repo_id               = var.repo_id
        repo_type             = var.repo_type
        service_connection_id = var.service_connection_id
        branch_name           = var.branch_name
        yml_path              = var.yml_path
    }
}
