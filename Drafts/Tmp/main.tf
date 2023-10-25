locals {
  dictdata = {
    AWS_ACCOUNT = var.aws_account
    STAGE = var.stage
    OWNER_EMAIL = var.owner_email
    DASHBOARD_NAME = var.dashboard_name
    CUSTOMER_REPOSITORY = var.customer_repository
    OUTPUT_JSON = var.output_json
    DB_CLUSTER_NAME = var.db_cluster_name
    DB_CLUSTER_INSTANCE_NAME0 = var.db_instance_names[0]
    DB_CLUSTER_INSTANCE_NAME1 = var.db_instance_names[1]
    DB_CLUSTER_INSTANCE_NAME2 = var.db_instance_names[2]
#    DB_CLUSTER_INSTANCE_NAME3 = var.db_instance_names[3]
#    DB_CLUSTER_INSTANCE_NAME4 = var.db_instance_names[4]
#    DB_CLUSTER_INSTANCE_NAME5 = var.db_instance_names[5]
#    DB_CLUSTER_INSTANCE_NAME6 = var.db_instance_names[6]
#    DB_CLUSTER_INSTANCE_NAME7 = var.db_instance_names[7]
#    DB_CLUSTER_INSTANCE_NAME8 = var.db_instance_names[8]
#    DB_CLUSTER_INSTANCE_NAME9 = var.db_instance_names[9]
    EMAIL_RECEPIENTS = var.email_recepients
  }
}

resource "null_resource" "write_json" {
  provisioner "local-exec" {
    command = "echo '${jsonencode(local.dictdata)}' > ${path.module}/keys/dashboard_dict.json"
  }
  
  triggers = {
    json_content = jsonencode(local.dictdata)
  }
}

#resource "local_file" "json_file" {
#  filename = "${path.module}/keys/dashboard_dict.json"
#  content  = jsonencode(local.dictdata)
#}


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
  repository = var.customer_repository
  file       = "settings/metric_events/alert_cpu.json"
  content    = data.template_file.template_cpu.rendered
  overwrite_on_create = true
}

resource "github_repository_file" "file_memory" {
  repository = var.customer_repository
  file       = "settings/metric_events/alert_memory.json"
  content    = data.template_file.template_memory.rendered
  overwrite_on_create = true
}

resource "github_repository_file" "file_readiops" {
  repository = var.customer_repository
  file       = "settings/metric_events/alert_readiops.json"
  content    = data.template_file.template_readiops.rendered
  overwrite_on_create = true
}

resource "github_repository_file" "file_writeiops" {
  repository = var.customer_repository
  file       = "settings/metric_events/alert_writeiops.json"
  content    = data.template_file.template_writeiops.rendered
  overwrite_on_create = true
}

resource "github_repository_file" "file_swap" {
  repository = var.customer_repository
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
  repository = var.customer_repository
  file       = "settings/notifications/notification_email.json"
  content    = data.template_file.template_email_notification.rendered
  overwrite_on_create = true
}

resource "github_repository_file" "zis_notification" {
  repository = var.customer_repository
  file       = "settings/notifications/notification_zis.json"
  content    = data.template_file.template_zis_notification.rendered
  overwrite_on_create = true
}

data "template_file" "template_dashboard_def" {
  template = file("${path.module}/dashboard_templates/dashboard_def.json.tmpl")
  vars = jsondecode(file("${path.module}/keys/dashboard_dict.json"))
}

resource "github_repository_file" "dashboard_def" {
  repository = var.customer_repository
  file       = "dashboards/dashboard_def.json"
  content    = data.template_file.template_dashboard_def.rendered
  overwrite_on_create = true
}