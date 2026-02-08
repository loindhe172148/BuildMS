# UC-PRD-005: View Product Details

## 1. Use Case Overview

| Field | Description |
|-------|-------------|
| **Use Case ID** | UC-PRD-005 |
| **Use Case Name** | View Product Details |
| **Actor(s)** | Admin, Manager, Staff, Sales |
| **Description** | User views detailed information about a specific product including inventory |
| **Trigger** | User clicks on a product from the list or navigates directly |
| **Pre-conditions** | - User is logged in<br>- Product exists in the system |
| **Post-conditions** | - Product details are displayed |

---

## 2. Main Flow

| Step | Actor | System |
|------|-------|--------|
| 1 | User clicks on a product | System retrieves product data |
| 2 | | System retrieves inventory data for this product |
| 3 | | System displays product details page |
| 4 | User views product information | |
| 5 | User views inventory by warehouse/location | |
| 6 | User optionally clicks "Edit" | System navigates to edit form |

---

## 3. Alternative Flows

### AF-1: Product Not Found
| Step | Description |
|------|-------------|
| 1a | System cannot find the product |
| 1b | System displays error: "Product not found" |
| 1c | System redirects to product list |

### AF-2: No Inventory
| Step | Description |
|------|-------------|
| 2a | Product has no inventory records |
| 2b | System displays "No inventory for this product" |
| 2c | System shows inventory section as empty |

---

## 4. Business Rules

| Rule ID | Description |
|---------|-------------|
| BR-PRD-012 | All authenticated users can view product details |
| BR-PRD-013 | Sales role cannot see inventory information |
| BR-PRD-014 | Only Admin/Manager can see "Edit" button |

---

## 5. Access Control

| Role | Access Level |
|------|--------------|
| Admin | Full access - view all details including inventory |
| Manager | Full access - view all details including inventory |
| Staff | View product info and inventory (limited to assigned warehouse) |
| Sales | View product info only (no inventory) |

---

## 6. Data Requirements

### Product Information
| Field | Description |
|-------|-------------|
| SKU | Product SKU/code |
| Name | Product name |
| Category | Category name |
| Unit | Unit of measure |
| Status | Active or Inactive |
| Created Date | When product was created |

### Inventory Information (Admin/Manager/Staff only)
| Field | Description |
|-------|-------------|
| Warehouse | Warehouse name |
| Location | Location code |
| Quantity | Current quantity at location |
| Total | Total quantity across all locations |

---

## 7. UI Requirements

- Use card layout for product information
- Display inventory in a table grouped by warehouse
- Show total quantity prominently
- Include "Edit" button for Admin/Manager
- Include "Back to List" navigation
- Show product status with visual indicator (badge)
- For Staff: only show inventory for their assigned warehouse
- For Sales: hide inventory section entirely
