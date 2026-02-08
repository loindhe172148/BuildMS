# UC-CAT-003: Delete Category

## 1. Use Case Overview

| Field | Description |
|-------|-------------|
| **Use Case ID** | UC-CAT-003 |
| **Use Case Name** | Delete Category |
| **Actor(s)** | Admin, Manager |
| **Description** | User deletes an unused category from the system |
| **Trigger** | User clicks "Delete" on a category from the list |
| **Pre-conditions** | - User is logged in with Admin/Manager role<br>- Category exists in the system<br>- Category has no associated products |
| **Post-conditions** | - Category is permanently deleted from the system |

---

## 2. Main Flow

| Step | Actor | System |
|------|-------|--------|
| 1 | User clicks "Delete" on a category | System checks for associated products |
| 2 | | System confirms no products use this category |
| 3 | | System displays confirmation dialog |
| 4 | User confirms deletion | System deletes category record |
| 5 | | System displays success message |
| 6 | | System refreshes category list |

---

## 3. Alternative Flows

### AF-1: Category Has Products
| Step | Description |
|------|-------------|
| 2a | System detects products are associated with category |
| 2b | System displays error: "Cannot delete category with associated products. Please reassign or remove products first." |
| 2c | System shows count of associated products |
| 2d | Operation is cancelled |

### AF-2: Cancel Confirmation
| Step | Description |
|------|-------------|
| 4a | User clicks "Cancel" in confirmation dialog |
| 4b | System closes dialog, no changes made |

### AF-3: Category Not Found
| Step | Description |
|------|-------------|
| 1a | System cannot find the category |
| 1b | System displays error: "Category not found" |
| 1c | System refreshes category list |

---

## 4. Business Rules

| Rule ID | Description |
|---------|-------------|
| BR-CAT-004 | Cannot delete category with associated products |
| BR-CAT-005 | Deletion is permanent and cannot be undone |

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

### Validation Checks
| Check | Query |
|-------|-------|
| Has Products | SELECT COUNT(*) FROM Products WHERE CategoryId = ? |

### Database Changes
- DELETE from `Categories` table

---

## 7. UI Requirements

- Show "Delete" button only for categories without products
- Or show disabled "Delete" button with tooltip explaining why
- Display confirmation modal with category name
- Show warning that deletion is permanent
- Use toast notification for success/error messages
