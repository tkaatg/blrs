import requests
import json

API_KEY = "lin_api_jpfU0PR3JqvcsRpUH3SqjXeQaA3CeV08kNcNvGzZ"
URL = "https://api.linear.app/graphql"

headers = {
    "Content-Type": "application/json",
    "Authorization": API_KEY
}

def run_query(query, variables=None):
    response = requests.post(URL, headers=headers, json={'query': query, 'variables': variables})
    return response.json()

mutation_update = """
mutation IssueUpdate($id: String!, $stateId: String!) {
  issueUpdate(id: $id, input: { stateId: $stateId }) { success }
}
"""

# US 2.2.1 -> DONE
res = run_query("""
query {
  team(id: "09c8ed35-493c-4ea3-a77b-9a2395038217") {
    issues(filter: { title: { contains: "US 2.2.1" } }) { nodes { id } }
  }
}
""")

if res['data']['team']['issues']['nodes']:
    issue_id = res['data']['team']['issues']['nodes'][0]['id']
    # stateId for Done (81d161a0-5b01-4beb-a4c5-2892b07c2319)
    run_query(mutation_update, {"id": issue_id, "stateId": "81d161a0-5b01-4beb-a4c5-2892b07c2319"})
    print("US 2.2.1 completed in Linear.")
