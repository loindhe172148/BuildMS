# UC-CUS-003: Toggle Customer Status

## 1. Use Case Overview

| Field | Description |
|-------|-------------|
| **Use Case ID** | UC-CUS-003 |
| **Use Case Name** | Toggle Customer Status |
| **Actor(s)** | Admin |
| **Description** | Admin activates or deactivates a customer |
| **Trigger** | Admin clicks "Activate" or "Deactivate" button on a customer |
| **Pre-conditions** | - Admin is logged in<br>- Customer exists in the system |
| **Post-conditions** | - Customer status is toggled (Active ↔ Inactive) |

---

## 2. Main Flow

| Step | Actor | System |
|------|-------|--------|
| 1 | Admin clicks "Deactivate" on an active customer | System displays confirmation dialog |
| 2 | Admin confirms action | System updates Status to 'Inactive' |
| 3 | | System displays success message |
| 4 | | System refreshes customer list |

---

## 3. Alternative Flows

### AF-1: Activate Customer
| Step | Description |
|------|-------------|
| 1a | Admin clicks "Activate" on an inactive customer |
| 1b | System displays confirmation dialog |
| 1c | Admin confirms action |
| 1d | System updates Status to 'Active' |
| 1e | System displays success message |

### AF-2: Customer Has Pending Orders (Deactivation Warning)
| Step | Description |
|------|-------------|
| 1a | System detects customer has pending sales orders |
| 1b | System displays warning: "This customer has pending orders. Deactivating will prevent new orders only." |
| 1c | Admin can still proceed with deactivation |

### AF-3: Cancel Confirmation
| Step | Description |
|------|-------------|
| 2a | Admin clicks "Cancel" in confirmation dialog |
| 2b | System closes dialog, no changes made |

---

## 4. Business Rules

| Rule ID | Description |
|---------|-------------|
| BR-CUS-004 | Inactive customers cannot have new sales orders created |
| BR-CUS-005 | Existing orders for inactive customers can still be processed |
| BR-CUS-006 | Only Admin can toggle customer status |

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

### Database Changes
- UPDATE `Customers` SET Status = 'Active'/'Inactive'

---

## 7. UI Requirements

- Show "Activate" button for inactive customers
- Show "Deactivate" button for active customers
- Display confirmation modal before status change
- Show warning if customer has pending orders
- Visual indicator for inactive customers (greyed out or badge)
- Use toast notification for success message
