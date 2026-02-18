import requests
import json

API_KEY = "lin_api_jpfU0PR3JqvcsRpUH3SqjXeQaA3CeV08kNcNvGzZ"
URL = "https://api.linear.app/graphql"
TEAM_ID = "09c8ed35-493c-4ea3-a77b-9a2395038217"

headers = {
    "Content-Type": "application/json",
    "Authorization": API_KEY
}

def run_query(query, variables=None):
    response = requests.post(URL, headers=headers, json={'query': query, 'variables': variables})
    return response.json()

# Get Workflow States
state_query = f"""
query {{
  workflowStates(filter: {{ team: {{ id: {{ eq: "{TEAM_ID}" }} }} }}) {{
    nodes {{ id name }}
  }}
}}
"""
states_res = run_query(state_query)
print("--- Workflow States ---")
print(json.dumps(states_res, indent=2))

# Get Issues
issues_query = f"""
query {{
  team(id: "{TEAM_ID}") {{
    issues {{
      nodes {{
        id
        identifier
        title
        state {{
          name
        }}
      }}
    }}
  }}
}}
"""
issues_res = run_query(issues_query)
print("\n--- Issues ---")
print(json.dumps(issues_res, indent=2))
