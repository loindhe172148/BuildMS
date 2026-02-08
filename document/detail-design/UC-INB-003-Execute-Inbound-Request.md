# UC-INB-003: Execute Inbound Request

## Use Case Overview
| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-INB-003 |
| **Use Case Name** | Execute Inbound Request |
| **Primary Actor** | Staff |
| **Secondary Actor** | Manager |
| **Description** | Physically receive goods and complete the inbound operation |
| **Preconditions** | User is logged in; Request exists with status "Approved" |
| **Postconditions** | Request completed; Inventory increased |

---

## Main Flow

### Step 1: Navigate to Approved Requests
- Staff navigates to Inbound Management section
- System displays list of requests
- Staff filters by status "Approved"

### Step 2: Select Request to Execute
- Staff clicks on an approved request
- System displays request detail page

### Step 3: Display Request for Execution
- System displays:
  - Request ID and details
  - Status: "Approved"
  - Destination warehouse
  - Approved by and date
  - List of items to receive:
    - Product name
    - Expected quantity
    - Target location
    - Received quantity input field (editable)

### Step 4: Start Execution
- Staff clicks "Start Execution" button
- System updates request status to "In Progress"
- System records execution start timestamp

### Step 5: Receive Items
- For each item in the request:
  - Staff physically receives the goods
  - Staff enters actual received quantity
  - Staff confirms or updates target location
  - Staff can add notes (e.g., condition, discrepancies)

### Step 6: Validate Received Quantities
- **Validation Rules:**
  - Received quantity must be >= 0
  - Received quantity should match expected (warning if different)
- If quantities differ → **Alternative Flow A1**

### Step 7: Complete Execution
- Staff clicks "Complete" button
- System validates all items have received quantities

### Step 8: Update Inventory
- For each item with received quantity > 0:
  - System increases inventory for product at destination warehouse
  - System updates location data if specified
  - System creates inventory transaction record:
    - Type: "Inbound"
    - Request ID reference
    - Product ID
    - Quantity (positive)
    - Warehouse ID
    - Location ID
    - Executed By
    - Timestamp

### Step 9: Update Request Status
- System updates request record:
  - Status: "Completed"
  - Completed By: Current user's ID
  - Completed Date: Current timestamp
  - Actual received quantities stored in RequestItems

### Step 10: Display Confirmation
- System displays success message: "Inbound Request [ID] completed successfully"
- Display summary of inventory changes

---

## Alternative Flows

### A1: Quantity Discrepancy
- **Trigger:** Received quantity differs from expected quantity
- **Steps:**
  1. System displays warning: "Received quantity differs from expected"
  2. Staff enters discrepancy reason/notes
  3. Continue with actual received quantity
  4. Discrepancy recorded for reporting

### A2: Partial Execution
- **Trigger:** Not all items can be received at once
- **Steps:**
  1. Staff receives available items
  2. Staff marks request as partially complete
  3. Request remains "In Progress"
  4. Staff can return later to complete remaining items
  5. When all items received, proceed to Step 9

---

## Business Rules
| Rule ID | Description |
|---------|-------------|
| BR-EXE-001 | Only Staff or Manager can execute inbound requests |
| BR-EXE-002 | Only "Approved" requests can be executed |
| BR-EXE-003 | Inventory increases only upon completion |
| BR-EXE-004 | All inventory changes through Request execution |
| BR-EXE-005 | Staff cannot manually adjust inventory quantities |

---

## Access Control
| Role | Permission |
|------|------------|
| Admin | ✓ Can execute requests |
| Manager | ✓ Can execute requests |
| Staff | ✓ Can execute requests |
| Sales | ✗ Cannot execute requests |

---

## State Transition
```
Approved → In Progress (Staff starts execution)
In Progress → Completed (Staff completes all items)
```

---

## Inventory Impact
| Action | Effect |
|--------|--------|
| Complete inbound | Increase inventory quantity for each product at destination warehouse |

---

## UI Requirements
- Clear list of items to receive
- Editable quantity fields for actual received amounts
- Location confirmation/update option
- Notes field for discrepancies
- Progress indicator for multi-item requests
- Complete button with confirmation
- Summary of changes before completion
