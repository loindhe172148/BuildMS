# UC-USER-002: Update User

## 1. Use Case Overview

| Field | Description |
|-------|-------------|
| **Use Case ID** | UC-USER-002 |
| **Use Case Name** | Update User |
| **Actor(s)** | Admin |
| **Description** | Admin updates an existing user's information |
| **Trigger** | Admin clicks "Edit" on a user from the list |
| **Pre-conditions** | - Admin is logged in<br>- User exists in the system |
| **Post-conditions** | - User information is updated |

---

## 2. Main Flow

| Step | Actor | System |
|------|-------|--------|
| 1 | Admin clicks "Edit" on a user | System retrieves user data |
| 2 | | System displays edit form with current values (password hidden) |
| 3 | Admin modifies username | System validates uniqueness |
| 4 | Admin modifies full name | System validates input |
| 5 | Admin modifies email | System validates format and uniqueness |
| 6 | Admin modifies role | System validates selection |
| 7 | Admin modifies warehouse assignment | System validates selection |
| 8 | Admin clicks "Save" | System validates all fields |
| 9 | | System updates user record |
| 10 | | System displays success message |
| 11 | | System redirects to user list |

---

## 3. Alternative Flows

### AF-1: User Not Found
| Step | Description |
|------|-------------|
| 1a | System cannot find the user |
| 1b | System displays error: "User not found" |
| 1c | System redirects to user list |

### AF-2: Duplicate Username
| Step | Description |
|------|-------------|
| 8a | System detects another user has the same username |
| 8b | System displays error: "Username already exists" |
| 8c | Admin corrects the username and resubmits |

### AF-3: Duplicate Email
| Step | Description |
|------|-------------|
| 8a | System detects another user has the same email |
| 8b | System displays error: "Email already registered" |
| 8c | Admin corrects the email and resubmits |

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
| BR-USER-007 | Password cannot be changed via this form (use Reset Password) |
| BR-USER-008 | Admin cannot demote themselves |

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
| Role | String (50) | Yes | Admin/Manager/Staff/Sales |
| WarehouseId | Long | No | Must exist if provided |

### Read-Only Fields
| Field | Description |
|-------|-------------|
| Password | Cannot be edited (use Reset Password) |
| Created Date | Original creation timestamp |
| Last Login | Last login timestamp |

### Database Changes
- UPDATE `Users` table

---

## 7. UI Requirements

- Use form layout template from `template/html/form-layouts-vertical.html`
- Pre-populate form with existing user data
- Password field not shown (link to Reset Password instead)
- Display validation errors inline
- Show last login information as read-only
- Include "Save" and "Cancel" buttons
