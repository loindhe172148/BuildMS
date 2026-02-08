# UC-LOC-003: Toggle Location Status

## 1. Use Case Overview

| Field | Description |
|-------|-------------|
| **Use Case ID** | UC-LOC-003 |
| **Use Case Name** | Toggle Location Status |
| **Actor(s)** | Admin, Manager |
| **Description** | User activates or deactivates a storage location |
| **Trigger** | User clicks "Activate" or "Deactivate" button on a location |
| **Pre-conditions** | - User is logged in with Admin/Manager role<br>- Location exists in the system |
| **Post-conditions** | - Location status is toggled (Active ↔ Inactive) |

---

## 2. Main Flow

| Step | Actor | System |
|------|-------|--------|
| 1 | User clicks "Deactivate" on an active location | System checks for existing inventory |
| 2 | | System confirms no inventory exists at location |
| 3 | | System displays confirmation dialog |
| 4 | User confirms action | System updates IsActive to false |
| 5 | | System displays success message |
| 6 | | System refreshes location list |

---

## 3. Alternative Flows

### AF-1: Location Has Inventory (Deactivation)
| Step | Description |
|------|-------------|
| 2a | System detects inventory exists at location |
| 2b | System displays error: "Cannot deactivate location with existing inventory. Please move inventory first." |
| 2c | Operation is cancelled |

### AF-2: Activate Location
| Step | Description |
|------|-------------|
| 1a | User clicks "Activate" on an inactive location |
| 1b | System displays confirmation dialog |
| 1c | User confirms action |
| 1d | System updates IsActive to true |
| 1e | System displays success message |

### AF-3: Cancel Confirmation
| Step | Description |
|------|-------------|
| 4a | User clicks "Cancel" in confirmation dialog |
| 4b | System closes dialog, no changes made |

---

## 4. Business Rules

| Rule ID | Description |
|---------|-------------|
| BR-LOC-006 | Cannot deactivate location with existing inventory |
| BR-LOC-007 | Inactive locations cannot receive new inventory |
| BR-LOC-008 | Inactive locations are excluded from inventory placement options |

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

### Validation Checks
| Check | Query |
|-------|-------|
| Has Inventory | SELECT COUNT(*) FROM Inventory WHERE LocationId = ? AND Quantity > 0 |

### Database Changes
- UPDATE `Locations` SET IsActive = true/false

---

## 7. UI Requirements

- Show "Activate" button for inactive locations
- Show "Deactivate" button for active locations
- Display confirmation modal before status change
- Show clear error message if deactivation fails
- Use toast notification for success message
