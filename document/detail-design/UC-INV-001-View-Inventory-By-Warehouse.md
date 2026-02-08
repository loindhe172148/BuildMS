# UC-INV-001: View Inventory by Warehouse

## 1. Use Case Overview

| Field | Description |
|-------|-------------|
| **Use Case ID** | UC-INV-001 |
| **Use Case Name** | View Inventory by Warehouse |
| **Actor(s)** | Admin, Manager, Staff |
| **Description** | User views inventory grouped by warehouse |
| **Trigger** | User navigates to inventory section and selects warehouse view |
| **Pre-conditions** | - User is logged in with appropriate role |
| **Post-conditions** | - Inventory information is displayed |

---

## 2. Main Flow

| Step | Actor | System |
|------|-------|--------|
| 1 | User clicks "Inventory" menu | System displays inventory dashboard |
| 2 | User selects "By Warehouse" view | System loads warehouse list |
| 3 | User selects a warehouse | System retrieves inventory for that warehouse |
| 4 | | System displays inventory grouped by location |
| 5 | User views product quantities | |
| 6 | User optionally expands location details | System shows products at that location |

---

## 3. Alternative Flows

### AF-1: No Inventory
| Step | Description |
|------|-------------|
| 3a | Selected warehouse has no inventory |
| 3b | System displays message: "No inventory in this warehouse" |

### AF-2: Staff Warehouse Filter
| Step | Description |
|------|-------------|
| 2a | Staff user accesses inventory |
| 2b | System automatically filters to their assigned warehouse |
| 2c | Warehouse dropdown is hidden or disabled |

### AF-3: Search Within Warehouse
| Step | Description |
|------|-------------|
| 4a | User enters search term |
| 4b | System filters products by SKU or name |
| 4c | System displays matching inventory items |

---

## 4. Business Rules

| Rule ID | Description |
|---------|-------------|
| BR-INV-001 | Staff can only view inventory in their assigned warehouse |
| BR-INV-002 | Admin and Manager can view all warehouses |
| BR-INV-003 | Sales cannot view inventory |

---

## 5. Access Control

| Role | Access Level |
|------|--------------|
| Admin | Full access - view all warehouses |
| Manager | Full access - view all warehouses |
| Staff | View only - limited to assigned warehouse |
| Sales | No access |

---

## 6. Data Requirements

### Display Fields
| Field | Description |
|-------|-------------|
| Warehouse Name | Parent warehouse |
| Location Code | Bin/location identifier |
| Product SKU | Product code |
| Product Name | Product description |
| Quantity | Current stock level |
| Unit | Unit of measure |

### Summary Information
| Field | Description |
|-------|-------------|
| Total Products | Distinct products in warehouse |
| Total Quantity | Sum of all quantities |
| Location Count | Number of locations with stock |

---

## 7. UI Requirements

- Warehouse dropdown filter (disabled for Staff)
- Collapsible location sections
- Product table within each location
- Search box for SKU/product name
- Show warehouse summary statistics
- Color coding for low stock (optional enhancement)
- Export to CSV/Excel option (optional)
