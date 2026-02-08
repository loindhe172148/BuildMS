# UC-LOC-001: Create Location

## 1. Use Case Overview

| Field | Description |
|-------|-------------|
| **Use Case ID** | UC-LOC-001 |
| **Use Case Name** | Create Location |
| **Actor(s)** | Admin, Manager |
| **Description** | User creates a new storage location (bin) within a warehouse |
| **Trigger** | User navigates to location management and clicks "Add Location" |
| **Pre-conditions** | - User is logged in with Admin/Manager role<br>- At least one warehouse exists |
| **Post-conditions** | - New location is created<br>- Location is available for inventory placement |

---

## 2. Main Flow

| Step | Actor | System |
|------|-------|--------|
| 1 | User clicks "Add Location" button | System displays location creation form |
| 2 | User selects warehouse | System loads warehouse dropdown |
| 3 | User enters location code | System validates code format |
| 4 | User selects location type | System provides options: Storage, Picking, Staging |
| 5 | User clicks "Save" | System validates all fields |
| 6 | | System creates location record with IsActive = true |
| 7 | | System displays success message |
| 8 | | System redirects to location list |

---

## 3. Alternative Flows

### AF-1: Duplicate Location Code
| Step | Description |
|------|-------------|
| 5a | System detects location code already exists in the warehouse |
| 5b | System displays error: "Location code already exists in this warehouse" |
| 5c | User corrects the code and resubmits |

### AF-2: No Warehouses Available
| Step | Description |
|------|-------------|
| 1a | System finds no warehouses in the system |
| 1b | System displays message: "Please create a warehouse first" |
| 1c | System provides link to warehouse creation |

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
| BR-LOC-004 | New locations are active by default |

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
| WarehouseId | Long | Yes | Must exist in Warehouses table |
| Code | String (100) | Yes | Not empty, unique per warehouse |
| Type | String (50) | Yes | Must be: Storage, Picking, or Staging |

### Database Changes
- INSERT into `Locations` table

---

## 7. UI Requirements

- Use form layout template from `template/html/form-layouts-vertical.html`
- Warehouse dropdown pre-populated with all warehouses
- Location type as radio buttons or dropdown
- Display validation errors inline
- Include "Save" and "Cancel" buttons
