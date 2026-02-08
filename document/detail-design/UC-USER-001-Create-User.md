# UC-USER-001: Create User (Not need to implement because already implemented in UC-AUTH-002-User-Registration)

## 1. Use Case Overview

| Field | Description |
|-------|-------------|
| **Use Case ID** | UC-USER-001 |
| **Use Case Name** | Create User |
| **Actor(s)** | Admin |
| **Description** | Admin creates a new user account in the system |
| **Trigger** | Admin navigates to user management and clicks "Add User" |
| **Pre-conditions** | - Admin is logged in |
| **Post-conditions** | - New user account is created<br>- User can log in with assigned credentials |

---

## 2. Main Flow

| Step | Actor | System |
|------|-------|--------|
| 1 | Admin clicks "Add User" button | System displays user creation form |
| 2 | Admin enters username | System validates uniqueness |
| 3 | Admin enters full name | System validates input |
| 4 | Admin enters email | System validates format and uniqueness |
| 5 | Admin enters initial password | System validates password strength |
| 6 | Admin selects role | System provides role options |
| 7 | Admin optionally selects warehouse | System loads warehouse dropdown |
| 8 | Admin clicks "Save" | System validates all fields |
| 9 | | System hashes password with SHA-256 + salt |
| 10 | | System creates user record with Status = 'Active' |
| 11 | | System displays success message |
| 12 | | System redirects to user list |

---

## 3. Alternative Flows

### AF-1: Duplicate Username
| Step | Description |
|------|-------------|
| 8a | System detects username already exists |
| 8b | System displays error: "Username already exists" |
| 8c | Admin corrects the username and resubmits |

### AF-2: Duplicate Email
| Step | Description |
|------|-------------|
| 8a | System detects email already exists |
| 8b | System displays error: "Email already registered" |
| 8c | Admin corrects the email and resubmits |

### AF-3: Weak Password
| Step | Description |
|------|-------------|
| 8a | System detects password doesn't meet requirements |
| 8b | System displays error: "Password must be at least 6 characters" |
| 8c | Admin enters stronger password and resubmits |

### AF-4: Cancel Operation
| Step | Description |
|------|-------------|
| 3a | Admin clicks "Cancel" |
| 3b | System redirects to user list without saving |

---

## 4. Business Rules

| Rule ID | Description |
|---------|-------------|
| BR-USER-001 | Username must be unique |
| BR-USER-002 | Email must be unique and valid format |
| BR-USER-003 | Password minimum 6 characters |
| BR-USER-004 | Role is required |
| BR-USER-005 | Staff and Manager should have warehouse assignment |
| BR-USER-006 | New users are active by default |

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

### Input Fields
| Field | Type | Required | Validation |
|-------|------|----------|------------|
| Username | String (100) | Yes | Not empty, unique |
| Name | String (255) | Yes | Not empty |
| Email | String (255) | Yes | Valid email format, unique |
| Password | String | Yes | Min 6 characters |
| Role | String (50) | Yes | Admin/Manager/Staff/Sales |
| WarehouseId | Long | No | Must exist if provided |

### Database Changes
- INSERT into `Users` table

---

## 7. UI Requirements

- Use form layout template from `template/html/form-layouts-vertical.html`
- Password field with visibility toggle
- Role as dropdown with options: Admin, Manager, Staff, Sales
- Warehouse dropdown (enabled for Staff/Manager roles)
- Display validation errors inline
- Include "Save" and "Cancel" buttons
