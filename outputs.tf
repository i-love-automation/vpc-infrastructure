locals {
  export_as_organization_variable = {
    "vpc_id"               = aws_vpc.vpc.id
    "privates_subnets_ids" = [aws_subnet.private_1.id, aws_subnet.private_2.id]
  }
}

data "tfe_organization" "organization" {
  name = var.terraform_organization
}

data "tfe_variable_set" "variables" {
  name         = "variables"
  organization = data.tfe_organization.organization.name
}

resource "tfe_variable" "output_values" {
  for_each = local.export_as_organization_variable

  key             = each.key
  value           = jsonencode(each.value)
  category        = "terraform"
  description     = "${each.key} variable from the ${var.service} service"
  variable_set_id = data.tfe_variable_set.variables.id
}