# UC-PRD-002: Update Product

## 1. Use Case Overview

| Field | Description |
|-------|-------------|
| **Use Case ID** | UC-PRD-002 |
| **Use Case Name** | Update Product |
| **Actor(s)** | Admin, Manager |
| **Description** | User updates an existing product's information |
| **Trigger** | User clicks "Edit" on a product from the list |
| **Pre-conditions** | - User is logged in with Admin/Manager role<br>- Product exists in the system |
| **Post-conditions** | - Product information is updated |

---

## 2. Main Flow

| Step | Actor | System |
|------|-------|--------|
| 1 | User clicks "Edit" on a product | System retrieves product data |
| 2 | | System displays edit form with current values |
| 3 | User modifies SKU | System validates SKU uniqueness |
| 4 | User modifies product name | System validates input |
| 5 | User modifies unit | System accepts input |
| 6 | User modifies category | System validates selection |
| 7 | User clicks "Save" | System validates all fields |
| 8 | | System updates product record |
| 9 | | System displays success message |
| 10 | | System redirects to product list |

---

## 3. Alternative Flows

### AF-1: Product Not Found
| Step | Description |
|------|-------------|
| 1a | System cannot find the product |
| 1b | System displays error: "Product not found" |
| 1c | System redirects to product list |

### AF-2: Duplicate SKU
| Step | Description |
|------|-------------|
| 7a | System detects another product has the same SKU |
| 7b | System displays error: "SKU already exists" |
| 7c | User corrects the SKU and resubmits |

### AF-3: Cancel Operation
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
| BR-PRD-005 | SKU changes should be avoided for products with existing inventory |

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
| SKU | String (100) | Yes | Not empty, unique |
| Name | String (255) | Yes | Not empty |
| Unit | String (50) | No | None |
| CategoryId | Long | Yes | Must exist in Categories table |

### Database Changes
- UPDATE `Products` table

---

## 7. UI Requirements

- Use form layout template from `template/html/form-layouts-vertical.html`
- Pre-populate form with existing product data
- Show warning if changing SKU of product with inventory
- Display validation errors inline
- Include "Save" and "Cancel" buttons
