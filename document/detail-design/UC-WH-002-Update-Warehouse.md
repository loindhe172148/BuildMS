# UC-WH-002: Update Warehouse

## 1. Use Case Overview

| Field | Description |
|-------|-------------|
| **Use Case ID** | UC-WH-002 |
| **Use Case Name** | Update Warehouse |
| **Actor(s)** | Admin |
| **Description** | Admin updates an existing warehouse's information |
| **Trigger** | Admin clicks "Edit" on a warehouse from the list |
| **Pre-conditions** | - Admin is logged in<br>- Warehouse exists in the system |
| **Post-conditions** | - Warehouse information is updated |

---

## 2. Main Flow

| Step | Actor | System |
|------|-------|--------|
| 1 | Admin clicks "Edit" on a warehouse | System retrieves warehouse data |
| 2 | | System displays edit form with current values |
| 3 | Admin modifies warehouse name | System validates input |
| 4 | Admin modifies warehouse location | System validates input |
| 5 | Admin clicks "Save" | System validates all fields |
| 6 | | System updates warehouse record |
| 7 | | System displays success message |
| 8 | | System redirects to warehouse list |

---

## 3. Alternative Flows

### AF-1: Warehouse Not Found
| Step | Description |
|------|-------------|
| 1a | System cannot find the warehouse |
| 1b | System displays error: "Warehouse not found" |
| 1c | System redirects to warehouse list |

### AF-2: Duplicate Warehouse Name
| Step | Description |
|------|-------------|
| 5a | System detects another warehouse has the same name |
| 5b | System displays error: "Warehouse name already exists" |
| 5c | Admin corrects the name and resubmits |

### AF-3: Cancel Operation
| Step | Description |
|------|-------------|
| 3a | Admin clicks "Cancel" |
| 3b | System redirects to warehouse list without saving |

---

## 4. Business Rules

| Rule ID | Description |
|---------|-------------|
| BR-WH-001 | Warehouse name must be unique |
| BR-WH-002 | Warehouse name is required |
| BR-WH-004 | Cannot delete warehouse with existing locations or inventory |

---

## 5. Access Control

| Role | Access Level |
|------|--------------|
| Admin | Full access - can update warehouses |
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
- UPDATE `Warehouses` table

---

## 7. UI Requirements

- Use form layout template from `template/html/form-layouts-vertical.html`
- Pre-populate form with existing warehouse data
- Display validation errors inline
- Include "Save" and "Cancel" buttons
