# AWS RDS Terraform module

Terraform module which creates RDS resources on AWS.

These types of resources are supported:

* [DB Instance](https://www.terraform.io/docs/providers/aws/r/db_instance.html)
* [DB Subnet Group](https://www.terraform.io/docs/providers/aws/r/db_subnet_group.html)


## Usage

```hcl
module "rds" {
    source  = "./modules/rds"
    rds_master_username         ="parveendev"
    database_name               ="parveendev"
    identifier                  = "dev-rd-postgres"
    engine                      = "postgres"
    engine_version              = "9.6.11"
    instance_class              = "db.t2.micro"
    multi_az                    = false
    subnet_group_description    = "Subnet Group Description"
    subnets                     = ["subnet-XXXXXXXXXXXX", "subnet-XXXXXXXXXXXX"]
    ssm_db_password_key_description ="key description"
    tags = {
      dev="Parveen"
      email="parveen@nclouds.com"
      Name = "RDS-postgres",
      Team =  "Layer2",
    }
}
```
