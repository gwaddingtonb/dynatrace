variable "github_owner" {}
variable "github_token" {}

terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "github" {
  token = var.github_token
  owner = var.github_owner
  # base_url = "https://github.com/"
}

data "template_file" "template_cpu" {
  template = file("${path.module}/alert_templates/alert_template_cpu.json.tmpl")
  vars = jsondecode(file("${path.module}/keys/dashboard_dict.json"))
}

data "template_file" "template_memory" {
  template = file("${path.module}/alert_templates/alert_template_memory.json.tmpl")
  vars = jsondecode(file("${path.module}/keys/dashboard_dict.json"))
}

data "template_file" "template_readiops" {
  template = file("${path.module}/alert_templates/alert_template_readiops.json.tmpl")
  vars = jsondecode(file("${path.module}/keys/dashboard_dict.json"))
}

data "template_file" "template_writeiops" {
  template = file("${path.module}/alert_templates/alert_template_writeiops.json.tmpl")
  vars = jsondecode(file("${path.module}/keys/dashboard_dict.json"))
}

data "template_file" "template_swap" {
  template = file("${path.module}/alert_templates/alert_template_writeiops.json.tmpl")
  vars = jsondecode(file("${path.module}/keys/dashboard_dict.json"))
}

resource "github_repository_file" "file_cpu" {
  repository = "dynatrace-config"
  file       = "settings/metric_events/alert_cpu.json"
  content    = data.template_file.template_cpu.rendered
  overwrite_on_create = true
}

resource "github_repository_file" "file_memory" {
  repository = "dynatrace-config"
  file       = "settings/metric_events/alert_memory.json"
  content    = data.template_file.template_memory.rendered
  overwrite_on_create = true
}

resource "github_repository_file" "file_readiops" {
  repository = "dynatrace-config"
  file       = "settings/metric_events/alert_readiops.json"
  content    = data.template_file.template_readiops.rendered
  overwrite_on_create = true
}

resource "github_repository_file" "file_writeiops" {
  repository = "dynatrace-config"
  file       = "settings/metric_events/alert_writeiops.json"
  content    = data.template_file.template_writeiops.rendered
  overwrite_on_create = true
}

resource "github_repository_file" "file_swap" {
  repository = "dynatrace-config"
  file       = "settings/metric_events/alert_swap.json"
  content    = data.template_file.template_swap.rendered
  overwrite_on_create = true
}

data "template_file" "template_email_notification" {
  template = file("${path.module}/alert_templates/notification_template_email.json.tmpl")
  vars = jsondecode(file("${path.module}/keys/dashboard_dict.json"))
}

data "template_file" "template_zis_notification" {
  template = file("${path.module}/alert_templates/notification_template_zis.json.tmpl")
  vars = jsondecode(file("${path.module}/keys/dashboard_dict.json"))
}

resource "github_repository_file" "email_notification" {
  repository = "dynatrace-config"
  file       = "settings/notifications/notification_email.json"
  content    = data.template_file.template_email_notification.rendered
  overwrite_on_create = true
}

resource "github_repository_file" "zis_notification" {
  repository = "dynatrace-config"
  file       = "settings/notifications/notification_zis.json"
  content    = data.template_file.template_zis_notification.rendered
  overwrite_on_create = true
}

data "template_file" "template_dashboard_def" {
  template = file("${path.module}/dashboard_templates/dashboard_def.json.tmpl")
  vars = jsondecode(file("${path.module}/keys/dashboard_dict.json"))
}

resource "github_repository_file" "dashboard_def" {
  repository = "dynatrace-config"
  file       = "dashboards/dashboard_def.json"
  content    = data.template_file.template_dashboard_def.rendered
  overwrite_on_create = true
}