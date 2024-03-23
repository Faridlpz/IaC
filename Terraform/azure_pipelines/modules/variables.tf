variable "agent_pool_name" {
  description = "The name of the agent pool to use for build definition."
  type        = string
}

variable "project_id" {
  description = "The ID of the Azure DevOps project."
  type        = string
}

variable "repo_type" {
  description = "The repository type (e.g., 'Bitbucket')."
  type        = string
}


variable "service_connection_id" {
  description = "The ID of the service connection to use with the build definition."
  type        = string
}

variable "yml_path" {
  description = "The path to the yaml definition (azure-pipelines.yml) in the repository."
  type        = string
}

variable "ci_trigger_include_branches" {
  description = "List of branch ref patterns to include in CI trigger."
  type        = list(string)
  default     = ["refs/heads/feature/*", "refs/heads/master"]
}

variable "ci_trigger_exclude_branches" {
  description = "List of branch ref patterns to exclude from CI trigger."
  type        = list(string)
  default     = []
}

variable "pull_request_trigger_use_yaml" {
  description = "A boolean flag to indicate whether to use YAML configuration for pull request triggers."
  type        = bool
  default     = true
}


variable "pull_request_trigger_forks_enabled" {
  description = "A boolean flag to indicate whether pull request triggers are enabled for forks."
  type        = bool
  default     = false
}

variable "pull_request_trigger_forks_share_secrets" {
  description = "A boolean flag to indicate whether secrets are shared with pull request triggers on forks."
  type        = bool
  default     = false
}

variable "name" {
  description = "The name of the build definition."
  type        = string
}

variable "path" {
  description = "Path to the build definition."
  type        = string
}

variable "repo_id" {
  description = "The ID of the repository."
  type        = string
}

variable "branch_name" {
  description = "The name of the branch."
  type        = string
}