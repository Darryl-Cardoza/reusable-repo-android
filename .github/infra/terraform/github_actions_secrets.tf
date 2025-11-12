###############################################################
# 🧩 Terraform: GitHub Actions Secrets Setup
# This is an example for provisioning repository secrets.
# Requires: terraform-provider-github
###############################################################

terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "github" {
  token = var.github_token
  owner = var.github_owner
}

variable "github_token" {
  description = "GitHub personal access token with repo and admin:repo_hook scopes"
  type        = string
  sensitive   = true
}

variable "github_owner" {
  description = "GitHub organization or user that owns the repository"
  type        = string
}

variable "repo_name" {
  description = "Repository name to which secrets are applied"
  type        = string
}

variable "secrets" {
  description = "Map of secret names to values"
  type        = map(string)
  default     = {}
}

# -------------------------------------------------------------
# Create secrets dynamically
# -------------------------------------------------------------
resource "github_actions_secret" "repo_secrets" {
  for_each   = var.secrets
  repository = var.repo_name
  secret_name = each.key
  plaintext_value = each.value
}

# Example usage:
# terraform apply -var 'github_token=ghp_xxx' -var 'github_owner=Rite-Technologies-23' \
#   -var 'repo_name=reusable-repo-android' \
#   -var 'secrets={ SONAR_TOKEN="xxx", CODACY_PROJECT_TOKEN="yyy" }'
