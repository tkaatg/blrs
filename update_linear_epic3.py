
import requests
import json

LINEAR_API_KEY = "lin_api_G2G10n62E3tYfXfK8uM9NEnuCOq6O0WnBfM15SjH"
TEAM_ID = "61cf3d8e-7389-4678-b99d-3ee0c5e933e1"
DONE_STATE_ID = "81d161a0-5b01-4beb-a4c5-2892b07c2319"

# Issues to mark as DONE
ISSUES_TO_DONE = [
    "7f2a551c-f2bc-4912-9816-ac8c6304f0e9", # BLR-16
    "31a4e86f-2577-4df4-8d29-9ea7fb57e747", # BLR-17
    "0b5db999-30c4-47b8-920b-b553340f0002", # BLR-18
    "6e58fa44-fd89-46bd-a290-371715fff4da", # BLR-19
]

def run_query(query, variables=None):
    headers = {"Authorization": LINEAR_API_KEY, "Content-Type": "application/json"}
    payload = {"query": query, "variables": variables}
    response = requests.post("https://api.linear.app/graphql", headers=headers, json=payload)
    if response.status_code == 200:
        return response.json()
    else:
        raise Exception(f"Query failed with status {response.status_code}: {response.text}")

def update_issue_state(issue_id, state_id):
    mutation = """
    mutation UpdateIssue($id: String!, $stateId: String!) {
      issueUpdate(id: $id, input: { stateId: $stateId }) {
        success
        issue {
          id
          title
        }
      }
    }
    """
    res = run_query(mutation, {"id": issue_id, "stateId": state_id})
    return res

if __name__ == "__main__":
    for issue_id in ISSUES_TO_DONE:
        print(f"Updating issue {issue_id}...")
        try:
            result = update_issue_state(issue_id, DONE_STATE_ID)
            if result.get("data", {}).get("issueUpdate", {}).get("success"):
                title = result["data"]["issueUpdate"]["issue"]["title"]
                print(f"Successfully updated: {title}")
            else:
                print(f"Failed to update {issue_id}: {result}")
        except Exception as e:
            print(f"Error updating {issue_id}: {e}")
