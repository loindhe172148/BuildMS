# UC-PRO-004: View Provider List

## 1. Use Case Overview

| Field | Description |
|-------|-------------|
| **Use Case ID** | UC-PRO-004 |
| **Use Case Name** | View Provider List |
| **Actor(s)** | Admin, Manager |
| **Description** | User views a paginated list of providers with search capabilities |
| **Trigger** | User navigates to Provider Management |
| **Pre-conditions** | - User is logged in with appropriate role |
| **Post-conditions** | - List of providers is displayed |

---

## 2. Main Flow

| Step | Actor | System |
|------|-------|--------|
| 1 | User navigates to Provider List | System retrieves paginated list of providers |
| 2 | | System renders provider table |

---

## 3. Alternative Flows

### AF-1: No Providers Found
| Step | Description |
|------|-------------|
| 1a | System retrieves empty list |
| 1b | System renders "No providers found" message in table body |

### AF-2: Search Providers
| Step | Description |
|------|-------------|
| 1 | User enters keyword in search box and clicks "Search" |
| 2 | System retrieves providers matching the keyword |
| 3 | System renders filtered table |

---

## 4. Business Rules

| Rule ID | Description |
|---------|-------------|
| BR-PRO-008 | Default sorting by provider ID or Date Created descending |

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

### View Data
- Lists objects containing: Code, Name, Contact Info, Status
- Pagination metadata (current page, total pages, etc.)

---

## 7. UI Requirements

- Standard data table layout
- Include search bar and pagination controls
- Actions column with Edit and Toggle Status buttons
