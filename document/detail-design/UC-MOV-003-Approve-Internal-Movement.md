# UC-MOV-003: Approve Internal Movement Request

## Use Case Overview
| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-MOV-003 |
| **Use Case Name** | Approve Internal Movement Request |
| **Primary Actor** | Manager |
| **Description** | Review and approve or reject an internal movement request before it can be executed |
| **Preconditions** | Manager is logged in; Internal movement request exists with status "Created" |
| **Postconditions** | Request status changed to "Approved" or "Rejected" |

---

## Main Flow

### Step 1: Navigate to Pending Requests
- Manager navigates to Internal Movement section
- System displays list of internal movement requests
- Manager filters by status "Created" (pending approval)

### Step 2: Select Request to Review
- Manager clicks on a movement request to view details
- System displays request detail page

### Step 3: Display Request Details
- System displays:
  - Request ID
  - Current status: "Created"
  - Warehouse
  - Created by (user name) and creation date
  - Notes
  - List of movement items:
    - Product name and SKU
    - Source location (with current quantity)
    - Destination location (with current quantity)
    - Quantity to move

### Step 4: Review Request
- Manager reviews all request details
- Manager verifies:
  - Source location has sufficient inventory
  - Destination location is appropriate
  - Quantity is reasonable

### Step 5: Approval Decision
- Manager chooses action:
  - "Approve" → Continue to Step 6
  - "Reject" → **Alternative Flow A1**

### Step 6: Confirm Approval
- Manager clicks "Approve" button
- System updates request record:
  - Status: "Approved"
  - Approved By: Current Manager's User ID
  - Approved Date: Current timestamp

### Step 7: Display Confirmation
- System displays success message: "Movement Request #[ID] has been approved"
- Request is now available for execution by Staff

---

## Alternative Flows

### A1: Reject Request
- **Trigger:** Manager decides to reject the request
- **Steps:**
  1. Manager clicks "Reject" button
  2. System displays rejection modal with:
     - Rejection Reason (text area, required)
  3. Manager enters rejection reason
  4. Manager confirms rejection
  5. System updates request record:
     - Status: "Rejected"
     - Rejected By: Current Manager's User ID
     - Rejected Date: Current timestamp
     - Rejection Reason: Entered text
  6. System displays message: "Movement Request #[ID] has been rejected"
  7. Request cannot proceed to execution

---

## Business Rules
| Rule ID | Description |
|---------|-------------|
| BR-MOV-007 | Only Admin and Manager can approve/reject internal movement requests |
| BR-MOV-008 | Only requests with status "Created" can be approved or rejected |
| BR-MOV-009 | Rejection requires a mandatory reason |
| BR-MOV-010 | Manager can only approve/reject movement requests for their assigned warehouse |
| BR-MOV-011 | Execution (UC-MOV-002) requires status "Approved" — requests cannot be executed from "Created" status |

---

## Access Control
| Role | Permission |
|------|------------|
| Admin | ✓ Can approve/reject requests (all warehouses) |
| Manager | ✓ Can approve/reject requests (assigned warehouse only) |
| Staff | ✗ Cannot approve/reject requests |
| Sales | ✗ Cannot approve/reject requests |

---

## State Transition
```
Created → Approved (Manager/Admin approves)
Created → Rejected (Manager/Admin rejects)
```

---

## UI Requirements
- Approve and Reject buttons visible only when status = "Created" and user is Admin or Manager
- Rejection reason text area required before submitting rejection
- Clear status badge display (Created/Approved/Rejected)
- Approved By / Rejected By user name and timestamp displayed on details page
- Rejection reason displayed on details page when status = "Rejected"
