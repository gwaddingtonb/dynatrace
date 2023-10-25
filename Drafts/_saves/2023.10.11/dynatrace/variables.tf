variable "dashboard_name" {
  description = "Name of the Dashboard, should be unique in the MZ"
  type    = string
  default = ""
}

variable "github_owner" {
  description = "globalmonitoring GitHub User"
  type    = string
  default = "globalmonitoring"
}

variable "github_token" {
  description = "globalmonitoring GitHub User token"
  type    = string
  default = null
}

variable "customer_repository" {
  description = "Customer Repository Name (not URL!)"
  type    = string
  default = null
}

variable "dynatrace_management_zone" {
  description = "Management Zone Name"
  type    = string
  default = null
}

variable "snow_f_group" {
  description = "-Group in SNOW"
  type    = string
  default = null
}

variable "email_recipients" {
  description = "eMail recipients for alarm notification"
  type    = string
  default = null
}

variable "db_tags" {
  description = "db-tag to be monitored"
  type    = string
  default = ""
}

#variable "meta_snow_f_group" {
#  description = "F-Group in SNOW from metadata"
#  type    = string
#  default = "AZD.BIT-KVI5.CO-AZDCLOUD"
#}
#
#variable "meta_email_recipients" {
#  description = "Email Recipients from metadata"
#  type    = string
#  default = "extern.binder_david@allianz.de"
#}
#
#variable "meta_dynatrace_management_zone" {
#  description = "management zone from the metadata"
#  type    = string
#  default = ""
#}
#
#variable "meta_customer_repository" {
#  description = "dynatrace repo from the metadata"
#  type    = string
#  default = ""
#}

variable "dynatrace_vars" {
#  description = "Dynatrace metrics (max 5)"

  type = any

  default = {
    dynatrace_alerting_profile = "default.yml"
    notification_email = "true"
    notification_snow = "true"
    notification_zis = "false"
    metric_groups = [
      {
        name = "CPU Usage"
        graph = "builtin:cloud.aws.rds.cpu.usage"
        aggregation = "AVG"
        condition = "ABOVE"
        warning_threshold = "95"
        error_threshold = "99"
      },
      {
        name = "Read IOPS"
        graph = "builtin:cloud.aws.rds.ops.read"
        aggregation = "AVG"
        condition = "ABOVE"
        warning_threshold = "10000"
        error_threshold = "20000"
      },
      {
        name = "Write IOPS"
        graph = "builtin:cloud.aws.rds.ops.write"
        aggregation = "AVG"
        condition = "ABOVE"
        warning_threshold = "10000"
        error_threshold = "20000"
      },
      {
        name = "SWAP Usage"
        graph = "builtin:cloud.aws.rds.memory.swap"
        aggregation = "AVG"
        condition = "ABOVE"
        warning_threshold = "3.5"
        error_threshold = "4"
      },
      {
        name = "Free Memory"
        graph = "builtin:cloud.aws.rds.memory.freeable"
        aggregation = "AVG"
        condition = "BELOW"
        warning_threshold = "100" 
        error_threshold = "50"
      }
    ]
  }
}
