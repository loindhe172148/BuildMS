# UC-USER-005: Assign User to Warehouse

## 1. Use Case Overview

| Field | Description |
|-------|-------------|
| **Use Case ID** | UC-USER-005 |
| **Use Case Name** | Assign User to Warehouse |
| **Actor(s)** | Admin |
| **Description** | Admin assigns or changes a user's warehouse assignment |
| **Trigger** | Admin edits user or uses warehouse assignment action |
| **Pre-conditions** | - Admin is logged in<br>- User exists in the system<br>- Warehouse exists in the system |
| **Post-conditions** | - User is assigned to the selected warehouse |

---

## 2. Main Flow

| Step | Actor | System |
|------|-------|--------|
| 1 | Admin clicks "Assign Warehouse" on a user | System retrieves current assignment |
| 2 | | System displays warehouse selection dialog |
| 3 | Admin selects warehouse from dropdown | System validates selection |
| 4 | Admin clicks "Assign" | System updates user's WarehouseId |
| 5 | | System displays success message |
| 6 | | System refreshes user list |

---

## 3. Alternative Flows

### AF-1: Remove Warehouse Assignment
| Step | Description |
|------|-------------|
| 3a | Admin selects "None" or clears warehouse |
| 3b | Admin clicks "Assign" |
| 3c | System sets WarehouseId to NULL |
| 3d | System displays success message |

### AF-2: Via User Edit Form
| Step | Description |
|------|-------------|
| 1a | Admin edits user and changes warehouse field |
| 1b | Follows UC-USER-002 main flow |
| 1c | Warehouse assignment is updated with other changes |

### AF-3: Cancel Operation
| Step | Description |
|------|-------------|
| 3a | Admin clicks "Cancel" |
| 3b | System closes dialog, no changes made |

---

## 4. Business Rules

| Rule ID | Description |
|---------|-------------|
| BR-USER-015 | Staff and Manager roles should have warehouse assignment |
| BR-USER-016 | Admin and Sales roles typically don't need warehouse assignment |
| BR-USER-017 | User can only be assigned to one warehouse at a time |
| BR-USER-018 | Warehouse assignment affects which inventory Staff can see/manage |

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
| WarehouseId | Long | No | Must exist in Warehouses table if provided |

### Database Changes
- UPDATE `Users` SET WarehouseId = ?

---

## 7. UI Requirements

- Can be done via quick-action button in user list
- Or via warehouse dropdown in user edit form
- Show current warehouse assignment
- Warehouse dropdown with all active warehouses
- Include "None" option to clear assignment
- Display success notification after assignment
