resource "databricks_connection" "this" {
  name            = var.connection.name
  connection_type = var.connection.connection_type
  options         = var.connection.options
  comment         = var.connection.comment
}

resource "databricks_catalog" "this" {
  count = var.create_foreign_catalog ? 1 : 0

  name            = coalesce(var.catalog.name, "foreign-connection-${var.connection.name}")
  force_destroy   = var.catalog.force_destroy
  connection_name = databricks_connection.this.name
  metastore_id    = var.metastore_id
  options         = var.catalog.options
  properties      = var.catalog.properties
  comment         = var.catalog.comment
}

resource "databricks_grants" "this" {
  count = alltrue([var.create_foreign_catalog, var.catalog.grants != null]) ? 1 : 0

  catalog = databricks_catalog.this[0].name
  dynamic "grant" {
    for_each = var.catalog.grants
    content {
      principal  = grant.value.group_name
      privileges = grant.value.permission_level
    }
  }
}
