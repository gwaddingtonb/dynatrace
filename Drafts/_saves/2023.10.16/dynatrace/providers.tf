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

#provider "github" {
#  token = var.github_token
#  owner = var.github_owner
#  base_url = "https://github.developer.allianz.io/"
#}

provider "github" {
  app_auth {
    id              = var.app_id              # or `GITHUB_APP_ID`
    installation_id = var.app_installation_id # or `GITHUB_APP_INSTALLATION_ID`
    pem_file        = var.app_pem_file        # or `GITHUB_APP_PEM_FILE`
  }
}

# provider "github" {
#   token = base64decode(data.kubernetes_secret.dynatrace.data[".git-credentials"])
#   owner = var.github_owner
#   base_url = "https://github.developer.allianz.io/"
    
# }