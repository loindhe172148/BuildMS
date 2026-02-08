# UC-INV-002: View Inventory by Product

## 1. Use Case Overview

| Field | Description |
|-------|-------------|
| **Use Case ID** | UC-INV-002 |
| **Use Case Name** | View Inventory by Product |
| **Actor(s)** | Admin, Manager, Staff |
| **Description** | User views inventory for a specific product across all locations |
| **Trigger** | User navigates to inventory section and selects product view |
| **Pre-conditions** | - User is logged in with appropriate role<br>- Product exists in the system |
| **Post-conditions** | - Product inventory information is displayed |

---

## 2. Main Flow

| Step | Actor | System |
|------|-------|--------|
| 1 | User clicks "Inventory" menu | System displays inventory dashboard |
| 2 | User selects "By Product" view | System loads product search |
| 3 | User searches for a product | System displays matching products |
| 4 | User selects a product | System retrieves inventory for that product |
| 5 | | System displays inventory grouped by warehouse/location |
| 6 | User views quantities at each location | |

---

## 3. Alternative Flows

### AF-1: Product Has No Inventory
| Step | Description |
|------|-------------|
| 4a | Selected product has no inventory |
| 4b | System displays message: "No inventory for this product" |
| 4c | System shows product details without inventory table |

### AF-2: Staff Warehouse Filter
| Step | Description |
|------|-------------|
| 5a | Staff user views product inventory |
| 5b | System filters to only show inventory in their assigned warehouse |
| 5c | Other warehouse locations are hidden |

### AF-3: Direct Product Access
| Step | Description |
|------|-------------|
| 1a | User clicks on product from product list |
| 1b | System navigates directly to product inventory view |
| 1c | Continue from step 4 |

---

## 4. Business Rules

| Rule ID | Description |
|---------|-------------|
| BR-INV-001 | Staff can only view inventory in their assigned warehouse |
| BR-INV-002 | Admin and Manager can view all warehouses |
| BR-INV-004 | Total quantity is sum across all visible locations |

---

## 5. Access Control

| Role | Access Level |
|------|--------------|
| Admin | Full access - view all locations |
| Manager | Full access - view all locations |
| Staff | View only - limited to assigned warehouse |
| Sales | No access |

---

## 6. Data Requirements

### Product Information
| Field | Description |
|-------|-------------|
| SKU | Product code |
| Name | Product name |
| Category | Product category |
| Unit | Unit of measure |
| Status | Active/Inactive |

### Inventory Table
| Field | Description |
|-------|-------------|
| Warehouse | Warehouse name |
| Location | Location code |
| Quantity | Current stock level |

### Summary
| Field | Description |
|-------|-------------|
| Total Quantity | Sum across all locations |
| Location Count | Number of locations holding this product |
| Warehouse Count | Number of warehouses with stock |

---

## 7. UI Requirements

- Product search autocomplete
- Display product header with details
- Inventory table grouped by warehouse
- Show total quantity prominently
- Back to search navigation
- Link to product details page
- For Staff: only show inventory in assigned warehouse
