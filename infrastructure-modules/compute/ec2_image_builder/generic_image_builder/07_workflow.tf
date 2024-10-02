resource "aws_imagebuilder_workflow" "build" {
  name    = "build_${var.shortname}"
  version = "1.0.0"
  type    = "BUILD"

  lifecycle {
    ignore_changes = [data]
  }

  data = templatefile("${path.module}/workflows/workflow_build.tpl", {
  })

  tags = {
    Name = "build_${var.shortname}"
  }
}