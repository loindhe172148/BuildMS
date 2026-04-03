# UC-PRO-003: Toggle Provider Status

## 1. Use Case Overview

| Field | Description |
|-------|-------------|
| **Use Case ID** | UC-PRO-003 |
| **Use Case Name** | Toggle Provider Status |
| **Actor(s)** | Admin, Manager |
| **Description** | User activates or deactivates a provider |
| **Trigger** | User clicks the toggle switch/button in the provider list |
| **Pre-conditions** | - User is logged in with appropriate role<br>- Provider exists in the system |
| **Post-conditions** | - Provider status is updated (Active <-> Inactive)<br>- Inactive providers cannot be optionally selected for new Inbound Requests |

---

## 2. Main Flow

| Step | Actor | System |
|------|-------|--------|
| 1 | User locates provider in list | System displays current status |
| 2 | User clicks status toggle action | System confirms intention |
| 3 | User confirms | System updates provider status |
| 4 | | System displays success message |
| 5 | | System refreshes list to show new status |

---

## 3. Alternative Flows

### AF-1: Provider Not Found
| Step | Description |
|------|-------------|
| 2a | System cannot find provider by ID |
| 2b | System displays error message and refreshes list |

---

## 4. Business Rules

| Rule ID | Description |
|---------|-------------|
| BR-PRO-006 | Inactive providers cannot be used in new transactions |
| BR-PRO-007 | Deactivating a provider does not affect historical transactions |

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

### Database Changes
- UPDATE `Providers` table: toggle `Status` field

---

## 7. UI Requirements

- Implement as a badge/button in the list view or a direct action
- Show visual distinction between Active (success/green) and Inactive (danger/red/gray) statuses
- Recommend a confirmation dialog before changing status, especially for deactivation
