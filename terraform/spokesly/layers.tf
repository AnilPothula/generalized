resource "aws_opsworks_custom_layer" "master" {
  name                        = "master"
  short_name                  = "master"
  stack_id                    = module.opsworks_stack.id
  auto_assign_elastic_ips     = false
  auto_assign_public_ips      = false
  custom_instance_profile_arn = module.opsworks_stack.instance_profile_arn
  custom_security_group_ids   = list(aws_security_group.main.id)
  auto_healing                = true
  install_updates_on_boot     = false
  use_ebs_optimized_instances = true
  elastic_load_balancer       = aws_elb.elb.id

  custom_setup_recipes        = [ "elasticsearch::setup" ]
  custom_configure_recipes    = [ "elasticsearch::configure" ]
  custom_deploy_recipes       = [ "elasticsearch::deploy" ]
  custom_undeploy_recipes     = [ "elasticsearch::undeploy" ]
  custom_shutdown_recipes     = [ "elasticsearch::shutdown" ]
}

resource "aws_opsworks_custom_layer" "data" {
  name                        = "data"
  short_name                  = "data"
  stack_id                    = module.opsworks_stack.id
  auto_assign_elastic_ips     = false
  auto_assign_public_ips      = false
  custom_instance_profile_arn = module.opsworks_stack.instance_profile_arn
  custom_security_group_ids   = list(aws_security_group.main.id)
  auto_healing                = true
  install_updates_on_boot     = false
  use_ebs_optimized_instances = true

  custom_setup_recipes        = [ "elasticsearch::setup" ]
  custom_configure_recipes    = [ "elasticsearch::configure" ]
  custom_deploy_recipes       = [ "elasticsearch::deploy" ]
  custom_undeploy_recipes     = [ "elasticsearch::undeploy" ]
  custom_shutdown_recipes     = [ "elasticsearch::shutdown" ]

  ebs_volume {
    mount_point     = "/var/lib/elasticsearch"
    size            = 50
    number_of_disks = 1
    type            = "gp2"
    iops            = null
    encrypted       = false
  }
}
