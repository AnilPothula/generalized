variable "profile" {
  default  = "spokesly"
}
variable "region" {
  default = "us-west-2"
}
variable "name" {
  default = "elasticsearch"
}
variable "vpc_cidr" {
  default = "10.255.0.0/16"
}
variable "tags" {
  type    = map
  default = {}
}
variable "master_instance" {
  default = {
    type  = "t2.small"
    count = 1
  }
}
variable "data_instance" {
  default = {
    type  = "t2.small"
    count = 1
  }
}
variable "repo_arn" {
  description = "Repository ARN"
  default     = "arn:aws:codecommit:us-west-2:167952243308:spokesly-cookbook"
  type        = string
}
variable "cookbook_url" {
  default = "ssh://APKASOGV33JWO4RZ2MIF@git-codecommit.us-west-2.amazonaws.com/v1/repos/spokesly-cookbook"
  type    = string
}
variable "ssh_key" {
  type = string
  default = <<EOF
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAqOAl1BtXVkN/2tNdIw3XakcVo7fPjLybBCkSLl+Y6/SCNcyn
GPtNLliYHBAcAgnxUqgQqZWxVufCjiW7xao6BUN+0xfDKUn8Eezu1L84vrRke0bt
9Ob+9mQl3E3+4Yz3352XKInFV2qKsRiCoHaYJ7Um9E9kfu0Mg1amy+oL+EYzIW1a
hs8mmZy1Mlc18WLZ8G8PY06t/IZIaRoNSUdxIb+23TgoB50GEgNKLO2TUJmO6EHk
IdQcYOevnF2QIaPkygRHsuxXbG6lpYBcszMtHlD2m+oJ+OwuwnNW62OwX+lV6MfA
ngi6W3WiWrjQ6yEnsnJHDGAtoCRJhmYZPU46NwIDAQABAoIBAFg2JWxjD77eqVVr
nLXn0AMSuIn5RK/WAP8uWPHiO6Xc5XsmuI4DDrDL1ECsZYTnHqg3Y+TBbY3gp67K
pQe+QGppdEDdo7LYk5PleGemrwRmhCokxb1sP/gCHgiysRWuJfgngELLnEpqO6IA
FJOu/xGWvY9WPT9ToXqlc6EGU1ROtcMo01xLAA4wi8mHwHXj56X4ObpsGa91eQpB
qMXm4WkK+lXG+dorJzME/F4JOmVpsNzJlzOCHGR2jQ101nYs114xxrEfCMXuiBJk
6JMm/nhmRV00Q07W9WF5y+RQ2JgHTx8FQGYs1ggW+YtMHX42SxRHIhTKddXdCdiR
XTiJJ/ECgYEA0VoSGPKfK5wDipGIUmf+PxBZ9mp4njfuf4To5r7Axh4IWs5fBgvs
T4y060n3IHvMdSzApyui+OjFl3R93ZA2uUJS3MfkoOZ+cLKdBEbr1Oqz0D8qzBvw
esBA0WksRyh9W41O+9mgKGpASsyy0e/O0rjifCYHQMFP7rkrOg+jwkkCgYEAzoE2
4OSNdHMVT8tHtMNxeItEGZ4mVsEEZNP9MxPq34MFiJPM1XzptXM3Du4MYPf2fXcT
hMJA9o0WYTPROG1Xj8J2fZWYGiewUDjiQuSTXtEdCSQ8wkGAsXSNV1Cwxlm5kBM+
rr2naFWSoJtf3sNqnIG3DN2BDk9znKKJGjoKGH8CgYAOXK+BJqPkyf80Mme3v4qh
qO2DCircL9ocxXF04wE2ljjcgevi7k535p9CxQA/Kj8MitVsooG7sbxcd5Fq8cnP
S82Dd/MnVqi18orzECp9oNxVHQBCoGgPA8FunFh9STnQXhFdFcD3BNMETqa14E3A
Bw8ClVlKB/kD15Avm4MQgQKBgQCf3GvNYWEYGtcOtIFIMFyxQq5vXnyzgCyUmX9T
gUG70cQA3NofEtohe5XN2v5+Orb4navghDiiJMqEaQa4Nf0o7xOnWJ0s8jiNgdu2
iRiEuEFQCFt4zhiAR4f7Zh3TDzaVkDBgObVVEZm291EaNBFeIxS/wuHbYCpRwYl9
YhzapQKBgBzstCXNwXdX7VjtoiJ65HZO4wR+8tec/SXd+2i3Mqe/HqQ+RwIyWk9p
OrN76VdFzX/5sCO6EqHDdY+Y1xB0OR4NiLqzA7GFlMHaT1Pzwa2VDj2RDmLQMgLe
rm+8RNyyoc72990cOfDEkgiPSDRLEJ0ItFI6D1j+Mh9oRWmrKwUR
-----END RSA PRIVATE KEY-----
  EOF
}