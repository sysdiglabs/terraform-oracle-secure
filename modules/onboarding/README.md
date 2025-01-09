# Oracle Cloud Onboarding Module

This module will deploy foundational onboarding resources in Oracle for a compartment or root tenancy.

The following resources will be created in each instrumented compartment/tenancy:

- An Admit Policy on the target tenant that will allow sysdig tenant to `inspect` compartments in the specified
  compartment/tenancy.
- A cloud account in the Sysdig Backend, associated with the specified compartment/tenant and with the required
  component to serve the foundational functions.
- A cloud organization in the Sysdig Backend, associated with the specified compartment/tenant to fetch the organization
  structure(compartment tree) to install Sysdig Secure for Cloud.

Note:

- The outputs from the foundational module, such as `sysdig_secure_account_id` are needed as inputs to the other
  features/integrations modules for subsequent modular installations.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

| Name                                                                      | Version   |
|---------------------------------------------------------------------------|-----------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0  |
| <a name="requirement_oci"></a> [oci](#requirement\_oci)                   | >= 6.19.0 |
| <a name="requirement_sysdig"></a> [sysdig](#requirement\_sysdig)          | ~> 1.42   |

## Providers

| Name                                                       | Version |
|------------------------------------------------------------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci)          | 6.19.0  |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.1  |

## Modules

No modules.

## Resources

| [oci_identity_compartment.compartment](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_compartment) |
data source |
| [random_id.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [oci_identity_policy.admit_onboarding_policy](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_policy) |
resource |
| [sysdig_secure_cloud_auth_account.oracle_account](https://registry.terraform.io/providers/sysdiglabs/sysdig/latest/docs/resources/secure_cloud_auth_account) |
resource |
| [sysdig_secure_organization.oracle_organization](https://registry.terraform.io/providers/sysdiglabs/sysdig/latest/docs/resources/secure_organization) |
resource |

## Inputs

| Name                                                                                    | Description                                                                                  | Type     | Default | Required |
|-----------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------|----------|---------|:--------:|
| <a name="input_is_organizational"></a> [is\_organizational](#input\_is\_organizational) | (Optional) True/False whether secure-for-cloud should be deployed in an organizational setup | `bool`   | `false` |    no    |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid)                | (Required) Customer tenant OCID                                                              | `string` | n/a     |   yes    |
| <a name="input_compartment_ocid"></a> [compartment\_ocid](#input\_compartment\_ocid)    | (Optional) Customer compartment OCID                                                         | `string` | `""`    |    no    |
| <a name="input_region"></a> [region](#input\_region)                                    | (Required) Customer home region                                                              | `string` | n/a     |   yes    |

## Outputs

| Name                                                                                                               | Description                                                                  |
|--------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------|
| <a name="output_sysdig_secure_account_id"></a> [sysdig\_secure\_account\_id](#output\_sysdig\_secure\_account\_id) | ID of the Sysdig Cloud Account created                                       |
| <a name="output_is_organizational"></a> [is\_organizational](#output\_is\_organizational)                          | Boolean value to indicate if secure-for-cloud is deployed as an organization |
| <a name="output_tenancy_ocid"></a> [tenancy\_ocid](#output\_tenancy\_ocid)                                         | Customer tenant OCID                                                         |
| <a name="output_compartment_ocid"></a> [compartment\_ocid](#output_compartment\_ocid)                              | Customer compartment OCID                                                    |
| <a name="output_region"></a> [region](#output\_region)                                                             | Customer home region                                                         |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module is maintained by [Sysdig](https://sysdig.com).

## License

Apache 2 Licensed. See LICENSE for full details.