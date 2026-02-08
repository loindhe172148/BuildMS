# UC-LOC-002: Update Location

## 1. Use Case Overview

| Field | Description |
|-------|-------------|
| **Use Case ID** | UC-LOC-002 |
| **Use Case Name** | Update Location |
| **Actor(s)** | Admin, Manager |
| **Description** | User updates an existing location's information |
| **Trigger** | User clicks "Edit" on a location from the list |
| **Pre-conditions** | - User is logged in with Admin/Manager role<br>- Location exists in the system |
| **Post-conditions** | - Location information is updated |

---

## 2. Main Flow

| Step | Actor | System |
|------|-------|--------|
| 1 | User clicks "Edit" on a location | System retrieves location data |
| 2 | | System displays edit form with current values |
| 3 | User modifies location code | System validates code format |
| 4 | User modifies location type | System validates type selection |
| 5 | User clicks "Save" | System validates all fields |
| 6 | | System updates location record |
| 7 | | System displays success message |
| 8 | | System redirects to location list |

---

## 3. Alternative Flows

### AF-1: Location Not Found
| Step | Description |
|------|-------------|
| 1a | System cannot find the location |
| 1b | System displays error: "Location not found" |
| 1c | System redirects to location list |

### AF-2: Duplicate Location Code
| Step | Description |
|------|-------------|
| 5a | System detects another location has the same code in the warehouse |
| 5b | System displays error: "Location code already exists in this warehouse" |
| 5c | User corrects the code and resubmits |

### AF-3: Cancel Operation
| Step | Description |
|------|-------------|
| 3a | User clicks "Cancel" |
| 3b | System redirects to location list without saving |

---

## 4. Business Rules

| Rule ID | Description |
|---------|-------------|
| BR-LOC-001 | Location code must be unique within a warehouse |
| BR-LOC-002 | Location code is required |
| BR-LOC-003 | Location type must be one of: Storage, Picking, Staging |
| BR-LOC-005 | Warehouse assignment cannot be changed after creation |

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

### Input Fields
| Field | Type | Required | Validation |
|-------|------|----------|------------|
| Code | String (100) | Yes | Not empty, unique per warehouse |
| Type | String (50) | Yes | Must be: Storage, Picking, or Staging |

### Read-Only Fields
| Field | Description |
|-------|-------------|
| WarehouseId | Cannot be changed after creation |
| Warehouse Name | Displayed for reference |

### Database Changes
- UPDATE `Locations` table

---

## 7. UI Requirements

- Use form layout template from `template/html/form-layouts-vertical.html`
- Display warehouse name as read-only field
- Pre-populate form with existing location data
- Display validation errors inline
- Include "Save" and "Cancel" buttons
