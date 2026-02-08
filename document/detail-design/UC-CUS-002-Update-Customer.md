# UC-CUS-002: Update Customer

## 1. Use Case Overview

| Field | Description |
|-------|-------------|
| **Use Case ID** | UC-CUS-002 |
| **Use Case Name** | Update Customer |
| **Actor(s)** | Admin, Manager, Sales |
| **Description** | User updates an existing customer's information |
| **Trigger** | User clicks "Edit" on a customer from the list |
| **Pre-conditions** | - User is logged in with appropriate role<br>- Customer exists in the system |
| **Post-conditions** | - Customer information is updated |

---

## 2. Main Flow

| Step | Actor | System |
|------|-------|--------|
| 1 | User clicks "Edit" on a customer | System retrieves customer data |
| 2 | | System displays edit form with current values |
| 3 | User modifies customer code | System validates code uniqueness |
| 4 | User modifies customer name | System validates input |
| 5 | User modifies contact information | System accepts input |
| 6 | User clicks "Save" | System validates all fields |
| 7 | | System updates customer record |
| 8 | | System displays success message |
| 9 | | System redirects to customer list |

---

## 3. Alternative Flows

### AF-1: Customer Not Found
| Step | Description |
|------|-------------|
| 1a | System cannot find the customer |
| 1b | System displays error: "Customer not found" |
| 1c | System redirects to customer list |

### AF-2: Duplicate Customer Code
| Step | Description |
|------|-------------|
| 6a | System detects another customer has the same code |
| 6b | System displays error: "Customer code already exists" |
| 6c | User corrects the code and resubmits |

### AF-3: Cancel Operation
| Step | Description |
|------|-------------|
| 3a | User clicks "Cancel" |
| 3b | System redirects to customer list without saving |

---

## 4. Business Rules

| Rule ID | Description |
|---------|-------------|
| BR-CUS-001 | Customer code must be unique |
| BR-CUS-002 | Customer code and name are required |

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
- UPDATE `Customers` table

---

## 7. UI Requirements

- Use form layout template from `template/html/form-layouts-vertical.html`
- Pre-populate form with existing customer data
- Display validation errors inline
- Include "Save" and "Cancel" buttons
