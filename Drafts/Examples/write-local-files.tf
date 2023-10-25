resource "null_resource" "write_json" {
  provisioner "local-exec" {
    command = "echo '${jsonencode(local.dictdata)}' > ${path.module}/keys/dashboard_dict.json"
  }
  
  triggers = {
    json_content = jsonencode(local.dictdata)
  }
}

resource "local_file" "json_file" {
  filename = "${path.module}/keys/dashboard_dict.json"
  content  = jsonencode(local.dictdata)
}