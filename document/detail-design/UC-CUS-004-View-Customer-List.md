# UC-CUS-004: View Customer List

## 1. Use Case Overview

| Field | Description |
|-------|-------------|
| **Use Case ID** | UC-CUS-004 |
| **Use Case Name** | View Customer List |
| **Actor(s)** | Admin, Manager, Sales |
| **Description** | User views list of all customers |
| **Trigger** | User navigates to customer management section |
| **Pre-conditions** | - User is logged in with appropriate role |
| **Post-conditions** | - Customer list is displayed |

---

## 2. Main Flow

| Step | Actor | System |
|------|-------|--------|
| 1 | User clicks "Customers" menu | System retrieves all customers |
| 2 | | System displays customer list with columns: Code, Name, Contact Info, Status |
| 3 | User optionally applies filters | System filters the list |
| 4 | User views customer information | |
| 5 | User optionally clicks action buttons | System navigates to respective function |

---

## 3. Alternative Flows

### AF-1: No Customers Found
| Step | Description |
|------|-------------|
| 1a | System finds no customers in database |
| 1b | System displays message: "No customers found" |
| 1c | System shows "Add Customer" button |

### AF-2: Filter by Status
| Step | Description |
|------|-------------|
| 3a | User selects status filter (Active/Inactive/All) |
| 3b | System filters customers by status |
| 3c | System updates the displayed list |

### AF-3: Search by Code or Name
| Step | Description |
|------|-------------|
| 3a | User enters search term |
| 3b | System searches customers by code or name |
| 3c | System displays matching customers |

---

## 4. Business Rules

| Rule ID | Description |
|---------|-------------|
| BR-CUS-007 | Sales, Manager, and Admin can view customers |
| BR-CUS-008 | Only Admin can toggle customer status |

---

## 5. Access Control

| Role | Access Level |
|------|--------------|
| Admin | Full access - view, add, edit, toggle status |
| Manager | View, add, edit |
| Staff | No access |
| Sales | View, add, edit |

---

## 6. Data Requirements

### Display Fields
| Field | Description |
|-------|-------------|
| Code | Customer code |
| Name | Customer name |
| Contact Info | Contact information |
| Status | Active or Inactive |
| Order Count | Number of sales orders |

---

## 7. UI Requirements

- Use table layout template from `template/html/tables-basic.html`
- Display customers in a data table
- Include search box for code/name
- Include status filter (Active/Inactive/All)
- Show "Add Customer" button
- Show "Edit" button for all authorized users
- Show status toggle button for Admin only
- Support pagination
