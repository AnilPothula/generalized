resource "aws_opsworks_instance" "master" {
  count     = var.master_instance["count"]
  stack_id  = module.opsworks_stack.id
  layer_ids = [ aws_opsworks_custom_layer.master.id ]

  hostname      = "elasticsearch-master-${count.index + 1}"
  subnet_id     = element(module.vpc.private_subnets, count.index)
  instance_type = var.master_instance["type"]
  os            = "Ubuntu 18.04 LTS"
  state         = "running"

  root_device_type = "ebs"
  root_block_device {
    volume_type           = "gp2"
    volume_size           = 50
    iops                  = null
    delete_on_termination = true
  }

timeouts {
    create = "30m"
    delete = "30m"
  }
}

resource "aws_opsworks_instance" "data" {
  count     = var.data_instance["count"]
  stack_id  = module.opsworks_stack.id
  layer_ids = [ aws_opsworks_custom_layer.data.id ]

  hostname      = "elasticsearch-data-${count.index + 1}"
  subnet_id     = element(module.vpc.private_subnets, count.index)
  instance_type = var.data_instance["type"]
  os            = "Ubuntu 18.04 LTS"
  state         = "running"

  root_device_type = "ebs"
  root_block_device {
    volume_type           = "gp2"
    volume_size           = 50
    iops                  = null
    delete_on_termination = true
  }


  depends_on = [ aws_opsworks_instance.master ]

  timeouts {
    create = "30m"
    delete = "30m"
  }
}
