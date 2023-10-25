locals {
  
#  dynatrace_mz = coalesce("${var.dynatrace_management_zone}", "${var.meta_dynatrace_management_zone}")
# 
#  dynatrace_repo = coalesce("${var.customer_repository}", "${var.meta_customer_repository}")
#
#  snow_f_group = coalesce("${var.snow_f_group}", "${var.meta_snow_f_group}")
#  
#  email_recipients = coalesce("${var.email_recipients}", "${var.meta_email_recipients}")

  dynatrace_mz = var.dynatrace_management_zone
  
  dynatrace_repo = var.customer_repository

  snow_f_group = var.snow_f_group
  
  email_recipients = var.email_recipients
  
  dynatrace_metrics = var.dynatrace_vars.metric_groups

  notification_email = var.dynatrace_vars.notification_email

  notification_snow = var.dynatrace_vars.notification_snow
  
  notification_zis = var.dynatrace_vars.notification_zis

  auto_config = var.auto_config

#  dynatrace_metrics = lookup(var.dynatrace_vars, "metric_groups", [])

#  notification_email = lookup(var.dynatrace_vars, "notification_email", "true")

#  notification_snow = lookup(var.dynatrace_vars, "notification_snow", "false")
  
#  notification_zis = lookup(var.dynatrace_vars, "notification_zis", "true")

  dictdata = {
    DASHBOARD_NAME = "${var.dashboard_name}"
    CUSTOMER_REPOSITORY = "${local.dynatrace_repo}"
    MANAGEMENT_ZONE = "${local.dynatrace_mz}"
    ALERTING_PROFILE = "${var.dashboard_name}"
    SNOW_F_GROUP = "${local.snow_f_group}"
    EMAIL_RECIPIENTS = "${local.email_recipients}"
    NOTIFICATION_EMAIL = "${local.notification_email}"
    NOTIFICATION_SNOW = "${local.notification_snow}"
    NOTIFICATION_ZIS = "${local.notification_zis}"
    PARAM1_NAME = coalesce("${local.dynatrace_metrics[0].name}", "CPU Usage")
    PARAM1_GRAPH = coalesce("${local.dynatrace_metrics[0].graph}", "builtin:cloud.aws.rds.cpu.usage")
    PARAM1_AGGREGATION = coalesce("${local.dynatrace_metrics[0].aggregation}", "AVG")
    PARAM1_CONDITION = coalesce("${local.dynatrace_metrics[0].condition}", "ABOVE")
    PARAM1_THRESHOLD_ORANGE = coalesce("${local.dynatrace_metrics[0].warning_threshold}", "95")
    PARAM1_THRESHOLD_RED = coalesce("${local.dynatrace_metrics[0].error_threshold}", "99")
    PARAM2_NAME = coalesce("${local.dynatrace_metrics[1].name}", "Read IOPS")
    PARAM2_GRAPH = coalesce("${local.dynatrace_metrics[1].graph}", "builtin:cloud.aws.rds.ops.read")
    PARAM2_AGGREGATION = coalesce("${local.dynatrace_metrics[1].aggregation}", "AVG")
    PARAM2_CONDITION = coalesce("${local.dynatrace_metrics[1].condition}", "ABOVE")
    PARAM2_THRESHOLD_ORANGE = coalesce("${local.dynatrace_metrics[1].warning_threshold}", "10000")
    PARAM2_THRESHOLD_RED = coalesce("${local.dynatrace_metrics[1].error_threshold}", "20000")
    PARAM3_NAME = coalesce("${local.dynatrace_metrics[2].name}", "Write IOPS")
    PARAM3_GRAPH = coalesce("${local.dynatrace_metrics[2].graph}", "builtin:cloud.aws.rds.ops.write")
    PARAM3_AGGREGATION = coalesce("${local.dynatrace_metrics[2].aggregation}", "AVG")
    PARAM3_CONDITION = coalesce("${local.dynatrace_metrics[2].condition}", "ABOVE")
    PARAM3_THRESHOLD_ORANGE = coalesce("${local.dynatrace_metrics[2].warning_threshold}", "10000")
    PARAM3_THRESHOLD_RED = coalesce("${local.dynatrace_metrics[2].error_threshold}", "20000")
    PARAM4_NAME = coalesce("${local.dynatrace_metrics[3].name}", "SWAP Usage")
    PARAM4_GRAPH = coalesce("${local.dynatrace_metrics[3].graph}", "builtin:cloud.aws.rds.memory.swap")
    PARAM4_AGGREGATION = coalesce("${local.dynatrace_metrics[3].aggregation}", "AVG")
    PARAM4_CONDITION = coalesce("${local.dynatrace_metrics[3].condition}", "ABOVE")
    PARAM4_THRESHOLD_ORANGE = coalesce("${local.dynatrace_metrics[3].warning_threshold}", "3.5")
    PARAM4_THRESHOLD_RED = coalesce("${local.dynatrace_metrics[3].error_threshold}", "4")
    PARAM5_NAME = coalesce("${local.dynatrace_metrics[4].name}", "Free Memory")
    PARAM5_GRAPH = coalesce("${local.dynatrace_metrics[4].graph}", "builtin:cloud.aws.rds.memory.freeable")
    PARAM5_AGGREGATION = coalesce("${local.dynatrace_metrics[4].aggregation}", "AVG")
    PARAM5_CONDITION = coalesce("${local.dynatrace_metrics[4].condition}", "BELOW")
    PARAM5_THRESHOLD_ORANGE = coalesce("${local.dynatrace_metrics[4].warning_threshold}", "100")
    PARAM5_THRESHOLD_RED = coalesce("${local.dynatrace_metrics[4].error_threshold}", "50")
    DB_TAGS = "${var.db_tags}"
  }
}


data "template_file" "alerting_profile" {
  template = file("${path.module}/alert_templates/DefaultProfile.json.tmpl")
  vars = jsondecode(jsonencode(local.dictdata))
}

data "template_file" "template_startstop" {
  template = file("${path.module}/alert_templates/alert_template_startstop.json.tmpl")
  vars = jsondecode(jsonencode(local.dictdata))
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

data "template_file" "template_dashboard_def" {
  template = file("${path.module}/dashboard_templates/dashboard_def.json.tmpl")
  vars = jsondecode(jsonencode(local.dictdata))
}

resource "github_repository_file" "file_alerting_profile" {
  count = local.auto_config ? 1 : 0
  repository = local.dynatrace_repo
  file       = "settings/alerting_profiles/${local.dynatrace_mz}4${var.dashboard_name}_profile.json"
  content    = data.template_file.alerting_profile.rendered
  overwrite_on_create = true
}

resource "github_repository_file" "file_startstop" {
  count = local.auto_config ? 1 : 0
  repository = local.dynatrace_repo
  file       = "settings/metric_events/${local.dynatrace_mz}4${var.dashboard_name}_restart_event.json"
  content    = data.template_file.template_startstop.rendered
  overwrite_on_create = true
}

resource "github_repository_file" "file_param1" {
  count = local.auto_config ? 1 : 0
  repository = local.dynatrace_repo
  file       = "settings/metric_events/${local.dynatrace_mz}4${var.dashboard_name}_alert_param1.json"
  content    = data.template_file.template_param1.rendered
  overwrite_on_create = true
}

resource "github_repository_file" "file_param2" {
  count = local.auto_config ? 1 : 0
  repository = local.dynatrace_repo
  file       = "settings/metric_events/${local.dynatrace_mz}4${var.dashboard_name}_alert_param2.json"
  content    = data.template_file.template_param2.rendered
  overwrite_on_create = true
}

resource "github_repository_file" "file_param3" {
  count = local.auto_config ? 1 : 0
  repository = local.dynatrace_repo
  file       = "settings/metric_events/${local.dynatrace_mz}4${var.dashboard_name}_alert_param3.json"
  content    = data.template_file.template_param3.rendered
  overwrite_on_create = true
}

resource "github_repository_file" "file_param4" {
  count = local.auto_config ? 1 : 0
  repository = local.dynatrace_repo
  file       = "settings/metric_events/${local.dynatrace_mz}4${var.dashboard_name}_alert_param4.json"
  content    = data.template_file.template_param4.rendered
  overwrite_on_create = true
}

resource "github_repository_file" "file_param5" {
  count = local.auto_config ? 1 : 0
  repository = local.dynatrace_repo
  file       = "settings/metric_events/${local.dynatrace_mz}4${var.dashboard_name}_alert_param5.json"
  content    = data.template_file.template_param5.rendered
  overwrite_on_create = true
}

resource "github_repository_file" "email_notification" {
  count = local.notification_email && local.auto_config ? 1 : 0
  repository = local.dynatrace_repo
  file       = "settings/notifications/${local.dynatrace_mz}4${var.dashboard_name}_notification_email.json"
  content    = data.template_file.template_email_notification.rendered
  overwrite_on_create = true
}

resource "github_repository_file" "zis_notification" {
  count = local.notification_zis && local.auto_config  ? 1 : 0
  repository = local.dynatrace_repo
  file       = "settings/notifications/${local.dynatrace_mz}4${var.dashboard_name}_notification_zis.json"
  content    = data.template_file.template_zis_notification.rendered
  overwrite_on_create = true
}

resource "github_repository_file" "snow_notification" {
  count = local.notification_snow && local.auto_config  ? 1 : 0
  repository = local.dynatrace_repo
  file       = "settings/notifications/${local.dynatrace_mz}4${var.dashboard_name}_notification_snow.json"
  content    = data.template_file.template_snow_notification.rendered
  overwrite_on_create = true
}

resource "github_repository_file" "dashboard_def" {
  count = local.auto_config ? 1 : 0
  repository = local.dynatrace_repo
  file       = "dashboards/dashboard_${local.dynatrace_mz}4${var.dashboard_name}_def.json"
  content    = data.template_file.template_dashboard_def.rendered
  overwrite_on_create = true
}

resource "local_file" "create_file_alerting_profile" {
  filename = "${path.module}/monitoring_settings/${local.dynatrace_mz}4${var.dashboard_name}_profile.json"
  content  = data.template_file.alerting_profile.rendered
}

resource "local_file" "create_file_startstop" {
  filename = "${path.module}/monitoring_settings/${local.dynatrace_mz}4${var.dashboard_name}_restart_event.json"
  content  = data.template_file.template_startstop.rendered
}

resource "local_file" "create_file_param1" {
  filename = "${path.module}/monitoring_settings/${local.dynatrace_mz}4${var.dashboard_name}_alert_param1.json"
  content  = data.template_file.template_param1.rendered
}

resource "local_file" "create_file_param2" {
  filename = "${path.module}/monitoring_settings/${local.dynatrace_mz}4${var.dashboard_name}_alert_param2.json"
  content  = data.template_file.template_param2.rendered
}

resource "local_file" "create_file_param3" {
  filename = "${path.module}/monitoring_settings/${local.dynatrace_mz}4${var.dashboard_name}_alert_param3.json"
  content  = data.template_file.template_param3.rendered
}

resource "local_file" "create_file_param4" {
  filename = "${path.module}/monitoring_settings/${local.dynatrace_mz}4${var.dashboard_name}_alert_param4.json"
  content  = data.template_file.template_param4.rendered
}

resource "local_file" "create_file_param5" {
  filename = "${path.module}/monitoring_settings/${local.dynatrace_mz}4${var.dashboard_name}_alert_param5.json"
  content  = data.template_file.template_param5.rendered
}

resource "local_file" "create_file_email" {
  filename = "${path.module}/monitoring_settings/${local.dynatrace_mz}4${var.dashboard_name}_notification_email.json"
  content  = data.template_file.template_email_notification.rendered
}

resource "local_file" "create_file_zis" {
  filename = "${path.module}/monitoring_settings/${local.dynatrace_mz}4${var.dashboard_name}_notification_zis.json"
  content  = data.template_file.template_zis_notification.rendered
}

resource "local_file" "create_file_snow" {
  filename = "${path.module}/monitoring_settings/${local.dynatrace_mz}4${var.dashboard_name}_notification_snow.json"
  content  = data.template_file.template_snow_notification.rendered
}

resource "local_file" "create_file_dashboard" {
  filename = "${path.module}/monitoring_settings/dashboard_${local.dynatrace_mz}4${var.dashboard_name}_def.json"
  content  = data.template_file.template_dashboard_def.rendered
}

#data "archive_file" "monitoring_settings_zip" {
#  type        = "zip"
#  output_path = "${path.module}/dynatrace_settings.zip"
#  source_dir  = "${path.module}/monitoring_settings"
##  depends_on  = [local_file.create_file_alerting_profile, local_file.create_file_startstop]
#}

data "archive_file" "monitoring_settings_zip" {
  type        = "zip"
  output_path = "${path.module}/dynatrace_settings.zip"
  source {
    content  = data.template_file.alerting_profile.rendered
    filename = "${path.module}/globalmonitoring/${local.dynatrace_mz}/settings/alerting_profiles/${local.dynatrace_mz}4${var.dashboard_name}_profile.json"
  }
  source {
    content  = data.template_file.template_startstop.rendered
    filename = "${path.module}/globalmonitoring/${local.dynatrace_mz}/settings/metric_events/${local.dynatrace_mz}4${var.dashboard_name}_restart_event.json"
  }
  source {
    content  = data.template_file.template_param1.rendered
    filename = "${path.module}/globalmonitoring/${local.dynatrace_mz}/settings/metric_events/${local.dynatrace_mz}4${var.dashboard_name}_alert_param1.json"
  }
  source {
    content  = data.template_file.template_param2.rendered
    filename = "${path.module}/globalmonitoring/${local.dynatrace_mz}/settings/metric_events/${local.dynatrace_mz}4${var.dashboard_name}_alert_param2.json"
  }
  source {
    content  = data.template_file.template_param3.rendered
    filename = "${path.module}/globalmonitoring/${local.dynatrace_mz}/settings/metric_events/${local.dynatrace_mz}4${var.dashboard_name}_alert_param3.json"
  }
  source {
    content  = data.template_file.template_param4.rendered
    filename = "${path.module}/globalmonitoring/${local.dynatrace_mz}/settings/metric_events/${local.dynatrace_mz}4${var.dashboard_name}_alert_param4.json"
  }
  source {
    content  = data.template_file.template_param5.rendered
    filename = "${path.module}/globalmonitoring/${local.dynatrace_mz}/settings/metric_events/${local.dynatrace_mz}4${var.dashboard_name}_alert_param5.json"
  }
  source {
    content  = data.template_file.template_email_notification.rendered
    filename = "${path.module}/globalmonitoring/${local.dynatrace_mz}/settings/notifications/${local.dynatrace_mz}4${var.dashboard_name}_notification_email.json"
  }
  source {
    content  = data.template_file.template_zis_notification.rendered
    filename = "${path.module}/globalmonitoring/${local.dynatrace_mz}/settings/notifications/${local.dynatrace_mz}4${var.dashboard_name}_notification_zis.json"
  }
  source {
    content  = data.template_file.template_snow_notification.rendered
    filename = "${path.module}/globalmonitoring/${local.dynatrace_mz}/settings/notifications/${local.dynatrace_mz}4${var.dashboard_name}_notification_snow.json"
  }
  source {
    content  = data.template_file.template_dashboard_def.rendered
    filename = "${path.module}/globalmonitoring/${local.dynatrace_mz}/dashboards/dashboard_${local.dynatrace_mz}4${var.dashboard_name}_def.json"
  }
}

#resource "kubernetes_config_map" "dynatrace_settings_map" {
#  metadata {
#    name = "dynatrace-settings"
#    namespace = "customer" 
#  }
#
#  data = {
#    "dynatrace_settings.zip" = data.archive_file.monitoring_settings_zip.output_path
#  }
#}

resource "kubernetes_config_map" "dynatrace_settings_map" {
  metadata {
    name      = "dynatrace-settings"
    namespace = "customer"
  }

  binary_data = {
    "dynatrace_settings.zip" = filebase64(data.archive_file.monitoring_settings_zip.output_path)
  }
}
