locals {
  
  dynatrace_mz = coalesce("${var.dynatrace_management_zone}", "${var.meta_dynatrace_management_zone}")
  
  dynatrace_repo = coalesce("${var.dynatrace_management_zone}", "${var.meta_dynatrace_management_zone}")

  dictdata = {
    CUSTOMER_REPOSITORY = var.customer_repository
#   STAGE = var.stage
    MANAGEMENT_ZONE = "${local.dynatrace_mz}"
    ALERTING_PROFILE = "${local.dynatrace_mz}4${var.db_tags[0]}_profile"
    SNOW_F_GROUP = var.snow_f_group
    EMAIL_RECEPIENTS = var.email_recepients
    NOTIFICATION_EMAIL = var.notification_email
    NOTIFICATION_SNOW = var.notification_snow
    NOTIFICATION_ZIS = var.notification_zis
    PARAM1_NAME = var.param1_name
    PARAM1_GRAPH = var.param1_graph
    PARAM1_AGGREGATION = var.param1_aggregation
    PARAM1_CONDITION = var.param1_condition
    PARAM1_THRESHOLD_ORANGE = var.param1_threshold_orange
    PARAM1_THRESHOLD_RED = var.param1_threshold_red
    PARAM2_NAME = var.param2_name
    PARAM2_GRAPH = var.param2_graph
    PARAM2_AGGREGATION = var.param2_aggregation
    PARAM2_CONDITION = var.param2_condition
    PARAM2_THRESHOLD_ORANGE = var.param2_threshold_orange
    PARAM2_THRESHOLD_RED = var.param2_threshold_red
    PARAM3_NAME = var.param3_name
    PARAM3_GRAPH = var.param3_graph
    PARAM3_AGGREGATION = var.param3_aggregation
    PARAM3_CONDITION = var.param3_condition
    PARAM3_THRESHOLD_ORANGE = var.param3_threshold_orange
    PARAM3_THRESHOLD_RED = var.param3_threshold_red
    PARAM4_NAME = var.param4_name
    PARAM4_GRAPH = var.param4_graph
    PARAM4_AGGREGATION = var.param4_aggregation
    PARAM4_CONDITION = var.param4_condition
    PARAM4_THRESHOLD_ORANGE = var.param4_threshold_orange
    PARAM4_THRESHOLD_RED = var.param4_threshold_red
    PARAM5_NAME = var.param5_name
    PARAM5_GRAPH = var.param5_graph
    PARAM5_AGGREGATION = var.param5_aggregation
    PARAM5_CONDITION = var.param5_condition
    PARAM5_THRESHOLD_ORANGE = var.param5_threshold_orange 
    PARAM5_THRESHOLD_RED = var.param5_threshold_red    
    DB_TAGS = var.db_tags[0]
  }
}

#resource "null_resource" "write_json" {
#  provisioner "local-exec" {
#    command = "echo '${jsonencode(local.dictdata)}' > ${path.module}/keys/dashboard_dict.json"
#  }
#  
#  triggers = {
#    json_content = jsonencode(local.dictdata)
#  }
#}

#resource "local_file" "json_file" {
#  filename = "${path.module}/keys/dashboard_dict.json"
#  content  = jsonencode(local.dictdata)
#}

data "template_file" "alerting_profile" {
  template = file("${path.module}/alert_templates/DefaultProfile.json.tmpl")
  vars = jsondecode(jsonencode(local.dictdata))
}

resource "github_repository_file" "file_alerting_profile" {
  repository = var.customer_repository
  file       = "settings/alerting_profiles/${var.dynatrace_management_zone}4${var.db_tags[0]}_profile.json"
  content    = data.template_file.alerting_profile.rendered
  overwrite_on_create = true
}

data "template_file" "template_startstop" {
  template = file("${path.module}/alert_templates/alert_template_startstop.json.tmpl")
  vars = jsondecode(jsonencode(local.dictdata))
}

resource "github_repository_file" "file_startstop" {
  repository = var.customer_repository
  file       = "settings/metric_events/${var.dynatrace_management_zone}4${var.db_tags[0]}_alert_startstop.json"
  content    = data.template_file.template_startstop.rendered
  overwrite_on_create = true
}

data "template_file" "template_param1" {
  template = file("${path.module}/alert_templates/alert_template_param1.json.tmpl")
  vars = jsondecode(jsonencode(local.dictdata))
}

data "template_file" "template_param2" {
  template = file("${path.module}/alert_templates/alert_template_param2.json.tmpl")
  vars = jsondecode(jsonencode(local.dictdata))
}

data "template_file" "template_param3" {
  template = file("${path.module}/alert_templates/alert_template_param3.json.tmpl")
  vars = jsondecode(jsonencode(local.dictdata))
}

data "template_file" "template_param4" {
  template = file("${path.module}/alert_templates/alert_template_param4.json.tmpl")
  vars = jsondecode(jsonencode(local.dictdata))
}

data "template_file" "template_param5" {
  template = file("${path.module}/alert_templates/alert_template_param5.json.tmpl")
  vars = jsondecode(jsonencode(local.dictdata))
}

resource "github_repository_file" "file_param1" {
  repository = var.customer_repository
  file       = "settings/metric_events/${var.dynatrace_management_zone}4${var.db_tags[0]}_alert_param1.json"
  content    = data.template_file.template_param1.rendered
  overwrite_on_create = true
}

resource "github_repository_file" "file_param2" {
  repository = var.customer_repository
  file       = "settings/metric_events/${var.dynatrace_management_zone}4${var.db_tags[0]}_alert_param2.json"
  content    = data.template_file.template_param2.rendered
  overwrite_on_create = true
}

resource "github_repository_file" "file_param3" {
  repository = var.customer_repository
  file       = "settings/metric_events/${var.dynatrace_management_zone}4${var.db_tags[0]}_alert_param3.json"
  content    = data.template_file.template_param3.rendered
  overwrite_on_create = true
}

resource "github_repository_file" "file_param4" {
  repository = var.customer_repository
  file       = "settings/metric_events/${var.dynatrace_management_zone}4${var.db_tags[0]}_alert_param4.json"
  content    = data.template_file.template_param4.rendered
  overwrite_on_create = true
}

resource "github_repository_file" "file_param5" {
  repository = var.customer_repository
  file       = "settings/metric_events/${var.dynatrace_management_zone}4${var.db_tags[0]}_alert_param5.json"
  content    = data.template_file.template_param5.rendered
  overwrite_on_create = true
}

data "template_file" "template_email_notification" {
  template = file("${path.module}/alert_templates/notification_template_email.json.tmpl")
  vars = jsondecode(jsonencode(local.dictdata))
}

data "template_file" "template_zis_notification" {
  template = file("${path.module}/alert_templates/notification_template_zis.json.tmpl")
  vars = jsondecode(jsonencode(local.dictdata))
}

data "template_file" "template_snow_notification" {
  template = file("${path.module}/alert_templates/notification_template_snow.json.tmpl")
  vars = jsondecode(jsonencode(local.dictdata))
}

resource "github_repository_file" "email_notification" {
  count = var.notification_email ? 1 : 0
  repository = var.customer_repository
  file       = "settings/notifications/${var.dynatrace_management_zone}4${var.db_tags[0]}_notification_email.json"
  content    = data.template_file.template_email_notification.rendered
  overwrite_on_create = true
}

resource "github_repository_file" "zis_notification" {
  count = var.notification_zis ? 1 : 0
  repository = var.customer_repository
  file       = "settings/notifications/${var.dynatrace_management_zone}4${var.db_tags[0]}_notification_zis.json"
  content    = data.template_file.template_zis_notification.rendered
  overwrite_on_create = true
}

resource "github_repository_file" "snow_notification" {
  count = var.notification_snow ? 1 : 0
  repository = var.customer_repository
  file       = "settings/notifications/${var.dynatrace_management_zone}4${var.db_tags[0]}_notification_snow.json"
  content    = data.template_file.template_snow_notification.rendered
  overwrite_on_create = true
}

data "template_file" "template_dashboard_def" {
  template = file("${path.module}/dashboard_templates/dashboard_def.json.tmpl")
  vars = jsondecode(jsonencode(local.dictdata))
}

resource "github_repository_file" "dashboard_def" {
  repository = var.customer_repository
  file       = "dashboards/dashboard_${var.dynatrace_management_zone}4${var.db_tags[0]}_def.json"
  content    = data.template_file.template_dashboard_def.rendered
  overwrite_on_create = true
}