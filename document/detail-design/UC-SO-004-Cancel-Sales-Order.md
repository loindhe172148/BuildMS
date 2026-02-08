# UC-SO-004: Cancel Sales Order

## Use Case Overview
| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-SO-004 |
| **Use Case Name** | Cancel Sales Order |
| **Primary Actor** | Sales |
| **Secondary Actor** | Manager |
| **Description** | Cancel a sales order that is no longer needed |
| **Preconditions** | User is logged in; Sales Order exists and is not Completed |
| **Postconditions** | Sales Order status changed to "Cancelled" |

---

## Main Flow

### Step 1: Navigate to Sales Orders
- User navigates to Sales Order Management section
- System displays list of sales orders

### Step 2: Select Order to Cancel
- User clicks on the order to view details
- System displays order detail page

### Step 3: Display Order Details
- System displays:
  - Order ID and current status
  - Customer information
  - Order items and quantities
  - Fulfillment status (if any)
  - Related outbound requests (if any)

### Step 4: Verify Cancellation is Allowed
- System checks order status:
  - Draft: Can cancel
  - Confirmed: Can cancel
  - Fulfillment Requested: Can cancel (with warning)
  - Partially Shipped: Can cancel remaining (with warning)
  - Completed: Cannot cancel → **Alternative Flow A1**

### Step 5: Initiate Cancellation
- User clicks "Cancel Order" button
- System displays cancellation form

### Step 6: Enter Cancellation Details
- System displays:
  - Cancellation Reason (text area, required)
  - Warning about related requests (if any)
- User enters reason for cancellation

### Step 7: Confirm Cancellation
- System displays confirmation dialog:
  - "Are you sure you want to cancel this order?"
  - Shows impact summary (e.g., related requests)
- User confirms cancellation

### Step 8: Handle Related Outbound Requests
- If order has related outbound requests in "Created" status:
  - System cancels those requests automatically
- If requests are "Approved" or "In Progress":
  - System displays warning
  - Manager must manually handle those requests

### Step 9: Update Sales Order Status
- System updates SalesOrder record:
  - Status: "Cancelled"
  - Cancelled By: Current user's ID
  - Cancelled Date: Current timestamp
  - Cancellation Reason: Entered text

### Step 10: Display Confirmation
- System displays success message: "Sales Order [ID] has been cancelled"
- Display summary of any related actions taken

---

## Alternative Flows

### A1: Order Already Completed
- **Trigger:** Order status is "Completed"
- **Steps:**
  1. System displays error: "Completed orders cannot be cancelled"
  2. User may need to process a return instead (out of scope)
  3. Return to order detail page

### A2: Has Active Outbound Requests
- **Trigger:** Order has outbound requests that are Approved/In Progress
- **Steps:**
  1. System displays warning: "This order has active outbound requests"
  2. Lists the active requests
  3. User must contact Manager to handle requests first
  4. OR Manager can force cancel with acknowledgment

---

## Business Rules
| Rule ID | Description |
|---------|-------------|
| BR-CAN-001 | Sales and Manager can cancel orders |
| BR-CAN-002 | Completed orders cannot be cancelled |
| BR-CAN-003 | Cancellation reason is required |
| BR-CAN-004 | Related "Created" outbound requests are auto-cancelled |
| BR-CAN-005 | Active requests require manual handling |
| BR-CAN-006 | Cancellation does not affect already shipped inventory |

---

## Access Control
| Role | Permission |
|------|------------|
| Admin | ✓ Can cancel orders |
| Manager | ✓ Can cancel orders |
| Staff | ✗ Cannot cancel orders |
| Sales | ✓ Can cancel orders |

---

## State Transition
```
Draft → Cancelled
Confirmed → Cancelled
Fulfillment Requested → Cancelled
Partially Shipped → Cancelled (remaining items only)
Completed → (Cannot cancel)
```

---

## UI Requirements
- Cancel button visible on order detail page
- Cancellation reason is mandatory
- Display warnings for related requests
- Confirmation dialog before cancellation
- Clear indication of cancelled status
