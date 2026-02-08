# UC-CUS-001: Create Customer

## 1. Use Case Overview

| Field | Description |
|-------|-------------|
| **Use Case ID** | UC-CUS-001 |
| **Use Case Name** | Create Customer |
| **Actor(s)** | Admin, Manager, Sales |
| **Description** | User creates a new customer in the system |
| **Trigger** | User navigates to customer management and clicks "Add Customer" |
| **Pre-conditions** | - User is logged in with appropriate role |
| **Post-conditions** | - New customer is created<br>- Customer is available for sales order creation |

---

## 2. Main Flow

| Step | Actor | System |
|------|-------|--------|
| 1 | User clicks "Add Customer" button | System displays customer creation form |
| 2 | User enters customer code | System validates code uniqueness |
| 3 | User enters customer name | System validates input is not empty |
| 4 | User enters contact information | System accepts input |
| 5 | User clicks "Save" | System validates all fields |
| 6 | | System creates customer record with Status = 'Active' |
| 7 | | System displays success message |
| 8 | | System redirects to customer list |

---

## 3. Alternative Flows

### AF-1: Duplicate Customer Code
| Step | Description |
|------|-------------|
| 5a | System detects customer code already exists |
| 5b | System displays error: "Customer code already exists" |
| 5c | User corrects the code and resubmits |

### AF-2: Empty Required Fields
| Step | Description |
|------|-------------|
| 5a | System detects empty required fields |
| 5b | System displays error for each missing field |
| 5c | User fills in required fields and resubmits |

### AF-3: Cancel Operation
| Step | Description |
|------|-------------|
| 2a | User clicks "Cancel" |
| 2b | System redirects to customer list without saving |

---

## 4. Business Rules

| Rule ID | Description |
|---------|-------------|
| BR-CUS-001 | Customer code must be unique |
| BR-CUS-002 | Customer code and name are required |
| BR-CUS-003 | New customers are active by default |

---

## 5. Access Control

| Role | Access Level |
|------|--------------|
| Admin | Full access |
| Manager | Full access |
| Staff | No access |
| Sales | Full access |

---

## 6. Data Requirements

### Input Fields
| Field | Type | Required | Validation |
|-------|------|----------|------------|
| Code | String (50) | Yes | Not empty, unique |
| Name | String (255) | Yes | Not empty |
| ContactInfo | String (500) | No | None |

### Database Changes
- INSERT into `Customers` table

---

## 7. UI Requirements

- Use form layout template from `template/html/form-layouts-vertical.html`
- ContactInfo field as textarea
- Display validation errors inline
- Include "Save" and "Cancel" buttons
