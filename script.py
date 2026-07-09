import requests
import json
import time
from datetime import datetime, timezone, timedelta

# ============================================================
# CONFIGURATION
# ============================================================
token = open('abc.txt').read().strip()

headers = {
    'Authorization': f'Bearer {token}',
    'Content-Type': 'application/json'
}

BASE = 'https://app.opsera.io/api/v2'
INACTIVE_DAYS = 90

# Test only these users
TEST_EMAILS = ["akashadak@proton.me".lower(), "akashadak09@proton.me".lower()]

# ============================================================
# STEP 1: GET SPECIFIC ACTIVE USER
# API: GET /api/v2/usermanagement/users
# ============================================================
print('=' * 60)
print(f'STEP 1: Fetching users: {', '.join(TEST_EMAILS)}')
print(f'API: GET {BASE}/usermanagement/users')
print('=' * 60)

resp = requests.get(f'{BASE}/usermanagement/users', headers=headers)
resp.raise_for_status()

users = resp.json()

active_users = {}

for u in users:
    email = u.get('email', '').lower()

    if (
        email in TEST_EMAILS
        and u.get('active')
    ):
        active_users[email] = u.get('email')

if not active_users:
    print(f'None of the test users {', '.join(TEST_EMAILS)} found or are already inactive.')
    exit()

print(f'Found active test users: {', '.join(active_users.values())}\n')

# ============================================================
# STEP 2: GET LOGIN EVENTS FROM AUDIT LOGS
# API: GET /api/v2/logs/audit/user?action=login
# ============================================================
print('=' * 60)
print(f'STEP 2: Checking login activity for last {INACTIVE_DAYS} days for {', '.join(TEST_EMAILS)}')
print(f'API: GET {BASE}/logs/audit/user?action=login')
print('=' * 60)

now = datetime.now(timezone.utc)
start = now - timedelta(days=INACTIVE_DAYS)

users_who_logged_in = set()

page = 1
page_size = 100
total_records = 0

while True:

    params = {
        'action': 'login',
        'start_date': start.strftime('%Y-%m-%d'),
        'start_time': '00:00:00',
        'end_date': now.strftime('%Y-%m-%d'),
        'end_time': now.strftime('%H:%M:%S'),
        'page': page,
        'page_size': page_size
    }

    resp = requests.get(
        f'{BASE}/logs/audit/user',
        headers=headers,
        params=params
    )

    resp.raise_for_status()

    data = resp.json()
    records = data.get('data', [])

    if not records:
        break

    total_records += len(records)

    for r in records:

        email = (
            r.get('user_email')
            or r.get('email')
            or ''
        ).lower()

        if email in TEST_EMAILS: # Check if the logged-in email is one of our TEST_EMAILS
            users_who_logged_in.add(email)

    if len(records) < page_size:
        break

    page += 1

print(f'Total login records scanned: {total_records}')
print(f'Login found for {', '.join(TEST_EMAILS)}: {"YES" if any(email in users_who_logged_in for email in TEST_EMAILS) else "NO"}\n')

# ============================================================
# IDENTIFY INACTIVE USER
# ============================================================
inactive = []

# Only consider users from TEST_EMAILS that were found active in Step 1
# and have NOT logged in according to audit logs.
for email_lower in TEST_EMAILS:
    if email_lower in active_users and email_lower not in users_who_logged_in:
        inactive.append(active_users[email_lower])

print('=' * 60)
print('RESULT')
print('=' * 60)

if inactive:
    print(f'{', '.join(inactive)} have NOT logged in during the last {INACTIVE_DAYS} days.')
else:
    print(f'All of the test users {', '.join(TEST_EMAILS)} have logged in during the last {INACTIVE_DAYS} days.')
  
# ============================================================
# STEP 3: DEACTIVATE USER
# API: DELETE /api/v2/usermanagement/user/{email}
# ============================================================
print('\n' + '=' * 60)
print('STEP 3: Deactivate User')
print(f'API: DELETE {BASE}/usermanagement/user/{{email}}')
print('=' * 60)

if not inactive:
    print('All test users are active or not found. No deactivation required.')
    exit()

confirm = input(
    f'\nAbout to deactivate {', '.join(inactive)}. Type YES to confirm: '
)

if confirm != 'YES':
    print('Aborted. No user was deactivated.')
    exit()

results = {
    'success': [],
    'failed': []
}

for email in inactive:

    try:

        resp = requests.delete(
            f'{BASE}/usermanagement/user/{email}',
            headers=headers
        )

        if resp.status_code in (200, 201):

            results['success'].append(email)
            print(f'Deactivated: {email}')

        else:

            results['failed'].append({
                'email': email,
                'error': resp.text
            })

            print(f'FAILED: {email}')
            print(resp.text)

    except Exception as e:

        results['failed'].append({
            'email': email,
            'error': str(e)
        })

        print(f'ERROR: {email}')
        print(e)

    time.sleep(1)

# ============================================================
# SUMMARY
# ============================================================
print('\n' + '=' * 60)
print('SUMMARY')
print('=' * 60)

print(f'Successfully deactivated: {len(results["success"])}')
print(f'Failed: {len(results["failed"])}')

output_file = f'deactivation_results_{datetime.now().strftime("%Y%m%d_%H%M%S")}.json'

with open(output_file, 'w') as f:
    json.dump(results, f, indent=2)

print(f'Results saved to: {output_file}')
