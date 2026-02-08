# UC-AUTH-005: Session Timeout

## Use Case Overview
| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-AUTH-005 |
| **Use Case Name** | Session Timeout |
| **Primary Actor** | System |
| **Secondary Actor** | Authenticated User |
| **Description** | Automatically invalidate user session after 30 minutes of inactivity |
| **Preconditions** | User has active session |
| **Postconditions** | Session is invalidated; User must re-authenticate |

---

## Main Flow

### Step 1: Track Session Activity
- System tracks last activity timestamp for each session
- Activity includes any request to the system

### Step 2: Update Activity Timestamp
- On each user request:
  - System updates session's last activity timestamp to current time

### Step 3: Check Session Validity
- On each user request:
  - System calculates time since last activity
  - If elapsed time > 30 minutes → **Alternative Flow A1**
  - If elapsed time ≤ 30 minutes → Continue to requested resource

### Step 4: Process Request
- Session is valid
- System processes the user's request normally

---

## Alternative Flows

### A1: Session Expired
- **Trigger:** More than 30 minutes since last activity
- **Steps:**
  1. System invalidates the expired session
  2. System clears session data
  3. If request was AJAX/API:
     - System returns 401 Unauthorized status
     - Include header or body indicating session expired
  4. If request was page navigation:
     - System redirects to login page
     - System displays message: "Your session has expired. Please login again."
     - System preserves requested URL for redirect after login (optional)
  5. User must re-authenticate to continue

---

## Business Rules
| Rule ID | Description |
|---------|-------------|
| BR-SES-001 | Session timeout is 30 minutes of inactivity |
| BR-SES-002 | Any user request resets the inactivity timer |
| BR-SES-003 | Expired sessions must be completely invalidated |
| BR-SES-004 | Users must re-authenticate after session expiration |

---

## Technical Implementation Notes

### Session Validation Check (Pseudocode)
```
On each request:
1. Get session from request
2. If no session exists → redirect to login
3. Get lastActivityTime from session
4. Calculate elapsedTime = currentTime - lastActivityTime
5. If elapsedTime > 30 minutes:
   a. Invalidate session
   b. Redirect to login with "session expired" message
6. Else:
   a. Update lastActivityTime to currentTime
   b. Continue processing request
```

### Session Configuration
- Timeout duration: 30 minutes (1800 seconds)
- Configure in web.xml or programmatically

---

## UI Requirements
- Display session expiration warning (optional, e.g., 5 minutes before timeout)
- Clear error message when session expires
- Option to extend session if warning is shown
- Redirect to originally requested page after re-login (optional)
