# UC-LOC-004: View Location List

## 1. Use Case Overview

| Field | Description |
|-------|-------------|
| **Use Case ID** | UC-LOC-004 |
| **Use Case Name** | View Location List |
| **Actor(s)** | Admin, Manager, Staff |
| **Description** | User views list of locations, optionally filtered by warehouse |
| **Trigger** | User navigates to location management section |
| **Pre-conditions** | - User is logged in with appropriate role |
| **Post-conditions** | - Location list is displayed |

---

## 2. Main Flow

| Step | Actor | System |
|------|-------|--------|
| 1 | User clicks "Locations" menu | System retrieves all locations |
| 2 | | System displays location list with columns: Code, Warehouse, Type, Status |
| 3 | User optionally selects warehouse filter | System filters locations by selected warehouse |
| 4 | User views location information | |
| 5 | User optionally clicks action buttons | System navigates to respective function |

---

## 3. Alternative Flows

### AF-1: No Locations Found
| Step | Description |
|------|-------------|
| 1a | System finds no locations in database |
| 1b | System displays message: "No locations found" |
| 1c | System shows "Add Location" button (Admin/Manager only) |

### AF-2: Filter by Warehouse
| Step | Description |
|------|-------------|
| 3a | User selects a warehouse from dropdown |
| 3b | System filters to show only locations in that warehouse |
| 3c | System updates the displayed list |

### AF-3: Filter by Status
| Step | Description |
|------|-------------|
| 3a | User selects status filter (Active/Inactive/All) |
| 3b | System filters locations by status |
| 3c | System updates the displayed list |

### AF-4: Filter by Type
| Step | Description |
|------|-------------|
| 3a | User selects type filter (Storage/Picking/Staging/All) |
| 3b | System filters locations by type |
| 3c | System updates the displayed list |

---

## 4. Business Rules

| Rule ID | Description |
|---------|-------------|
| BR-LOC-009 | Staff can only view locations in their assigned warehouse |
| BR-LOC-010 | Admin and Manager can view all locations |

---

## 5. Access Control

| Role | Access Level |
|------|--------------|
| Admin | Full access - view all, add, edit, toggle status |
| Manager | Full access - view all, add, edit, toggle status |
| Staff | View only - limited to assigned warehouse |
| Sales | No access |

---

## 6. Data Requirements

### Display Fields
| Field | Description |
|-------|-------------|
| Code | Location code/identifier |
| Warehouse | Parent warehouse name |
| Type | Storage, Picking, or Staging |
| Status | Active or Inactive |
| Inventory Count | Number of products at this location |

---

## 7. UI Requirements

- Use table layout template from `template/html/tables-basic.html`
- Display locations in a data table
- Include warehouse dropdown filter
- Include type filter dropdown
- Include status filter (Active/Inactive/All)
- Show "Add Location" button for Admin/Manager
- Show "Edit" and status toggle action buttons
- Visual indicator for inactive locations (greyed out or badge)
- Support pagination
