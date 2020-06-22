# XCLAIM CloudFormation Templates

This repo primarily declares the infrastructure required to deploy our Rails
API to Fargate/ECS. It contains templates for the following CloudFormation
stacks:

* `src/vpc.yml` - networking resources (ie VPC, gateways, etc) used by all the
  other stacks.
* `src/db.yml` - RDS Postgres instance inside the VPC.
* `src/redis.yml` - ElastiCache Redis instance inside the VPC.
* `src/fargate.yml` - ECS Fargate setup, including CodePipeline+CodeBuild for
  CD.
* `src/sftp.yml` - Transfer for SFTP setup for claims agent using flat-file
  integration. See "SFTP" below.
* `src/bastion.yml` - Bastion host to allow edge access to the VPC for
  debugging. See "Accessing resources in the VPC" below.

## Building

While AWS Cloudformation templates support limited sharing of snippets between
configs via the [AWS::Include transform](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/create-reusable-transform-function-snippets-and-add-to-your-template-with-aws-include-transform.html),
they don't allow for semi-complex use cases like `Ref` or `Sub` macros within
the shared snippet. This leads to a lot of repetition in the templates and
resulting room for error.

To get around this limitation we added a pre-AWS-build processing step via
`build.rb`. In summary:

* All source files should live in the `/src` directory
* The build process will deposit all processed files in `/build`
* Any files with a `.erb` extension will go through processing
  * These files support an `include` directive which allows you to import the
    contents of files under `/src/includes`
  * The included content is copied as-is into the final file so any macros
    (`Ref`, `Join`, etc) will be in the context of the including file
* All other files will be copied verbatim to `/build`

After building you can upload the files in `/build` to Cloudformation as normal.

### Using Docker Compose

Run the build script in a Docker container with:

```
docker-compose up
```

### Example

`In src/fargate.yml.erb`

```
PortMappings:
  - ContainerPort:
      Fn::ImportValue: !Sub ${NetworkStackName}-AppIngressPort
Environment:
  <%= includes("fargate_env_vars.yml") %>
...
```

In `src/includes/fargate_env_vars.yml`

```
- Name: BUCKET_NAME
  Value: !Ref DefaultContainerBucket
...
```

After running `build.rb`, in `build/fargate.yml`:

```
...
PortMappings:
  - ContainerPort:
      Fn::ImportValue: !Sub ${NetworkStackName}-AppIngressPort
Environment:
  - Name: BUCKET_NAME
    Value: !Ref DefaultContainerBucket
...
```

## Deployment from cli

All the infrastructure is deployed through Cloud Formatinon. To make the deployment easier the repository contains a CLI script in bash in the *[commands](commands)* folder. To run commands successfully, aws cli needs to be installed. However you can deploy everything using *aws cli* commands (you need the aws-cli installed)

### CLI

The CLI is simple, it handles three commands:

- **create**: creates the cloudformation stack
- **update**: updates the cloudformation stack

All the commands accept an `-e | --environment` flag which specifies which environment and configuration to use (The default is `dev`)

All the commands accept an `-s | --stack_name` flag which specifies file name with out extension (.yml) to be deploy on a stack

The CLI needs a default profile in aws credentials file. Example of credential file

```
[default]
aws_access_key_id=AKIAIOSFODNN7EXAMPLE
aws_secret_access_key=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
region=us-east-1
To use the CLI:

All these commands needs to run from parent directory. 

```console
$ ./commands/cf help


usage: cf (create|update) [options]

    -e | --environment  The environment for the Stack [ dev, staging, production, demo, mgmt ]
    -s | --stack_name  The File Name to be deployed with out extensions
```

Example command for deploying mgmt-vpc in mgmt environment

```
./commands/cf create -e mgmt -s mgmt-vpc
```
## Deploying from scratch

First see "Building" above.

Create CloudFormation stacks from each template in the following order. Some
templates depend on prior templates being deployed first and will ask you for
the name of the prior stack in the parameter inputs.

1. VPC
1. SFTP
1. DB
1. Redis
1. Fargate
  * When you first deploy this stack, you'll want to either: a) select a
    previously built xclaim-api image for SeedDockerImage; or b) while the
    stack is creating, navigate in the AWS GUI to each of the new Fargate
    Services and manually update them to launch 0 tasks. This will allow
    Fargate to complete the initial creation without failing health checks.
    Change back to desired task count once stack deploys successfully.
    Otherwise, Fargate won't finish creation and thus the CodePipeline won't
    create, leaving you in limbo.
1. Bastion

## Deploying updates

First see "Building" above.

Two types of updates explained below. In both cases be sure to review the
changeset before deploying it and ensure it looks good.

**Important** when deploying updates, set the `SeedDockerImage` parameter
to the latest container in ECR that was built by this stack's CodePipeline.

#### Updating a template itself

Find the stack in the CloudFormation Web UI, choose to update it and select
the option to update the template. Upload the modified template.

#### Updating the parameters of a stack

Find the stack in the CloudFormation Web UI, choose to update it and select
the option to use the same template. You'll then have the option to update the
parameters and re-deploy the stack.

## Environment Variables

Environment variables are added to `src/includes/fargate_env_vars.yml` which
is then built into the `build/fargate.yml` (see Building above). For non-static
values, you can accept the value as parameter input in the fargate.yml template.

```
# src/fargate.yml.erb
Parameters:
  SomeValue:
    Type: String
    Default: ""
    ConstraintDescription: Describe your value here

# src/includes/fargate_env_vars.yml
- Name: SOME_VALUE
  Value: !Ref SomeValue
- Name: SOME_STATIC_VALUE
  Value: the_value_goes_here
```

See [the wiki](https://github.com/XclaimInc/wiki/wiki/Adding-Environment-Variables) for full information about how to add new environment variables

### Secrets

If the ENV var you're adding is to contain a secret value as opposed to a
non-sensitive configuration value, use AWS Secrets Manager and reference the ARN
from the CloudFormation template.

```
# src/fargate.yml.erb
Parameters:
  SentryDsnArn:
    Type: String
    Default: ""
    ConstraintDescription: ARN to the Sentry DSN stored in Secrets Manager

# src/includes/fargate_env_vars.yml
- Name: SENTRY_DSN
  Value: !Join ['', ['{{resolve:secretsmanager:', !Ref SentryDsnArn, ':SecretString}}' ]]
```

### Inspecting deployed/runtime ENV vars

For debugging purposes, it can sometimes be helpful to inspect the ENV vars
that are actually in use on a server. With ECS Fargate, you can do this in the
AWS web UI:

ECS > select a cluster > Tasks tab > select the Task Definition you’re interested
in (web, worker, etc) -> scroll down and expand the Container Definition


## Accessing resources in the VPC

Everything we deploy is inside a private VPC, only accessible via the load
balancer. In order to connect to EC2s, databases, etc, you'll need to use the
bastion host.

### Accessing RDS via bastion

The following commands forward local port 9000 over SSH through the bastion host
to the RDS endpoint, and then use psql to connect to it.

```
ssh -i [path to EC2 keypair] -NL 9000:[RdsDbURL]:5432 ec2-user@[BastionEip] -v
psql --host=localhost --port=9000 --username=xclaim --password --dbname=xclaim
```

You can find the value for `[RdsDbURL]` in the Outputs of the DB stack, and
`[BastionEip]` in the Outputs of the bastion stack.

You can use the same approach to connect a locally running `rails console` to an
RDS database:

```
# ssh tunnel command from above, then...
DATABASE_ENDPOINT=localhost DATABASE_PORT=9000 DATABASE_USER=xclaim DATABASE_PASSWORD=[password from AWS secrets manager] DATABASE_NAME=xclaim bundle exec rails c
```

### Accessing Redis via bastion

The following commands forward local port 9001 over SSH through the bastion host
to the Redis endpoint, and then use redis-cli to connect to it.

```
ssh -i [path to EC2 keypair] -NL 9001:[RedisAddress]:6379 ec2-user@[BastionEip] -v
redis-cli -p 9001
```

## SFTP

This template manages the AWS Transfer for SFTP infrastructure used for the
minimal Claims Agent integration (ie flat-file transfer).

### Adding a Claims Agent user

Add a new SFTP user by copying one of the user blocks (eg `UserNick`) and
replacing occurrences of `nick` with the Claims Agent name (eg `bmc`), and
replacing the SSH public key with one provided by the Claims Agent.

Note that if you receive a Windows SSH2 public key, you can convert it to an
OpenSSH key (what AWS requires) like so: `ssh-keygen -i -f ssh2.pub > openssh.pub`
