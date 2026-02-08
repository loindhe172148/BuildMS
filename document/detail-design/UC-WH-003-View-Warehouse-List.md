# UC-WH-003: View Warehouse List

## 1. Use Case Overview

| Field | Description |
|-------|-------------|
| **Use Case ID** | UC-WH-003 |
| **Use Case Name** | View Warehouse List |
| **Actor(s)** | Admin, Manager |
| **Description** | User views list of all warehouses in the system |
| **Trigger** | User navigates to warehouse management section |
| **Pre-conditions** | - User is logged in<br>- User has appropriate role |
| **Post-conditions** | - Warehouse list is displayed |

---

## 2. Main Flow

| Step | Actor | System |
|------|-------|--------|
| 1 | User clicks "Warehouses" menu | System retrieves all warehouses |
| 2 | | System displays warehouse list with columns: Name, Location, Created Date |
| 3 | User views warehouse information | |
| 4 | User optionally clicks "Edit" or "View Locations" | System navigates to respective page |

---

## 3. Alternative Flows

### AF-1: No Warehouses Found
| Step | Description |
|------|-------------|
| 1a | System finds no warehouses in database |
| 1b | System displays message: "No warehouses found" |
| 1c | System shows "Add Warehouse" button (Admin only) |

### AF-2: Search/Filter
| Step | Description |
|------|-------------|
| 2a | User enters search term |
| 2b | System filters warehouses by name or location |
| 2c | System displays filtered results |

---

## 4. Business Rules

| Rule ID | Description |
|---------|-------------|
| BR-WH-005 | All users with warehouse access can view the list |
| BR-WH-006 | Only Admin can see "Add" and "Edit" buttons |

---

## 5. Access Control

| Role | Access Level |
|------|--------------|
| Admin | Full access - view, add, edit |
| Manager | View only |
| Staff | No access |
| Sales | No access |

---

## 6. Data Requirements

### Display Fields
| Field | Description |
|-------|-------------|
| Name | Warehouse name |
| Location | Warehouse address/location |
| Created Date | When warehouse was created |
| Location Count | Number of locations in warehouse |

---

## 7. UI Requirements

- Use table layout template from `template/html/tables-basic.html`
- Display warehouses in a data table
- Include search/filter functionality
- Show "Add Warehouse" button for Admin
- Show "Edit" and "View Locations" action buttons
- Support pagination if many warehouses exist
