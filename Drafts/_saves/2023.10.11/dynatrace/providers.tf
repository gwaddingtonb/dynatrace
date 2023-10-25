terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

# data "kubernetes_secret" "dynatrace" {
#   metadata {
#     name      = "git-credentials"
#     namespace = "customer" 
#     sensitive = false
#   }
# }

# provider "github" {
#   base_url = "https://github.developer.allianz.io/"
# }

provider "github" {
  token = var.github_token
  owner = var.github_owner
  base_url = "https://github.developer.allianz.io/"
}

# provider "github" {
#   token = base64decode(data.kubernetes_secret.dynatrace.data[".git-credentials"])
#   owner = var.github_owner
#   base_url = "https://github.developer.allianz.io/"
    
# }