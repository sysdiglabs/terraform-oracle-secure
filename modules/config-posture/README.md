# Oracle Cloud Config Posture Module

This module will deploy Config Posture resources in Oracle for a compartment or root tenancy.

The following resources will be created in each instrumented compartment/tenancy:

- An Admit Policy on the target tenant that will allow sysdig tenant to `read` all-resources in the specified
  compartment/tenancy.
- A cloud account component in the Sysdig Backend, associated with the specified compartment/tenant and with the
  required metadata to serve the Config Posture functions.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

| Name                                                                      | Version   |
|---------------------------------------------------------------------------|-----------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0  |
| <a name="requirement_oci"></a> [oci](#requirement\_oci)                   | >= 6.19.0 |
| <a name="requirement_sysdig"></a> [sysdig](#requirement\_sysdig)          | >= 1.34.0 |

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
| [oci_identity_policy.admit_cspm_policy](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_policy) |
resource |
| [sysdig_secure_cloud_auth_account_component.oracle_service_principal](https://registry.terraform.io/providers/sysdiglabs/sysdig/latest/docs/resources/secure_cloud_auth_account_component) |
resource |

## Inputs

| Name                                                                                                             | Description                                                                                                                           | Type     | Default          | Required |
|------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------|----------|------------------|:--------:|
| <a name="input_is_organizational"></a> [is\_organizational](#input\_is\_organizational)                          | (Optional) True/False whether secure-for-cloud should be deployed in an organizational setup                                          | `bool`   | `false`          |    no    |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid)                                         | (Required) Customer tenant OCID                                                                                                       | `string` | n/a              |   yes    |
| <a name="input_compartment_ocid"></a> [compartment\_ocid](#input\_compartment\_ocid)                             | (Optional) Customer compartment OCID                                                                                                  | `string` | `""`             |    no    |
| <a name="input_sysdig_secure_account_id"></a> [sysdig\_secure\_account\_id](#input\_sysdig\_secure\_account\_id) | (Required) ID of the Sysdig Cloud Account to enable Config Posture for (in case of organization, ID of the Sysdig management account) | `string` | n/a              |   yes    |

## Outputs

| Name                                                                                                                                         | Description                                                                            |
|----------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------|
| <a name="output_service_principal_component_id"></a> [sysdig\_service\_principal\_component\_id](#output\_service\_principal\_component\_id) | Component identifier of Service Principal created in Sysdig Backend for Config Posture |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module is maintained by [Sysdig](https://sysdig.com).

## License

Apache 2 Licensed. See LICENSE for full details.