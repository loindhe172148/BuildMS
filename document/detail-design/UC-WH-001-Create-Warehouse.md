# UC-WH-001: Create Warehouse

## 1. Use Case Overview

| Field | Description |
|-------|-------------|
| **Use Case ID** | UC-WH-001 |
| **Use Case Name** | Create Warehouse |
| **Actor(s)** | Admin |
| **Description** | Admin creates a new warehouse facility in the system |
| **Trigger** | Admin navigates to warehouse management and clicks "Add Warehouse" |
| **Pre-conditions** | - Admin is logged in<br>- Admin has access to warehouse management |
| **Post-conditions** | - New warehouse is created in the system<br>- Warehouse is available for location and inventory management |

---

## 2. Main Flow

| Step | Actor | System |
|------|-------|--------|
| 1 | Admin clicks "Add Warehouse" button | System displays warehouse creation form |
| 2 | Admin enters warehouse name | System validates input is not empty |
| 3 | Admin enters warehouse location/address | System validates input |
| 4 | Admin clicks "Save" | System validates all fields |
| 5 | | System creates warehouse record |
| 6 | | System displays success message |
| 7 | | System redirects to warehouse list |

---

## 3. Alternative Flows

### AF-1: Duplicate Warehouse Name
| Step | Description |
|------|-------------|
| 4a | System detects warehouse name already exists |
| 4b | System displays error: "Warehouse name already exists" |
| 4c | Admin corrects the name and resubmits |

### AF-2: Empty Required Fields
| Step | Description |
|------|-------------|
| 4a | System detects empty required fields |
| 4b | System displays error: "Warehouse name is required" |
| 4c | Admin fills in required fields and resubmits |

### AF-3: Cancel Operation
| Step | Description |
|------|-------------|
| 2a | Admin clicks "Cancel" |
| 2b | System redirects to warehouse list without saving |

---

## 4. Business Rules

| Rule ID | Description |
|---------|-------------|
| BR-WH-001 | Warehouse name must be unique |
| BR-WH-002 | Warehouse name is required (cannot be empty) |
| BR-WH-003 | Location field is optional but recommended |

---

## 5. Access Control

| Role | Access Level |
|------|--------------|
| Admin | Full access - can create warehouses |
| Manager | No access |
| Staff | No access |
| Sales | No access |

---

## 6. Data Requirements

### Input Fields
| Field | Type | Required | Validation |
|-------|------|----------|------------|
| Name | String (255) | Yes | Not empty, unique |
| Location | String (255) | No | None |

### Database Changes
- INSERT into `Warehouses` table

---

## 7. UI Requirements

- Use form layout template from `template/html/form-layouts-vertical.html`
- Display validation errors inline
- Include "Save" and "Cancel" buttons
- Show success toast notification after creation
