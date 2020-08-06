locals {
  default_tags = {
    Environment = terraform.workspace
    Name        = "${var.identifier}-${terraform.workspace}"
  }
  tags = merge(local.default_tags, var.tags)
}


resource "aws_ecr_repository" "ecr" {
  image_tag_mutability = var.image_tag_mutability
  name                 = var.identifier
  tags                 = local.tags

  image_scanning_configuration {
    scan_on_push       = var.scan_on_push
  }
}
