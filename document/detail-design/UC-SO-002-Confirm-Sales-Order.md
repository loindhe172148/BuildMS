# UC-SO-002: Confirm Sales Order

## Use Case Overview
| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-SO-002 |
| **Use Case Name** | Confirm Sales Order |
| **Primary Actor** | Sales |
| **Secondary Actor** | Manager |
| **Description** | Confirm a draft sales order to make it ready for fulfillment |
| **Preconditions** | User is logged in; Sales Order exists with status "Draft" |
| **Postconditions** | Sales Order status changed to "Confirmed" |

---

## Main Flow

### Step 1: Navigate to Sales Orders
- Sales navigates to Sales Order Management section
- System displays list of sales orders
- Sales filters by status "Draft" (optional)

### Step 2: Select Order to Confirm
- Sales clicks on a draft order to view details
- System displays order detail page

### Step 3: Display Order Details
- System displays:
  - Order ID
  - Status: "Draft"
  - Customer information
  - Order date
  - Required delivery date
  - Created by and date
  - Order items with quantities

### Step 4: Review Order
- Sales reviews all order details
- Sales verifies order information is correct
- Sales may edit order if needed (while still Draft)

### Step 5: Initiate Confirmation
- Sales clicks "Confirm Order" button
- System displays confirmation dialog

### Step 6: Validate Order for Confirmation
- **Validation Rules:**
  - Order must have at least one item
  - All items must have valid products
  - All quantities must be positive
- If validation fails → **Alternative Flow A1**

### Step 7: Confirm Order
- System updates SalesOrder record:
  - Status: "Confirmed"
  - Confirmed By: Current user's ID
  - Confirmed Date: Current timestamp

### Step 8: Display Confirmation
- System displays success message: "Sales Order [ID] has been confirmed"
- Order is now ready for Manager to request fulfillment

---

## Alternative Flows

### A1: Validation Failed
- **Trigger:** Order data is invalid
- **Steps:**
  1. System displays error messages
  2. Sales must fix issues before confirming
  3. Return to Step 3

### A2: Cancel Confirmation
- **Trigger:** Sales cancels in confirmation dialog
- **Steps:**
  1. System closes dialog
  2. Order remains in "Draft" status
  3. Return to Step 3

---

## Business Rules
| Rule ID | Description |
|---------|-------------|
| BR-SOC-001 | Only Draft orders can be confirmed |
| BR-SOC-002 | Sales and Manager can confirm orders |
| BR-SOC-003 | Confirmed orders cannot be edited (only cancelled) |
| BR-SOC-004 | Confirmation does not affect inventory |

---

## Access Control
| Role | Permission |
|------|------------|
| Admin | ✓ Can confirm orders |
| Manager | ✓ Can confirm orders |
| Staff | ✗ Cannot confirm orders |
| Sales | ✓ Can confirm orders |

---

## State Transition
```
Draft → Confirmed (User confirms order)
```

---

## UI Requirements
- Clear display of order details
- Edit option while in Draft (separate use case)
- Prominent "Confirm Order" button
- Confirmation dialog with order summary
- Visual status indicator

---

## Notes
- Confirmation is a prerequisite for fulfillment
- Inventory is still NOT checked or reserved at this stage
- Manager will generate outbound request after confirmation
