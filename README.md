# Network_module_tf
Módulo para Creación de redes publicas en AWS, Cea VPS, internet_gateway, Subredes y grupos de seguridad
## Ultima Version estable
v0.0.5

```
module "network_module" {
    source = "github.com/BryamSK/network_module_tf?ref=v0.0.5"

    project_name  = var.project_name
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
    ]
}
```
Se pueden crear tantas subredes como se requieran, Solo se debe adicionar en el parametro networks la siguiente cadena cambiando la letra para el nombre de la zona e disponibilidad (a, b, c, d, etc)
```
        {
            name     = "${var.aws_region}a"
            new_bits = 8
        },
```

## Variablesde entrada

```
variable "project_name" {
  description = "The name to use for tags"
  type        = string
}

variable "networks" {
  description = "List networks for created in subnet"
}

variable "base_cidr_block" {
  description = "IP cidr block"
  type        = string
}
```
## Variables de Salida
```
output "vpc_id" {
  value       = aws_vpc.aws-vpc.id
  description = "The name vpc"
}
output "aws_subnet_ids" {
  value       = values(aws_subnet.subnet)[*].id
  description = "The ids subnet"
}
output "aws_security_group_alb" {
  value       = aws_security_group.alb.id
  description = "the security_group id for alb"
}

output "aws_security_group_ecs_tasks" {
  value       = aws_security_group.ecs_tasks.id
  description = "the security_group id for ecs_tasks"
}
```
