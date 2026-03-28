# UC-PRO-001: Create Provider

## 1. Use Case Overview

| Field | Description |
|-------|-------------|
| **Use Case ID** | UC-PRO-001 |
| **Use Case Name** | Create Provider |
| **Actor(s)** | Admin, Manager |
| **Description** | User creates a new provider in the system |
| **Trigger** | User navigates to provider management and clicks "Add Provider" |
| **Pre-conditions** | - User is logged in with appropriate role |
| **Post-conditions** | - New provider is created<br>- Provider is optionally available for inbound request creation |

---

## 2. Main Flow

| Step | Actor | System |
|------|-------|--------|
| 1 | User clicks "Add Provider" button | System displays provider creation form |
| 2 | User enters provider code | System validates code uniqueness |
| 3 | User enters provider name | System validates input is not empty |
| 4 | User enters contact information | System accepts input |
| 5 | User clicks "Save" | System validates all fields |
| 6 | | System creates provider record with Status = 'Active' |
| 7 | | System displays success message |
| 8 | | System redirects to provider list |

---

## 3. Alternative Flows

### AF-1: Duplicate Provider Code
| Step | Description |
|------|-------------|
| 5a | System detects provider code already exists |
| 5b | System displays error: "Provider code already exists" |
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
| 2b | System redirects to provider list without saving |

---

## 4. Business Rules

| Rule ID | Description |
|---------|-------------|
| BR-PRO-001 | Provider code must be unique |
| BR-PRO-002 | Provider code and name are required |
| BR-PRO-003 | New providers are active by default |

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
| Code | String (50) | Yes | Not empty, unique |
| Name | String (255) | Yes | Not empty |
| ContactInfo | String (500) | No | None |

### Database Changes
- INSERT into `Providers` table

---

## 7. UI Requirements

- Use form layout template
- ContactInfo field as textarea
- Display validation errors inline
- Include "Save" and "Cancel" buttons
