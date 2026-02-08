# UC-OUT-001: Approve Outbound Request

## Use Case Overview
| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-OUT-001 |
| **Use Case Name** | Approve Outbound Request |
| **Primary Actor** | Manager |
| **Description** | Review and approve an outbound request for execution |
| **Preconditions** | Manager is logged in; Outbound request exists with status "Created" |
| **Postconditions** | Request status changed to "Approved" or "Rejected" |

---

## Main Flow

### Step 1: Navigate to Pending Requests
- Manager navigates to Outbound Management section
- System displays list of outbound requests
- Manager filters by status "Created" (pending approval)

### Step 2: Select Request to Review
- Manager clicks on a request to view details
- System displays request detail page

### Step 3: Display Request Details
- System displays:
  - Request ID and type (Sales-driven or Internal)
  - Current status: "Created"
  - Source warehouse
  - Reference (SalesOrder ID if sales-driven)
  - Created by and date
  - Notes
  - Request items:
    - Product name
    - Quantity to ship
    - Current inventory at source warehouse
    - Inventory status indicator

### Step 4: Check Inventory Availability
- For each request item:
  - System displays current inventory quantity at source warehouse
  - System highlights items with insufficient inventory
- Manager reviews availability

### Step 5: Review Request
- Manager verifies:
  - Source warehouse selection
  - Item quantities
  - Inventory availability
  - Sales order reference (if applicable)

### Step 6: Approval Decision
- Manager chooses action:
  - "Approve" → Continue to Step 7
  - "Reject" → **Alternative Flow A1**
- If insufficient inventory → **Alternative Flow A2**

### Step 7: Confirm Approval
- System displays confirmation dialog: "Approve this outbound request?"
- Manager confirms approval

### Step 8: Update Request Status
- System updates request record:
  - Status: "Approved"
  - Approved By: Current Manager's ID
  - Approved Date: Current timestamp

### Step 9: Display Confirmation
- System displays success message: "Outbound Request [ID] has been approved"
- Request is now available for execution by Staff

---

## Alternative Flows

### A1: Reject Request
- **Trigger:** Manager decides to reject the request
- **Steps:**
  1. Manager clicks "Reject" button
  2. System displays rejection form:
     - Rejection Reason (text area, required)
  3. Manager enters rejection reason
  4. Manager confirms rejection
  5. System updates request record:
     - Status: "Rejected"
     - Rejected By: Current Manager's ID
     - Rejected Date: Current timestamp
     - Rejection Reason: Entered text
  6. If sales-driven, update SalesOrder status back to "Confirmed"
  7. System displays message: "Outbound Request [ID] has been rejected"

### A2: Insufficient Inventory
- **Trigger:** One or more items have insufficient inventory
- **Steps:**
  1. System displays warning: "Insufficient inventory for some items"
  2. Manager can:
     - Approve anyway (proceed with available stock)
     - Reject with reason
     - Return request for modification
  3. If approving with insufficient inventory:
     - System logs the decision
     - Continue to Step 8

---

## Business Rules
| Rule ID | Description |
|---------|-------------|
| BR-APO-001 | Only Manager can approve/reject outbound requests |
| BR-APO-002 | Only "Created" requests can be approved |
| BR-APO-003 | Rejection requires a reason |
| BR-APO-004 | Inventory check is displayed but not enforced |
| BR-APO-005 | Rejected sales-driven requests revert SO status |

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
- Inventory status indicators (sufficient/insufficient)
- Sales order reference link (if sales-driven)
- Approve and Reject buttons
- Confirmation dialog before approval
- Rejection reason is mandatory
- Visual inventory warnings
