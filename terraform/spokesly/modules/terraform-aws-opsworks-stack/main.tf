resource "aws_opsworks_stack" "main" {
  name                          = var.name
  region                        = data.aws_region.current.name
  service_role_arn              = aws_iam_role.main.arn
  default_instance_profile_arn  = aws_iam_instance_profile.ec2.arn
  agent_version                 = "LATEST"
  configuration_manager_version = 12
  default_ssh_key_name          = var.ssh_key_name
  use_custom_cookbooks          = true
  use_opsworks_security_groups  = true
  vpc_id                        = var.vpc_id
  default_subnet_id             = var.private_subnets[0]
  default_os                    = "Ubuntu 18.04 LTS"


  custom_cookbooks_source {
    type     = lookup(var.custom_cookbooks_source, "type", "git")
    url      = "ssh://APKA2DYVJGKZTD375UW3@git-codecommit.us-east-1.amazonaws.com/v1/repos/layer2"
    ssh_key  = <<EOF
  -----BEGIN RSA PRIVATE KEY-----
MIIEpgIBAAKCAQEA2UoL3tdm+GWWPNCC8v5ti5PewvyGmf0mq7LYagcZ27LvzG9X
+urmyPhoLotb8KXVvT3bUXeFcI8c6l++3jFzuBzM1ywSLKfSyg1Ia8qe+lfHq08o
ergWOATh6Afqg3Aaj9WwRVjSX6+rb42m3P1WH7qQuGzd2iL57Gu1867WbWo6IiFf
BIw5uPl23J8E9JFCMeF5po0a9fL8vfT78FcBcB/qTre3PqjBqqX3gfGCDh02qZ3M
dy9VBCcw9b5pt9vLdtNIaqX2QyRNC8LC1CbGG6i9kWoYRAQw6Uu6cMcA5upglwha
b+CRWSMZ1/LeimLE1J8h/7EPpTnR7FtvR7nkoQIDAQABAoIBAQDQycrANKA33H1R
MFYzoXCnZs3s9HNt8gc/gplawDoDllu/R9n1O9PIlpCc8MHGacMIlTBxhnRNJOb2
+ktP+5qi9eGKfEl2aUgtaDgHg2nhSYmNvYE68jo/V8muiDS6WXTccstuxxtWYFlN
1oHY5QDlegJnhAxk96jImPL8FSrrdBoOVdWqjRwszHS7HmsRFyO7nw/ixhr07Cc5
Z2LvD6RQHkwkggZF/8e33zM9TkiKH1GsfpdvPRhvvXZbLupVyC3dmEm7UxdNqj3g
peXBUwxVTsoxPR3tiMDpQMK1+d4CylIboXJ7OzzxiLgPswb/L6+dhJzK6BreY+eS
PdGJGVJxAoGBAPrDpb3u32qw0DQajAIQCs2KmlubEZMRhoEfcuarUNOYk4jT6swA
ubVTtnurBsGJLvvq2bzMoUSCohBKfl1epaXTYpJdDidnR3WSiChx4aeoc4WmnfRX
65jyEW7b1UBMF3QQkHcavi6KBcntHetmZLCVx8imTB9dTnGBEH9q0qyVAoGBAN3T
eQHU5HJWNxWgqmI0P2iGE+8asMx27BLgSxhpBPpyOmE/ruLHK/uvjL8z1HJcArDM
4y1B/KDC7hh7pjWj6o4wZchPx6D/+uTNzITZc4ZliTdhZTMk1wP4ib4E7EXBOhJP
00MHi+DKpOS5OCeoksH48VEEdbNSG5tS4isszUjdAoGBAM1+yzIMsNWzs8se/iEq
mE+8B6aOOya0M+9YoEZbmc7st+pnD4DCD22C/oX1r4GmM/SJjoljf7yu+LQ097z4
NPLheWPMEi9EOZEl1aKfQHauWozp74MvEYiyxop8aBNax9V7RYf1SGjG/tttDxm7
PURgWeoaLUN+qSvmwmhIWADJAoGBAKf1NQxT+90utmqjyh6tXM1xp6pFVVSbPshU
F8gVzHUtBFMZ+vsuv3jERReI0PT+AfOITwK3kebPcaQMC59Vy4V507dF4OtgpsGT
qaV1WGmMe8b48b01ya/yAalk5Nk0Ixo2Ysm/7wN3rD6al5A/rU89hMpJTC1IoCqN
KT5zn8PpAoGBAIImX4WxPYTG0gG62d+HTHuuzBujW/7NoaNrX9gDexvXo2Rei3Jw
6HEGMwKT8/iFOfa0sUqbJBY6btGMZ1SnRMGB/rJHhb02FrN0JK8ihv9iTCFj/6zO
jS9epxjvWXha3N7ZHA7twcfKfhjdmTT3yGIRmLFhBtPeInMFJpHNle6+
-----END RSA PRIVATE KEY-----
  EOF
    revision = lookup(var.custom_cookbooks_source, "revision", null)
  }

  custom_json = var.custom_json

  depends_on = [ aws_iam_role_policy_attachment.main ]
}
