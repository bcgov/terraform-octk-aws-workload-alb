<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_network"></a> [network](#module\_network) | git::https://github.com/BCDevOps/terraform-octk-aws-sea-network-info.git | master |

## Resources

| Name | Type |
|------|------|
| [aws_alb.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb) | resource |
| [aws_alb_listener.secure](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener) | resource |
| [aws_acm_certificate.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_security_group.lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_cert_domain"></a> [alb\_cert\_domain](#input\_alb\_cert\_domain) | The domain of cert to use for the internal ALB | `string` | `"*.example.ca"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The workload account environment (e.g. dev, test, prod) | `any` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | ALB name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns_name"></a> [dns\_name](#output\_dns\_name) | n/a |
<!-- END_TF_DOCS -->