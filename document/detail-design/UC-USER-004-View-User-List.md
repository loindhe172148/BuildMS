# UC-USER-004: View User List

## 1. Use Case Overview

| Field | Description |
|-------|-------------|
| **Use Case ID** | UC-USER-004 |
| **Use Case Name** | View User List |
| **Actor(s)** | Admin |
| **Description** | Admin views list of all users in the system |
| **Trigger** | Admin navigates to user management section |
| **Pre-conditions** | - Admin is logged in |
| **Post-conditions** | - User list is displayed |

---

## 2. Main Flow

| Step | Actor | System |
|------|-------|--------|
| 1 | Admin clicks "Users" menu | System retrieves all users |
| 2 | | System displays user list with columns: Username, Name, Email, Role, Status, Last Login |
| 3 | Admin optionally applies filters | System filters the list |
| 4 | Admin views user information | |
| 5 | Admin optionally clicks action buttons | System navigates to respective function |

---

## 3. Alternative Flows

### AF-1: Filter by Role
| Step | Description |
|------|-------------|
| 3a | Admin selects a role from dropdown |
| 3b | System filters to show only users with that role |
| 3c | System updates the displayed list |

### AF-2: Filter by Status
| Step | Description |
|------|-------------|
| 3a | Admin selects status filter (Active/Inactive/All) |
| 3b | System filters users by status |
| 3c | System updates the displayed list |

### AF-3: Filter by Warehouse
| Step | Description |
|------|-------------|
| 3a | Admin selects warehouse from dropdown |
| 3b | System filters to show only users assigned to that warehouse |
| 3c | System updates the displayed list |

### AF-4: Search by Username or Email
| Step | Description |
|------|-------------|
| 3a | Admin enters search term |
| 3b | System searches users by username or email |
| 3c | System displays matching users |

---

## 4. Business Rules

| Rule ID | Description |
|---------|-------------|
| BR-USER-013 | Only Admin can view user list |
| BR-USER-014 | Current admin user is highlighted |

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

### Display Fields
| Field | Description |
|-------|-------------|
| Username | User's login name |
| Name | User's full name |
| Email | User's email address |
| Role | Admin/Manager/Staff/Sales |
| Status | Active or Inactive |
| Warehouse | Assigned warehouse name |
| Last Login | Last login timestamp |

---

## 7. UI Requirements

- Use table layout template from `template/html/tables-basic.html`
- Display users in a data table
- Include search box for username/email
- Include role dropdown filter
- Include status filter (Active/Inactive/All)
- Include warehouse dropdown filter
- Show "Add User" button
- Show "Edit", "Reset Password", and status toggle action buttons
- Highlight current admin user row
- Support pagination
