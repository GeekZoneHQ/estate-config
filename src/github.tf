# NB!
# This is a ***TEMPORARY*** solution
# Once Geek.Zone/Web can manage groups, this will no longer be necessary.

#resource "github_membership" "all" {
#  for_each = local.github_usernames_roles
#  username = each.key
#  role     = each.value
#}
