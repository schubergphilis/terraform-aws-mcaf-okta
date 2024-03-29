# terraform-aws-mcaf-okta

# Terraform module usage

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| account\_id | The account ID of the master account | `string` | n/a | yes |
| metadata | The identity provider metadata generated by Okta | `string` | n/a | yes |
| name | A name for the default platform admin role | `string` | n/a | yes |
| tags | A mapping of tags to assign to the resources | `map(string)` | n/a | yes |
| max\_session\_duration | The maximum session duration (in seconds) for the role | `number` | `null` | no |
| postfix | Postfix the admin role and policy names with Role and Policy | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| assume\_policy | The IAM policy you can attach to roles so they can be assumed by Okta |
| okta\_idp\_arn | The ARN of the Okta Identity Provider in AWS |

<!--- END_TF_DOCS --->
