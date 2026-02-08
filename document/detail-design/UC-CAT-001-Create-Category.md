# UC-CAT-001: Create Category

## 1. Use Case Overview

| Field | Description |
|-------|-------------|
| **Use Case ID** | UC-CAT-001 |
| **Use Case Name** | Create Category |
| **Actor(s)** | Admin, Manager |
| **Description** | User creates a new product category |
| **Trigger** | User navigates to category management and clicks "Add Category" |
| **Pre-conditions** | - User is logged in with Admin/Manager role |
| **Post-conditions** | - New category is created<br>- Category is available for product assignment |

---

## 2. Main Flow

| Step | Actor | System |
|------|-------|--------|
| 1 | User clicks "Add Category" button | System displays category creation form |
| 2 | User enters category name | System validates input is not empty |
| 3 | User enters category description (optional) | System accepts input |
| 4 | User clicks "Save" | System validates all fields |
| 5 | | System creates category record |
| 6 | | System displays success message |
| 7 | | System redirects to category list |

---

## 3. Alternative Flows

### AF-1: Duplicate Category Name
| Step | Description |
|------|-------------|
| 4a | System detects category name already exists |
| 4b | System displays error: "Category name already exists" |
| 4c | User corrects the name and resubmits |

### AF-2: Empty Required Fields
| Step | Description |
|------|-------------|
| 4a | System detects empty category name |
| 4b | System displays error: "Category name is required" |
| 4c | User fills in required field and resubmits |

### AF-3: Cancel Operation
| Step | Description |
|------|-------------|
| 2a | User clicks "Cancel" |
| 2b | System redirects to category list without saving |

---

## 4. Business Rules

| Rule ID | Description |
|---------|-------------|
| BR-CAT-001 | Category name must be unique |
| BR-CAT-002 | Category name is required |
| BR-CAT-003 | Description is optional |

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
- INSERT into `Categories` table

---

## 7. UI Requirements

- Use form layout template from `template/html/form-layouts-vertical.html`
- Simple form with name and description fields
- Description field as textarea
- Display validation errors inline
- Include "Save" and "Cancel" buttons
