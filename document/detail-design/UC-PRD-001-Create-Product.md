# UC-PRD-001: Create Product

## 1. Use Case Overview

| Field | Description |
|-------|-------------|
| **Use Case ID** | UC-PRD-001 |
| **Use Case Name** | Create Product |
| **Actor(s)** | Admin, Manager |
| **Description** | User creates a new product in the system |
| **Trigger** | User navigates to product management and clicks "Add Product" |
| **Pre-conditions** | - User is logged in with Admin/Manager role<br>- At least one category exists |
| **Post-conditions** | - New product is created<br>- Product is available for inventory and order operations |

---

## 2. Main Flow

| Step | Actor | System |
|------|-------|--------|
| 1 | User clicks "Add Product" button | System displays product creation form |
| 2 | User enters SKU | System validates SKU format and uniqueness |
| 3 | User enters product name | System validates input is not empty |
| 4 | User enters unit of measure | System accepts input (e.g., "pcs", "kg", "box") |
| 5 | User selects category | System loads category dropdown |
| 6 | User clicks "Save" | System validates all fields |
| 7 | | System creates product record with IsActive = true |
| 8 | | System displays success message |
| 9 | | System redirects to product list |

---

## 3. Alternative Flows

### AF-1: Duplicate SKU
| Step | Description |
|------|-------------|
| 6a | System detects SKU already exists |
| 6b | System displays error: "SKU already exists. Please use a unique SKU." |
| 6c | User corrects the SKU and resubmits |

### AF-2: Empty Required Fields
| Step | Description |
|------|-------------|
| 6a | System detects empty required fields |
| 6b | System displays error for each missing field |
| 6c | User fills in required fields and resubmits |

### AF-3: No Categories Available
| Step | Description |
|------|-------------|
| 1a | System finds no categories in the system |
| 1b | System displays message: "Please create a category first" |
| 1c | System provides link to category creation |

### AF-4: Cancel Operation
| Step | Description |
|------|-------------|
| 3a | User clicks "Cancel" |
| 3b | System redirects to product list without saving |

---

## 4. Business Rules

| Rule ID | Description |
|---------|-------------|
| BR-PRD-001 | SKU must be unique across all products |
| BR-PRD-002 | SKU and Name are required fields |
| BR-PRD-003 | Product must belong to exactly one category |
| BR-PRD-004 | New products are active by default |

---

## 5. Access Control

| Role | Access Level |
|------|--------------|
| Admin | Full access |
| Manager | Full access |
| Staff | No access (view only) |
| Sales | No access (view only) |

---

## 6. Data Requirements

### Input Fields
| Field | Type | Required | Validation |
|-------|------|----------|------------|
| SKU | String (100) | Yes | Not empty, unique, alphanumeric with hyphens |
| Name | String (255) | Yes | Not empty |
| Unit | String (50) | No | Common units: pcs, kg, box, carton, etc. |
| CategoryId | Long | Yes | Must exist in Categories table |

### Database Changes
- INSERT into `Products` table

---

## 7. UI Requirements

- Use form layout template from `template/html/form-layouts-vertical.html`
- Category dropdown pre-populated with all categories
- Unit field with common unit suggestions
- SKU field with format hint
- Display validation errors inline
- Include "Save" and "Cancel" buttons
