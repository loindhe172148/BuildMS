# UC-SO-003: Generate Outbound Request from Sales Order

## Use Case Overview
| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-SO-003 |
| **Use Case Name** | Generate Outbound Request from Sales Order |
| **Primary Actor** | Sales |
| **Description** | Create outbound warehouse request to fulfill a confirmed sales order |
| **Preconditions** | User is logged in with Sales or Admin role; Sales Order exists with status "Confirmed" |
| **Postconditions** | Outbound Request created; Sales Order status updated to "Fulfillment Requested" |

---

## Main Flow

### Step 1: Navigate to Confirmed Sales Orders
- Sales/Admin navigates to Sales Order Management section
- System displays list of sales orders
- Sales/Admin filters by status "Confirmed"

### Step 2: Select Order for Fulfillment
- Sales/Admin clicks on a confirmed order
- System displays order detail page

### Step 3: Display Order Details
- System displays:
  - Order ID and status
  - Customer information
  - Required delivery date
  - Order items:
    - Product name
    - Ordered quantity
    - Already fulfilled quantity (if partial)
    - Remaining to fulfill

### Step 4: Check Inventory Availability
- Sales/Admin clicks "Check Availability" or system auto-displays
- For each order item:
  - System displays available inventory across warehouses
  - System highlights if insufficient inventory
- This is informational - Sales/Admin makes the decision

### Step 5: Initiate Outbound Request
- Sales/Admin clicks "Generate Outbound Request" button
- System displays outbound request configuration form

### Step 6: Configure Outbound Request
- Sales/Admin specifies:
  - Source Warehouse (dropdown, required)
  - Quantities to fulfill for each item (defaults to remaining)
  - Shipping notes (optional)
- Sales/Admin can adjust quantities (partial fulfillment allowed)

### Step 7: Validate Outbound Request
- **Validation Rules:**
  - Source warehouse must be selected
  - At least one item must have quantity > 0
  - Fulfillment quantities cannot exceed remaining order quantities
  - Inventory availability is checked (warning if insufficient)
- If critical validation fails → **Alternative Flow A1**
- If inventory warning → **Alternative Flow A2**

### Step 8: Create Outbound Request
- System creates Request record with:
  - Request Type: "Outbound" (Sales-driven)
  - Status: "Created"
  - Source Warehouse ID
  - Reference: SalesOrder ID
  - Created By: Current user's ID
  - Created Date: Current timestamp
  - Notes

### Step 9: Create Request Items
- For each fulfillment item:
  - System creates RequestItem record:
    - Request ID (link to parent)
    - Product ID
    - Quantity to ship
    - SalesOrderItem ID reference

### Step 10: Update Sales Order Status
- System updates SalesOrder:
  - Status: "Fulfillment Requested"
  - Link to created Request

### Step 11: Display Confirmation
- System displays success message: "Outbound Request [ID] created for Sales Order [SO-ID]"
- Manager/Admin can proceed to approve the request

---

## Alternative Flows

### A1: Validation Failed
- **Trigger:** Critical validation rules not met
- **Steps:**
  1. System displays error messages:
     - "Please select a source warehouse"
     - "At least one item quantity is required"
     - "Quantity exceeds remaining order quantity"
  2. Return to Step 6

### A2: Insufficient Inventory Warning
- **Trigger:** Requested quantity exceeds available inventory
- **Steps:**
  1. System displays warning: "Insufficient inventory for [Product]. Available: [X], Requested: [Y]"
  2. Sales/Admin can:
     - Reduce quantity to available amount
     - Proceed anyway (back-order scenario)
     - Cancel and wait for inventory
  3. If proceeding, continue to Step 8

### A3: Partial Fulfillment
- **Trigger:** Sales/Admin chooses to fulfill only part of order
- **Steps:**
  1. Sales/Admin adjusts quantities for partial fulfillment
  2. System validates partial quantities
  3. Continue to Step 8
  4. Sales Order status becomes "Partially Shipped" after execution

---

## Business Rules
| Rule ID | Description |
|---------|-------------|
| BR-GEN-001 | Only Sales and Admin can generate outbound from sales orders |
| BR-GEN-002 | Only "Confirmed" orders can have outbound generated |
| BR-GEN-003 | Outbound request must reference the sales order |
| BR-GEN-004 | Sales/Admin manually checks inventory availability |
| BR-GEN-005 | Partial fulfillment is allowed |
| BR-GEN-006 | Inventory is NOT reduced at this stage |

---

## Access Control
| Role | Permission |
|------|------------|
| Admin | ✓ Can generate outbound requests |
| Manager | ✗ Cannot generate outbound requests (View Only) |
| Staff | ✗ Cannot generate outbound requests |
| Sales | ✓ Can generate outbound requests |

---

## State Transition

### Sales Order:
```
Confirmed → Fulfillment Requested (Outbound request generated)
```

### Outbound Request:
```
(New) → Created (Request generated)
```

---

## UI Requirements
- Display order items with fulfillment status
- Inventory availability indicators per product
- Warehouse selection dropdown
- Editable quantities for partial fulfillment
- Clear warnings for inventory shortages
- Generate button with confirmation
- Link back to sales order from request

---

## Important Notes
- This step links Sales domain to Warehouse domain
- Inventory is checked but NOT modified
- Actual inventory reduction happens during request execution
- Sales/Admin is responsible for availability decisions
