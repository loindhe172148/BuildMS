# UC-PRD-004: View Product List

## 1. Use Case Overview

| Field | Description |
|-------|-------------|
| **Use Case ID** | UC-PRD-004 |
| **Use Case Name** | View Product List |
| **Actor(s)** | Admin, Manager, Staff, Sales |
| **Description** | User views list of all products with filtering options |
| **Trigger** | User navigates to product management section |
| **Pre-conditions** | - User is logged in |
| **Post-conditions** | - Product list is displayed |

---

## 2. Main Flow

| Step | Actor | System |
|------|-------|--------|
| 1 | User clicks "Products" menu | System retrieves all products |
| 2 | | System displays product list with columns: SKU, Name, Category, Unit, Status |
| 3 | User optionally applies filters | System filters the list |
| 4 | User views product information | |
| 5 | User optionally clicks on a product | System shows product details |

---

## 3. Alternative Flows

### AF-1: No Products Found
| Step | Description |
|------|-------------|
| 1a | System finds no products in database |
| 1b | System displays message: "No products found" |
| 1c | System shows "Add Product" button (Admin/Manager only) |

### AF-2: Filter by Category
| Step | Description |
|------|-------------|
| 3a | User selects a category from dropdown |
| 3b | System filters to show only products in that category |
| 3c | System updates the displayed list |

### AF-3: Filter by Status
| Step | Description |
|------|-------------|
| 3a | User selects status filter (Active/Inactive/All) |
| 3b | System filters products by status |
| 3c | System updates the displayed list |

### AF-4: Search by SKU or Name
| Step | Description |
|------|-------------|
| 3a | User enters search term |
| 3b | System searches products by SKU or name |
| 3c | System displays matching products |

---

## 4. Business Rules

| Rule ID | Description |
|---------|-------------|
| BR-PRD-009 | All authenticated users can view products |
| BR-PRD-010 | Only Admin/Manager can see add, edit, status toggle buttons |
| BR-PRD-011 | Staff and Sales have read-only access |

---

## 5. Access Control

| Role | Access Level |
|------|--------------|
| Admin | Full access - view, add, edit, toggle status |
| Manager | Full access - view, add, edit, toggle status |
| Staff | View only |
| Sales | View only |

---

## 6. Data Requirements

### Display Fields
| Field | Description |
|-------|-------------|
| SKU | Product SKU/code |
| Name | Product name |
| Category | Category name |
| Unit | Unit of measure |
| Status | Active or Inactive |
| Total Stock | Sum of inventory across all locations |

---

## 7. UI Requirements

- Use table layout template from `template/html/tables-basic.html`
- Display products in a data table
- Include search box for SKU/name
- Include category dropdown filter
- Include status filter (Active/Inactive/All)
- Show "Add Product" button for Admin/Manager
- Show "Edit" and status toggle action buttons for Admin/Manager
- Support pagination
- Click on product row to view details
