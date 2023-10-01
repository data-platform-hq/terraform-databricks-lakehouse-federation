output "connection_id" {
  value       = databricks_connection.this.id
  description = "ID of Identity Federation connection"
}

output "catalog_name" {
  value       = try(databricks_catalog.this[0].name, null)
  description = "Name of Foreign Catalog"
}
