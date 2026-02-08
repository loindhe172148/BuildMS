# UC-CAT-002: Update Category

## 1. Use Case Overview

| Field | Description |
|-------|-------------|
| **Use Case ID** | UC-CAT-002 |
| **Use Case Name** | Update Category |
| **Actor(s)** | Admin, Manager |
| **Description** | User updates an existing category's information |
| **Trigger** | User clicks "Edit" on a category from the list |
| **Pre-conditions** | - User is logged in with Admin/Manager role<br>- Category exists in the system |
| **Post-conditions** | - Category information is updated |

---

## 2. Main Flow

| Step | Actor | System |
|------|-------|--------|
| 1 | User clicks "Edit" on a category | System retrieves category data |
| 2 | | System displays edit form with current values |
| 3 | User modifies category name | System validates input |
| 4 | User modifies category description | System accepts input |
| 5 | User clicks "Save" | System validates all fields |
| 6 | | System updates category record |
| 7 | | System displays success message |
| 8 | | System redirects to category list |

---

## 3. Alternative Flows

### AF-1: Category Not Found
| Step | Description |
|------|-------------|
| 1a | System cannot find the category |
| 1b | System displays error: "Category not found" |
| 1c | System redirects to category list |

### AF-2: Duplicate Category Name
| Step | Description |
|------|-------------|
| 5a | System detects another category has the same name |
| 5b | System displays error: "Category name already exists" |
| 5c | User corrects the name and resubmits |

### AF-3: Cancel Operation
| Step | Description |
|------|-------------|
| 3a | User clicks "Cancel" |
| 3b | System redirects to category list without saving |

---

## 4. Business Rules

| Rule ID | Description |
|---------|-------------|
| BR-CAT-001 | Category name must be unique |
| BR-CAT-002 | Category name is required |

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

### Input Fields
| Field | Type | Required | Validation |
|-------|------|----------|------------|
| Name | String (255) | Yes | Not empty, unique |
| Description | String (500) | No | None |

### Database Changes
- UPDATE `Categories` table

---

## 7. UI Requirements

- Use form layout template from `template/html/form-layouts-vertical.html`
- Pre-populate form with existing category data
- Display validation errors inline
- Include "Save" and "Cancel" buttons
