variable vpc_cidr_block {
    default = "10.0.0.0/16"
}
variable subnet_cidr_block {
    default = "10.0.10.0/24"
}
variable avail_zone {
    default = "eu-west-3a"
}
variable env_prefix {
    default = "dev"
}
variable my_ip {
    default = "84.85.144.132/32"
}
variable jenkins_ip {
    default = "164.90.226.232/32"
}

variable instance_type {
    default = "t2.micro"
}
variable region {
    default = "eu-west-3"
}