# UC-AUTH-004: User Logout

## Use Case Overview
| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-AUTH-004 |
| **Use Case Name** | User Logout |
| **Primary Actor** | Authenticated User (All Roles) |
| **Description** | Terminate user session and log out of the system |
| **Preconditions** | User is logged in with active session |
| **Postconditions** | User session is destroyed; User is redirected to login page |

---

## Main Flow

### Step 1: User Initiates Logout
- User clicks "Logout" button/link in navigation or profile menu

### Step 2: Confirm Logout (Optional)
- System displays confirmation dialog: "Are you sure you want to logout?"
- User confirms logout
- If user cancels → **Alternative Flow A1**

### Step 3: Invalidate Session
- System invalidates current user session
- System removes session data:
  - User ID
  - Username
  - User Role
  - All session attributes

### Step 4: Clear Client-Side Data
- System clears any authentication cookies
- System clears any cached credentials

### Step 5: Redirect to Login Page
- System redirects user to login page
- System displays message: "You have been logged out successfully"

---

## Alternative Flows

### A1: User Cancels Logout
- **Trigger:** User clicks "Cancel" on confirmation dialog
- **Steps:**
  1. System closes confirmation dialog
  2. User remains on current page
  3. Session continues unchanged

---

## Business Rules
| Rule ID | Description |
|---------|-------------|
| BR-OUT-001 | Session must be completely invalidated on logout |
| BR-OUT-002 | User must be redirected to login page after logout |
| BR-OUT-003 | Any cached authentication data must be cleared |

---

## UI Requirements
- Logout option visible in navigation/header area
- Optional confirmation dialog
- Clear success message after logout
- Clean redirect to login page
