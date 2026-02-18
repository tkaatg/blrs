import requests
import json

API_KEY = "lin_api_jpfU0PR3JqvcsRpUH3SqjXeQaA3CeV08kNcNvGzZ"
URL = "https://api.linear.app/graphql"
DONE_STATE_ID = "81d161a0-5b01-4beb-a4c5-2892b07c2319"

headers = {
    "Content-Type": "application/json",
    "Authorization": API_KEY
}

def run_query(query, variables=None):
    response = requests.post(URL, headers=headers, json={'query': query, 'variables': variables})
    return response.json()

def update_issue_state(issue_id, state_id):
    mutation = """
    mutation IssueUpdate($id: String!, $stateId: String!) {
      issueUpdate(id: $id, input: { stateId: $stateId }) { 
        success 
        issue {
            identifier
            title
        }
      }
    }
    """
    res = run_query(mutation, {"id": issue_id, "stateId": state_id})
    return res

# Corrected list of Issue IDs to move to DONE
ISSUES_TO_DONE = [
    "7f2a551c-f2bc-4912-9816-ac8c6304f0e9", # BLR-16: US 3.1.1: Calcul des points basé sur la rapidité
    "31a4e86f-2577-4df4-8d29-9ea7fb57e747", # BLR-17: US 3.1.2: Accumulation et gestion des étoiles
    "0b5db999-30c4-47b8-920b-b553340f0002", # BLR-18: US 3.2.1: Leaderboard : Top 10 mondial
    "6e58fa44-fd89-46bd-a290-371715fff4da", # BLR-19: US 3.2.2: Affichage position personnelle
]

if __name__ == "__main__":
    for issue_id in ISSUES_TO_DONE:
        print(f"Updating issue {issue_id}...")
        result = update_issue_state(issue_id, DONE_STATE_ID)
        if result and result.get('data') and result.get('data').get('issueUpdate'):
            if result['data']['issueUpdate'].get('success'):
                issue = result['data']['issueUpdate']['issue']
                print(f"Successfully updated {issue['identifier']}: {issue['title']}")
            else:
                print(f"Failed to update {issue_id}: {result}")
        else:
            print(f"API Error for {issue_id}: {result}")
