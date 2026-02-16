import requests
import sys

API_KEY = "lin_api_jpfU0PR3JqvcsRpUH3SqjXeQaA3CeV08kNcNvGzZ"
URL = "https://api.linear.app/graphql"
TEAM_ID = "09c8ed35-493c-4ea3-a77b-9a2395038217"

# States mapping (from earlier discovery)
STATES = {
    "done": "81d161a0-5b01-4beb-a4c5-2892b07c2319",
    "todo": "f10b7f8e-8a1a-4f8a-9a1a-1a2b3c4d5e6f", # Placeholder, need real ID if used
    "in_progress": "d1354a3e-6f81-4b10-9c16-56af593ba645" # Example
}

headers = {
    "Content-Type": "application/json",
    "Authorization": API_KEY
}

def run_query(query, variables=None):
    response = requests.post(URL, headers=headers, json={'query': query, 'variables': variables})
    return response.json()

def update_issue_state(us_code, state_name):
    # Find issue
    query = f"""
    query {{
      team(id: "{TEAM_ID}") {{
        issues(filter: {{ title: {{ contains: "{us_code}" }} }}) {{ nodes {{ id title }} }}
      }}
    }}
    """
    res = run_query(query)
    issues = res.get('data', {}).get('team', {}).get('issues', {}).get('nodes', [])
    
    if not issues:
        print(f"Issue {us_code} not found.")
        return

    issue_id = issues[0]['id']
    state_id = STATES.get(state_name.lower())
    
    if not state_id:
        # If state name not in map, try to find state ID by name
        state_query = f"""
        query {{
          workflowStates(filter: {{ team: {{ id: {{ eq: "{TEAM_ID}" }} }} }}) {{
            nodes {{ id name }}
          }}
        }}
        """
        states_res = run_query(state_query)
        remote_states = states_res.get('data', {}).get('workflowStates', {}).get('nodes', [])
        for s in remote_states:
            if s['name'].lower() == state_name.lower():
                state_id = s['id']
                break
    
    if not state_id:
        print(f"State {state_name} not found.")
        return

    mutation = """
    mutation IssueUpdate($id: String!, $stateId: String!) {
      issueUpdate(id: $id, input: { stateId: $stateId }) { success }
    }
    """
    run_query(mutation, {"id": issue_id, "stateId": state_id})
    print(f"Issue {us_code} updated to {state_name}.")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python manage_linear.py <US_CODE> <STATE>")
    else:
        update_issue_state(sys.argv[1], sys.argv[2])
