# UC-PRD-003: Toggle Product Status

## 1. Use Case Overview

| Field | Description |
|-------|-------------|
| **Use Case ID** | UC-PRD-003 |
| **Use Case Name** | Toggle Product Status |
| **Actor(s)** | Admin, Manager |
| **Description** | User activates or deactivates a product |
| **Trigger** | User clicks "Activate" or "Deactivate" button on a product |
| **Pre-conditions** | - User is logged in with Admin/Manager role<br>- Product exists in the system |
| **Post-conditions** | - Product status is toggled (Active ↔ Inactive) |

---

## 2. Main Flow

| Step | Actor | System |
|------|-------|--------|
| 1 | User clicks "Deactivate" on an active product | System displays confirmation dialog |
| 2 | User confirms action | System updates IsActive to false |
| 3 | | System displays success message |
| 4 | | System refreshes product list |

---

## 3. Alternative Flows

### AF-1: Activate Product
| Step | Description |
|------|-------------|
| 1a | User clicks "Activate" on an inactive product |
| 1b | System displays confirmation dialog |
| 1c | User confirms action |
| 1d | System updates IsActive to true |
| 1e | System displays success message |

### AF-2: Product Has Pending Orders (Deactivation Warning)
| Step | Description |
|------|-------------|
| 1a | System detects product is in pending sales orders |
| 1b | System displays warning: "This product has pending orders. Deactivating will prevent new orders only." |
| 1c | User can still proceed with deactivation |

### AF-3: Cancel Confirmation
| Step | Description |
|------|-------------|
| 2a | User clicks "Cancel" in confirmation dialog |
| 2b | System closes dialog, no changes made |

---

## 4. Business Rules

| Rule ID | Description |
|---------|-------------|
| BR-PRD-006 | Inactive products cannot be added to new orders or requests |
| BR-PRD-007 | Inactive products remain in existing inventory until consumed |
| BR-PRD-008 | Existing orders with inactive products can still be processed |

---

## 5. Access Control

| Role | Access Level |
|------|--------------|
| Admin | Full access |
| Manager | Full access |
| Staff | No access |
| Sales | No access |

---

## 6. Data Requirements

### Database Changes
- UPDATE `Products` SET IsActive = true/false

---

## 7. UI Requirements

- Show "Activate" button for inactive products
- Show "Deactivate" button for active products
- Display confirmation modal before status change
- Show warning if product has pending orders
- Visual indicator for inactive products in list (greyed out or badge)
- Use toast notification for success message
