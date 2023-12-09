locals {
  github_usernames_roles = tomap(jsondecode(file("github_usernames_roles.json")))  # relies on CI having downloaded members.csv
}