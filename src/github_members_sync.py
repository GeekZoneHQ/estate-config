"""
Script to Remove Former Geek.Zone Members from Geek.Zone GitHub Organization

Context:
This script is specifically designed to manage a unique aspect of the Geek.Zone GitHub organisation's
membership, focusing on those members who were manually added. While OpenTofu, our preferred open-source
alternative to Terraform, is utilized for automating most of our infrastructure management tasks, including
the synchronization of members with the Geek.Zone membership register on Membermojo, it cannot extend to
handling members who were manually added to GitHub. This script is developed to address this particular
corner case.

It is crucial to note that the creation of custom scripts for infrastructure management like this one is
an exception within our practices. Our standard approach is to leverage OpenTofu for all infrastructure
management needs due to its robustness, as well as its alignment with our open-source ethos. This script
serves as a supplement to OpenTofu, ensuring that the GitHub organization's membership remains accurate
and current, specifically by removing individuals who are no longer part of the Geek.Zone community and
were manually added to our GitHub organization outside the OpenTofu-managed processes.

Usage:
- Requires a GitHub Personal Access Token with 'admin:org' scope to modify organization membership.
- The latest 'github_usernames_roles.json' that accurately reflects the current membership status of the
  Geek.Zone community.

Author: jamesgeddes
Date: 2023-12-03
"""

import requests
import json
from os import getenv


def get_github_org_members(org_name, token):
    members = []
    url = f"https://api.github.com/orgs/{org_name}/members"
    headers = {'Authorization': f'token {token}'}

    while url:
        response = requests.get(url, headers=headers)
        members.extend(response.json())
        url = response.links.get('next', {}).get('url')  # Handle pagination

    return [member['login'] for member in members]


def read_json_file(file_path):
    with open(file_path, 'r') as file:
        return json.load(file)


def remove_member(token, org_name, member_to_remove):
    if member_to_remove == "jamesgeddes":
        # Hardcoded safeguard
        print("Can not remove James Geddes")
        return 0

    headers = {'Authorization': f'token {token}'}
    url = f"https://api.github.com/orgs/{org_name}/members/{member_to_remove}"
    response = requests.delete(url, headers=headers)
    if response.status_code == 204:
        print(f"Removed {member_to_remove} from {org_name}")
    else:
        print(f"Failed to remove {member_to_remove}: {response.content}")


# Replace 'your_token_here' with your GitHub personal access token
github_token = getenv("GITHUB_TOKEN")
github_org = getenv("GITHUB_ORGANIZATION")
json_file_path = 'github_usernames_roles.json'

# Get current members from GitHub organization
current_members = get_github_org_members(github_org, github_token)

# Read listed members from JSON file
listed_members = read_json_file(json_file_path).keys()

# Identify members to remove
members_to_remove = [member for member in current_members if member not in listed_members]

# Remove members not in the list
for leaver in members_to_remove:
    remove_member(github_token, github_org, leaver)
