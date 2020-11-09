# network_module_tf
Module for generate network module / Modulo de creacion de Redes AWS

##Use Module.

module "network_module" {
    source = "github.com/BryamSK/network_module_tf?ref=0.0.1"

    project_name  = var.project_name
    #CIRD_BLOCK del VPC, igrese el rango de IPs que desea para las redes internas
    base_cidr_block = "172.33.0.0/16" 
    networks = [
        {
            name     = "${var.aws_region}a"
            new_bits = 8
        },
        {
            name     = "${var.aws_region}b"
            new_bits = 8
        },
        {
            name     = "${var.aws_region}c"
            new_bits = 8
        },
      
    ]
}
