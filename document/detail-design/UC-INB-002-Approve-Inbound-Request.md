# UC-INB-002: Approve Inbound Request

## Use Case Overview
| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-INB-002 |
| **Use Case Name** | Approve Inbound Request |
| **Primary Actor** | Manager |
| **Description** | Review and approve an inbound request for execution |
| **Preconditions** | Manager is logged in; Inbound request exists with status "Created" |
| **Postconditions** | Request status changed to "Approved" or "Rejected" |

---

## Main Flow

### Step 1: Navigate to Pending Requests
- Manager navigates to Inbound Management section
- System displays list of inbound requests
- Manager filters by status "Created" (pending approval)

### Step 2: Select Request to Review
- Manager clicks on a request to view details
- System displays request detail page

### Step 3: Display Request Details
- System displays:
  - Request ID and type
  - Current status: "Created"
  - Destination warehouse
  - Expected delivery date
  - Created by (user name)
  - Created date
  - Notes
  - List of request items:
    - Product name
    - Quantity
    - Target location (if specified)

### Step 4: Review Request
- Manager reviews all request details
- Manager verifies:
  - Warehouse capacity (manual check)
  - Product validity
  - Quantity reasonableness

### Step 5: Approval Decision
- Manager chooses action:
  - "Approve" → Continue to Step 6
  - "Reject" → **Alternative Flow A1**

### Step 6: Confirm Approval
- System displays confirmation dialog: "Approve this inbound request?"
- Manager confirms approval

### Step 7: Update Request Status
- System updates request record:
  - Status: "Approved"
  - Approved By: Current Manager's User ID
  - Approved Date: Current timestamp

### Step 8: Display Confirmation
- System displays success message: "Inbound Request [ID] has been approved"
- Request is now available for execution by Staff

---

## Alternative Flows

### A1: Reject Request
- **Trigger:** Manager decides to reject the request
- **Steps:**
  1. Manager clicks "Reject" button
  2. System displays rejection form with:
     - Rejection Reason (text area, required)
  3. Manager enters rejection reason
  4. Manager confirms rejection
  5. System updates request record:
     - Status: "Rejected"
     - Rejected By: Current Manager's User ID
     - Rejected Date: Current timestamp
     - Rejection Reason: Entered text
  6. System displays message: "Inbound Request [ID] has been rejected"
  7. Request cannot proceed to execution

---

## Business Rules
| Rule ID | Description |
|---------|-------------|
| BR-APR-001 | Only Manager can approve/reject inbound requests |
| BR-APR-002 | Only requests with status "Created" can be approved |
| BR-APR-003 | Rejection requires a reason |
| BR-APR-004 | Approver must be different from creator (optional rule) |

---

## Access Control
| Role | Permission |
|------|------------|
| Admin | ✓ Can approve/reject requests |
| Manager | ✓ Can approve/reject requests |
| Staff | ✗ Cannot approve/reject requests |
| Sales | ✗ Cannot approve/reject requests |

---

## State Transition
```
Created → Approved (Manager approves)
Created → Rejected (Manager rejects)
```

---

## UI Requirements
- Clear display of all request details
- Prominent Approve and Reject buttons
- Confirmation dialog before approval
- Rejection reason is mandatory with text area
- Visual indication of current status
- History of status changes (if available)
