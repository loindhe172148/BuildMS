# UC-PRO-002: Update Provider

## 1. Use Case Overview

| Field | Description |
|-------|-------------|
| **Use Case ID** | UC-PRO-002 |
| **Use Case Name** | Update Provider |
| **Actor(s)** | Admin, Manager |
| **Description** | User updates an existing provider's information |
| **Trigger** | User navigates to provider list and clicks "Edit" for a provider |
| **Pre-conditions** | - User is logged in with appropriate role<br>- Provider exists in the system |
| **Post-conditions** | - Provider information is updated |

---

## 2. Main Flow

| Step | Actor | System |
|------|-------|--------|
| 1 | User clicks "Edit" for a provider | System displays provider edit form with current data |
| 2 | User updates provider name | System validates input is not empty |
| 3 | User updates contact information | System accepts input |
| 4 | User clicks "Save" | System validates all fields |
| 5 | | System updates provider record |
| 6 | | System displays success message |
| 7 | | System redirects to provider list |

---

## 3. Alternative Flows

### AF-1: Empty Required Fields
| Step | Description |
|------|-------------|
| 4a | System detects empty required fields |
| 4b | System displays error for each missing field |
| 4c | User fills in required fields and resubmits |

### AF-2: Cancel Operation
| Step | Description |
|------|-------------|
| 2a | User clicks "Cancel" |
| 2b | System redirects to provider list without saving |

### AF-3: Provider Not Found
| Step | Description |
|------|-------------|
| 1a | System cannot find provider by ID |
| 1b | System redirects to error page or provider list with error message |

---

## 4. Business Rules

| Rule ID | Description |
|---------|-------------|
| BR-PRO-004 | Provider code cannot be changed after creation |
| BR-PRO-005 | Provider name is required |

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
| Name | String (255) | Yes | Not empty |
| ContactInfo | String (500) | No | None |

### Read-only Fields
- Provider Code

### Database Changes
- UPDATE `Providers` table

---

## 7. UI Requirements

- Use form layout template
- Provider Code field must be read-only/disabled
- ContactInfo field as textarea
- Display validation errors inline
- Include "Save" and "Cancel" buttons
