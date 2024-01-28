import csv
import json
import requests


def is_valid_github_username(username):
    response = requests.get(f"https://api.github.com/users/{username}")
    return response.status_code == 200


def extract_github_usernames_and_roles(file_path):
    try:
        with open(file_path, mode="r", encoding="ISO-8859-1") as csv_file:
            csv_reader = csv.DictReader(csv_file)

            # Extract GitHub Usernames and their roles
            github_usernames_and_roles = {
                strip_github_username(row["GitHub Username"]): "admin"
                if row["GitHub Owner"].strip().lower() == "yes"
                else "member"
                for row in csv_reader
                if "GitHub Username" in row
                and row["GitHub Username"].strip() != ""
                and is_valid_github_username(row["GitHub Username"])
                and "GitHub Owner" in row
                and row["GitHub Owner"].strip() in ["yes", "no"]
            }

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
        return stripped_username[len(github_url_prefix) :]
    return stripped_username


input_file = "members.csv"
output_file = "github_usernames_roles.json"
usernames_and_roles = extract_github_usernames_and_roles(input_file)

with open(output_file, "w") as f:
    json.dump(usernames_and_roles, f)

print(f"GitHub Usernames and roles written to {output_file}")
