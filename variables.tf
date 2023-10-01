variable "metastore_id" {
  description = "Databricks metastore id"
  type        = string
}

variable "create_foreign_catalog" {
  description = "Boolean flag that determines whether Foreign Catalog using Connection is created"
  type        = bool
  default     = true
}

variable "connection" {
  description = "Configuration options for Databricks Connection"
  type = object({
    name            = string                                           # Name of the Connection.
    connection_type = string                                           # Connection type. MYSQL, POSTGRESQL, SNOWFLAKE, REDSHIFT, SQLDW, SQLSERVER or DATABRICKS are supported.
    comment         = optional(string, "Terraform-managed connection") # Free-form text.
    options         = map(string)                                      # The key value of options required by the connection, e.g. host, port, user and password.
  })
  default = null
}

variable "catalog" {
  description = "Configuration options for Foreign Catalog creation using Lakehouse Federation connection"
  type = object({
    name          = optional(string)     # Name of Foreign Catalog
    force_destroy = optional(bool, true) # Delete catalog regardless of its contents.
    options       = map(string)          # For Foreign Catalogs: the name of the entity from an external data source that maps to a catalog. For example, the database name in a PostgreSQL server.
    grants = optional(set(object({       # List of objects with permission assigned to Foreign Catalog
      group_name       = string
      permission_level = set(string)
    })))
    comment    = optional(string, "Terraform-managed catalog") # User-supplied free-form text.
    properties = optional(map(string))                         # Extensible Catalog properties.
  })
  default = null
}
