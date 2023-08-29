resource "azurerm_api_management" "this" {
  name                = format("apim-%s", local.resource_suffix_kebabcase)
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  publisher_name      = "My Company"
  publisher_email     = "company@me.io"

  sku_name = var.apim_sku

  tags = local.tags
}

resource "azurerm_api_management_product" "this" {
  product_id            = "catalog"
  api_management_name   = azurerm_api_management.this.name
  resource_group_name   = azurerm_resource_group.this.name
  display_name          = "Catalog API"
  subscription_required = false
  approval_required     = false
  published             = true
}

resource "azurerm_api_management_api" "products" {
  name                = "products"
  resource_group_name = azurerm_resource_group.this.name
  api_management_name = azurerm_api_management.this.name
  revision            = "1"
  display_name        = "Products"
  path                = "products"
  protocols           = ["https"]
  service_url         = "https://swapi.dev/api" // TODO: change later
}

resource "azurerm_api_management_api_operation" "get_people" {
  operation_id        = "get-products"
  api_name            = azurerm_api_management_api.products.name
  api_management_name = azurerm_api_management_api.products.api_management_name
  resource_group_name = azurerm_api_management_api.products.resource_group_name
  display_name        = "Get Products"
  method              = "GET"
  url_template        = "/people/" // TODO: change later
  description         = "Get products."

  response {
    status_code = 200
  }
}
