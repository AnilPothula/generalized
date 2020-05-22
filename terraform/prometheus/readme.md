# AWS Node Exporter & CA-advisor Terraform module

Terraform module which creates 2 demon services, Node Exporter & CA-advisor.



## Usage

```hcl
module "node_exporter" {
    source = "./prometheus_node_exporter"

  ecs_cluster_name   = "CLUSTER_XYZ"
  ecs_security_group = "sg-XXXXXXXXXXXXXXXXXX"
  tags = {
      Name="Parveen"
      email="parveen@nclouds.com"
      Team =  "Layer2"
      identifier = "Prometheus"
    }
}

module "cadvisor_exporter" {
  source = "./prometheus_cadvisor_exporter"

  ecs_cluster_name   = "CLUSTER_XYZ"
  ecs_security_group = "sg-XXXXXXXXXXXXXXXXXX"
}

```
