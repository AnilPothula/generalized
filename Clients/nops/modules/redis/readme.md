# AWS REDIS Terraform module

Terraform module which creates REDIS resources on AWS.

## Usage


```hcl
module "redis" {
    source  = "./modules/redis"
    cluster_id                  ="parveendev"
    node_type                   ="cache.t2.micro"
    engine                      ="redis"
    identifier                  = "dev-redis"
    num_cache_nodes             = 1
    subnet_group_description    = "Subnet Group Description"
    subnets                     = ["subnet-XXXXXXXXXXXX", "subnet-XXXXXXXXXXXX"]
    tags = {
      dev="Parveen"
      email="parveen@nclouds.com"
      Name = "Dev-redis",
      Team =  "Layer2"
    }
}
```
