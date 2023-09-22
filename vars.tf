variable "bastion_password" {
    default = "eshop123!"
    type = string
    description = "bastion server default password"
}

variable "admin_password" {
    default = "eshop123!"
    type = string
    description = "admin server default password"
}

variable "region" {
    #default = "KR-WEST-2"
    default = "KR-WEST"
    type = string
    description = "region for management cluster"
}

variable "service_zone_id" {
    #default = "ZONE-lxu6F_ntqxeIMaZZwh2I-p"      # for KR-WEST-2
    #default = "ZONE-Yi4UK3uHsujPbQYqsRgo7i"      # for KR-EAST-1
    default = "ZONE-1txHHEZvs5cPYfYpy2_FPc"      # for KR-WEST
    type = string
    description = "service_zone_id for file_storage"
}

variable "file_storage_name" {
    default = "" 
    type = string
    description = "file_storage_name for suffix adding"
}
