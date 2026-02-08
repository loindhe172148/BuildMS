# UC-CAT-004: View Category List

## 1. Use Case Overview

| Field | Description |
|-------|-------------|
| **Use Case ID** | UC-CAT-004 |
| **Use Case Name** | View Category List |
| **Actor(s)** | Admin, Manager, Staff, Sales |
| **Description** | User views list of all product categories |
| **Trigger** | User navigates to category management section |
| **Pre-conditions** | - User is logged in |
| **Post-conditions** | - Category list is displayed |

---

## 2. Main Flow

| Step | Actor | System |
|------|-------|--------|
| 1 | User clicks "Categories" menu | System retrieves all categories |
| 2 | | System displays category list with columns: Name, Description, Product Count |
| 3 | User views category information | |
| 4 | User optionally clicks action buttons | System navigates to respective function |

---

## 3. Alternative Flows

### AF-1: No Categories Found
| Step | Description |
|------|-------------|
| 1a | System finds no categories in database |
| 1b | System displays message: "No categories found" |
| 1c | System shows "Add Category" button (Admin/Manager only) |

### AF-2: Search Categories
| Step | Description |
|------|-------------|
| 2a | User enters search term |
| 2b | System filters categories by name or description |
| 2c | System displays filtered results |

---

## 4. Business Rules

| Rule ID | Description |
|---------|-------------|
| BR-CAT-006 | All authenticated users can view categories |
| BR-CAT-007 | Only Admin/Manager can see add, edit, delete buttons |

---

## 5. Access Control

| Role | Access Level |
|------|--------------|
| Admin | Full access - view, add, edit, delete |
| Manager | Full access - view, add, edit, delete |
| Staff | View only |
| Sales | View only |

---

## 6. Data Requirements

### Display Fields
| Field | Description |
|-------|-------------|
| Name | Category name |
| Description | Category description |
| Product Count | Number of products in category |

---

## 7. UI Requirements

- Use table layout template from `template/html/tables-basic.html`
- Display categories in a data table
- Include search functionality
- Show "Add Category" button for Admin/Manager
- Show "Edit" and "Delete" action buttons for Admin/Manager
- Display product count for each category
- Support pagination if many categories exist
