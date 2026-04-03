# UC-TRF-002: Approve/Reject Transfer Request

## Use Case Overview
| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-TRF-002 |
| **Use Case Name** | Approve/Reject Inter-Warehouse Transfer Request |
| **Primary Actor** | Manager (at destination warehouse) |
| **Description** | The destination warehouse Manager reviews and approves or rejects a transfer request created by the source warehouse. Only after destination warehouse approval can the transfer proceed. |
| **Preconditions** | User is logged in as Admin or Manager; Transfer request exists with status "Created"; User belongs to the destination warehouse (Manager) or is Admin |
| **Postconditions** | Transfer request status changed to "Approved" or "Rejected" |

---

## Key Principle

> **The destination warehouse controls whether it accepts incoming transfers.**
>
> Source warehouse (WH1) creates the transfer → Destination warehouse (WH2) approves →
> Only then can execution proceed. This ensures the receiving warehouse has agreed to
> accept the goods and can prepare storage capacity.

---

## Main Flow (Approve)

### Step 1: Navigate to Transfer Requests
- Manager at destination warehouse navigates to Transfer Management section
- System displays list of transfer requests relevant to the user's warehouse
- Transfers where user's warehouse is the **destination** and status is "Created" are shown with an "Approve/Reject" action

### Step 2: Select Transfer Request
- Manager selects a transfer request with status "Created"
- System displays transfer request details:
  - Transfer Request ID
  - Status: "Created"
  - Source Warehouse name
  - Destination Warehouse name (user's warehouse)
  - Created By (user at source warehouse)
  - Created Date
  - Expected Transfer Date
  - Notes/Reason
  - Item list: Product name, SKU, requested quantity

### Step 3: Review Transfer Details
- Manager reviews:
  - Whether the destination warehouse can accommodate the incoming goods
  - Whether the items and quantities are appropriate
  - Any notes from the source warehouse

### Step 4: Approve Transfer
- Manager clicks "Approve" button
- System prompts for confirmation

### Step 5: Update Transfer Request
- System updates the transfer request:
  - Status: **"Approved"**
  - Approved By: Current user's ID
  - Approved Date: Current timestamp
- Source warehouse can now proceed with outbound execution (UC-TRF-003)

### Step 6: Display Confirmation
- System displays success message: "Transfer Request [ID] approved successfully"
- Source warehouse is now able to start outbound execution

---

## Alternative Flow: Reject Transfer

### Step R1: Manager Decides to Reject
- After reviewing the transfer details (Step 3), Manager clicks "Reject" button

### Step R2: Provide Rejection Reason
- System displays a text area for rejection reason (required)
- Manager enters the reason for rejection
- If reason is empty → display error "Rejection reason is required"

### Step R3: Confirm Rejection
- Manager clicks "Confirm Reject" button
- System updates the transfer request:
  - Status: **"Rejected"**
  - Rejected By: Current user's ID
  - Rejection Reason: entered text
  - Rejected Date: Current timestamp

### Step R4: Display Confirmation
- System displays success message: "Transfer Request [ID] rejected"
- Transfer is finalized — no further action possible

---

## Alternative Flows

### A1: Transfer Not Found or Already Processed
- **Trigger:** Transfer request does not exist or status is not "Created"
- **Steps:**
  1. System displays error: "Transfer request not found or already processed"
  2. Redirect to transfer list

### A2: No Permission (Not Destination Warehouse)
- **Trigger:** Manager's assigned warehouse is not the destination warehouse of the transfer
- **Steps:**
  1. System displays error: "Only the destination warehouse Manager can approve/reject this transfer"
  2. Redirect to transfer list

### A3: Admin Approval
- **Trigger:** Admin user approves/rejects
- **Steps:**
  1. Admin can approve/reject any transfer request regardless of warehouse assignment
  2. Same approval/rejection flow as Manager

---

## Business Rules
| Rule ID | Description |
|---------|-------------|
| BR-TRA-001 | Only Admin and Manager can approve/reject transfer requests |
| BR-TRA-002 | **Manager can only approve/reject transfers where their assigned warehouse is the destination** |
| BR-TRA-003 | Admin can approve/reject any transfer request |
| BR-TRA-004 | Only transfer requests with status "Created" can be approved/rejected |
| BR-TRA-005 | Rejection reason is mandatory when rejecting |
| BR-TRA-006 | Approved transfers enable source warehouse to execute outbound (UC-TRF-003) |
| BR-TRA-007 | Rejected transfers are finalized — no further action possible |

---

## Access Control
| Role | Permission |
|------|------------|
| Admin | ✓ Can approve/reject any transfer request |
| Manager | ✓ Can approve/reject only transfers destined to their assigned warehouse |
| Staff | ✗ Cannot approve/reject transfer requests |
| Sales | ✗ Cannot approve/reject transfer requests |

### Warehouse-Specific Access (Manager)
| Manager's Warehouse | Transfer Source WH | Transfer Dest WH | Can Approve? |
|---------------------|-------------------|-------------------|-------------|
| WH-A | WH-A | WH-B | ✗ No (Manager is at source, not destination) |
| WH-B | WH-A | WH-B | ✓ Yes (Manager is at destination) |
| WH-C | WH-A | WH-B | ✗ No (Manager is at unrelated warehouse) |

---

## State Transition
```
Transfer Request: Created ──[Dest WH Manager approves]──→ Approved
                  Created ──[Dest WH Manager rejects]───→ Rejected
```

---

## UI Requirements
- Transfer list shows "Approve/Reject" action for eligible transfers (status "Created", user is destination WH Manager or Admin)
- Transfer detail view displays:
  - Full transfer details (source WH, destination WH, items, quantities)
  - Approve and Reject buttons (visible only when user has permission and status is "Created")
- Reject modal/dialog with mandatory reason text area
- Confirmation prompt before approve action
- Clear success/error messages after action
- Source warehouse name prominently displayed so destination Manager knows who is sending
