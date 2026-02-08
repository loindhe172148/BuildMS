# UC-USER-003: Toggle User Status

## 1. Use Case Overview

| Field | Description |
|-------|-------------|
| **Use Case ID** | UC-USER-003 |
| **Use Case Name** | Toggle User Status |
| **Actor(s)** | Admin |
| **Description** | Admin activates or deactivates a user account |
| **Trigger** | Admin clicks "Activate" or "Deactivate" button on a user |
| **Pre-conditions** | - Admin is logged in<br>- User exists in the system |
| **Post-conditions** | - User status is toggled (Active ↔ Inactive) |

---

## 2. Main Flow

| Step | Actor | System |
|------|-------|--------|
| 1 | Admin clicks "Deactivate" on an active user | System checks if user is not self |
| 2 | | System displays confirmation dialog |
| 3 | Admin confirms action | System updates Status to 'Inactive' |
| 4 | | System invalidates user's active sessions |
| 5 | | System displays success message |
| 6 | | System refreshes user list |

---

## 3. Alternative Flows

### AF-1: Activate User
| Step | Description |
|------|-------------|
| 1a | Admin clicks "Activate" on an inactive user |
| 1b | System displays confirmation dialog |
| 1c | Admin confirms action |
| 1d | System updates Status to 'Active' |
| 1e | System displays success message |

### AF-2: Self-Deactivation Attempt
| Step | Description |
|------|-------------|
| 1a | Admin tries to deactivate their own account |
| 1b | System displays error: "You cannot deactivate your own account" |
| 1c | Operation is cancelled |

### AF-3: Cancel Confirmation
| Step | Description |
|------|-------------|
| 3a | Admin clicks "Cancel" in confirmation dialog |
| 3b | System closes dialog, no changes made |

---

## 4. Business Rules

| Rule ID | Description |
|---------|-------------|
| BR-USER-009 | Inactive users cannot log in |
| BR-USER-010 | Admin cannot deactivate their own account |
| BR-USER-011 | Deactivation immediately invalidates active sessions |
| BR-USER-012 | Historical data (requests, orders) remains linked to user |

---

## 5. Access Control

| Role | Access Level |
|------|--------------|
| Admin | Full access |
| Manager | No access |
| Staff | No access |
| Sales | No access |

---

## 6. Data Requirements

### Validation Checks
| Check | Description |
|-------|-------------|
| Not Self | Prevent admin from deactivating own account |

### Database Changes
- UPDATE `Users` SET Status = 'Active'/'Inactive'

---

## 7. UI Requirements

- Show "Activate" button for inactive users
- Show "Deactivate" button for active users (except self)
- Hide or disable "Deactivate" for current admin's own account
- Display confirmation modal with username
- Visual indicator for inactive users (greyed out or badge)
- Use toast notification for success/error message
