import csv
import json
import requests


def extract_github_usernames_and_roles(file_path):
    try:
        with open(file_path, mode='r', encoding='ISO-8859-1') as csv_file:
            csv_reader = csv.DictReader(csv_file)

            github_usernames_and_roles = {}
            for row in csv_reader:
                if 'GitHub Username' in row and row['GitHub Username'].strip() != '' and \
                        'GitHub Owner' in row and row['GitHub Owner'].strip() in ['yes', 'no']:
                    username = strip_github_username(row['GitHub Username'])
                    if check_github_user_exists(username):
                        github_usernames_and_roles[username] = 'admin' if row['GitHub Owner'].strip().lower() == 'yes' else 'member'

        return github_usernames_and_roles
    except FileNotFoundError:
        print(f"The file at {file_path} was not found.")
        return {}
    except KeyError as e:
        print(f"Missing column in the CSV file: {e}")
        return {}
    except Exception as e:
        print(f"An error occurred: {e}")
        return {}


def strip_github_username(username):
    """Strips whitespace, removes the 'https://github.com/' prefix and '@' symbol from the username."""
    stripped_username = username.strip().replace("@", "")
    github_url_prefix = "https://github.com/"
    if stripped_username.startswith(github_url_prefix):
        return stripped_username[len(github_url_prefix):]
    return stripped_username


def check_github_user_exists(username):
    """Check if a GitHub user exists."""
    url = f"https://api.github.com/users/{username}"
    response = requests.get(url)
    return response.status_code == 200


input_file = 'members.csv'
output_file = 'github_usernames_roles.json'
usernames_and_roles = extract_github_usernames_and_roles(input_file)

with open(output_file, 'w') as f:
    json.dump(usernames_and_roles, f, indent=4)

print(f"GitHub Usernames and roles written to {output_file}")
