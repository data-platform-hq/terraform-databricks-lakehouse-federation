# Azure Databricks Lakehouse Federation Terraform module
Terraform module for creation Azure Databricks Lakehouse Federation

## Usage
This module provides an ability to provision Databricks Lakehouse Federation feature in Unity Catalog.
Lakehouse Federation addresses these critical pain points and makes it simple for organizations to expose, query, and govern siloed data systems as an extension of their lakehouse. 

Using Terraform create Connections to External Data Sources and provision Foreign Catalogs.

```hcl
# Configure Databricks Provider
data "azurerm_databricks_workspace" "example" {
  name                = "example-workspace"
  resource_group_name = "example-rg"
}

provider "databricks" {
  alias                       = "workspace"
  host                        = data.databricks_workspace.example.workspace_url
  azure_workspace_resource_id = data.databricks_workspace.example.id
}

# Configure Azure provider and reference target source
provider "azurerm" {}

data "azurerm_mssql_server" "example" {
  name                = "example-mssql-server"
  resource_group_name = "example-resource-group"
}

module "databricks_lakehouse_federation" {
  source  = "data-platform-hq/lakehouse-federation/databricks"
  version = "~> 1.0.0"

  metastore_id           = "10000000-0000-0000-0000-0000000000"
  create_foreign_catalog = true
  
  connection = {
    name            = "sql-server-connection"
    connection_type = "SQLSERVER"
    options = {
      name     = "mssql-example"
      host     = data.azurerm_mssql_server.example.fqdn
      user     = "mssql-admin-username"
      password = "mssql-example-password"
    }
  }
  
  catalog = {
    options = { 
      database = "TargetDatabaseName" 
    }
    grants  = [{ 
      group_name = "account users", 
      permission_level = ["USE_CATALOG", "USE_SCHEMA", "SELECT", ] 
    }]
  }

  providers = {
    databricks = databricks.workspace
  }
}
```
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0.0 |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | >=1.25.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | >=1.25.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [databricks_catalog.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/catalog) | resource |
| [databricks_connection.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/connection) | resource |
| [databricks_grants.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/grants) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_catalog"></a> [catalog](#input\_catalog) | Configuration options for Foreign Catalog creation using Lakehouse Federation connection | <pre>object({<br>    name          = optional(string)     # Name of Foreign Catalog<br>    force_destroy = optional(bool, true) # Delete catalog regardless of its contents.<br>    options       = map(string)          # For Foreign Catalogs: the name of the entity from an external data source that maps to a catalog. For example, the database name in a PostgreSQL server.<br>    grants = optional(set(object({       # List of objects with permission assigned to Foreign Catalog<br>      group_name       = string<br>      permission_level = set(string)<br>    })))<br>    comment    = optional(string, "Terraform-managed catalog") # User-supplied free-form text.<br>    properties = optional(map(string))                         # Extensible Catalog properties.<br>  })</pre> | `null` | no |
| <a name="input_connection"></a> [connection](#input\_connection) | Configuration options for Databricks Connection | <pre>object({<br>    name            = string                                           # Name of the Connection.<br>    connection_type = string                                           # Connection type. MYSQL, POSTGRESQL, SNOWFLAKE, REDSHIFT, SQLDW, SQLSERVER or DATABRICKS are supported.<br>    comment         = optional(string, "Terraform-managed connection") # Free-form text.<br>    options         = map(string)                                      # The key value of options required by the connection, e.g. host, port, user and password.<br>  })</pre> | `null` | no |
| <a name="input_create_foreign_catalog"></a> [create\_foreign\_catalog](#input\_create\_foreign\_catalog) | Boolean flag that determines whether Foreign Catalog using Connection is created | `bool` | `true` | no |
| <a name="input_metastore_id"></a> [metastore\_id](#input\_metastore\_id) | Databricks metastore id | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_catalog_name"></a> [catalog\_name](#output\_catalog\_name) | Name of Foreign Catalog |
| <a name="output_connection_id"></a> [connection\_id](#output\_connection\_id) | ID of Identity Federation connection |
<!-- END_TF_DOCS -->

## License

Apache 2 Licensed. For more information please see [LICENSE](https://github.com/data-platform-hq/terraform-databricks-lakehouse-federation/blob/main/LICENSE)
