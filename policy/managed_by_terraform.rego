package main

default managed_by_terraform = true

managed_by_terraform := count([resource | resource := input.resource[*]; not has_managedby_label(resource)]) == 0

has_managedby_label(resource) {
    resource.labels["managedby"] == "terraform"
}
