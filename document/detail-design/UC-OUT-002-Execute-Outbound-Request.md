# UC-OUT-002: Execute Outbound Request (Pick and Ship)

## Use Case Overview
| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-OUT-002 |
| **Use Case Name** | Execute Outbound Request (Pick and Ship) |
| **Primary Actor** | Staff |
| **Secondary Actor** | Manager |
| **Description** | Physically pick items and complete outbound shipment |
| **Preconditions** | User is logged in; Request exists with status "Approved" |
| **Postconditions** | Request completed; Inventory reduced; Sales Order updated (if applicable) |

---

## Main Flow

### Step 1: Navigate to Approved Requests
- Staff navigates to Outbound Management section
- System displays list of requests
- Staff filters by status "Approved"

### Step 2: Select Request to Execute
- Staff clicks on an approved outbound request
- System displays request detail page

### Step 3: Display Request for Execution
- System displays:
  - Request ID and type
  - Status: "Approved"
  - Source warehouse
  - Sales Order reference (if sales-driven)
  - Customer information (if sales-driven)
  - Items to pick:
    - Product name and SKU
    - Quantity to pick
    - Storage location
    - Picked quantity input field
    - Pick status

### Step 4: Start Execution
- Staff clicks "Start Picking" button
- System updates request status to "In Progress"
- System records execution start timestamp

### Step 5: Pick Items
- For each item in the request:
  - Staff locates item at storage location
  - Staff physically picks the item
  - Staff enters picked quantity
  - Staff confirms pick for item
  - Staff can add notes (e.g., location empty, item damaged)

### Step 6: Validate Picked Quantities
- **Validation Rules:**
  - Picked quantity must be >= 0
  - Picked quantity cannot exceed available inventory
  - Picked quantity should match requested (warning if different)
- If quantities differ → **Alternative Flow A1**
- If inventory unavailable → **Alternative Flow A2**

### Step 7: Complete Picking
- Staff confirms all items are picked
- Staff clicks "Complete Picking" button

### Step 8: Ship Goods
- Staff prepares shipment
- Staff enters shipping details (optional):
  - Carrier/method
  - Tracking number
  - Shipping date
- Staff clicks "Mark as Shipped"

### Step 9: Update Inventory
- For each item with picked quantity > 0:
  - System decreases inventory for product at source warehouse
  - System updates location quantities
  - System creates inventory transaction record:
    - Type: "Outbound"
    - Request ID reference
    - Product ID
    - Quantity (negative)
    - Warehouse ID
    - Location ID
    - Executed By
    - Timestamp

### Step 10: Update Request Status
- System updates request record:
  - Status: "Completed"
  - Completed By: Current user's ID
  - Completed Date: Current timestamp
  - Actual picked quantities stored

### Step 11: Update Sales Order (if sales-driven)
- System updates SalesOrderItem fulfilled quantities
- System checks if order is fully or partially fulfilled:
  - All items fulfilled → SalesOrder status: "Completed"
  - Some items remain → SalesOrder status: "Partially Shipped"

### Step 12: Display Confirmation
- System displays success message: "Outbound Request [ID] completed successfully"
- Display summary of inventory changes
- Display updated Sales Order status (if applicable)

---

## Alternative Flows

### A1: Quantity Discrepancy
- **Trigger:** Picked quantity differs from requested quantity
- **Steps:**
  1. System displays warning: "Picked quantity differs from requested"
  2. Staff enters discrepancy reason
  3. Continue with actual picked quantity
  4. If sales-driven, SO becomes "Partially Shipped"
  5. Discrepancy recorded for reporting

### A2: Insufficient Inventory
- **Trigger:** Physical inventory is less than expected
- **Steps:**
  1. Staff enters actual available quantity
  2. System records discrepancy
  3. Staff adds notes explaining shortage
  4. Continue with available quantity
  5. Manager is notified of inventory discrepancy

### A3: Partial Execution
- **Trigger:** Not all items can be picked at once
- **Steps:**
  1. Staff picks available items
  2. Staff saves progress
  3. Request remains "In Progress"
  4. Staff returns later to complete
  5. When all items picked, proceed to Step 8

---

## Business Rules
| Rule ID | Description |
|---------|-------------|
| BR-EXO-001 | Only Staff or Manager can execute outbound requests |
| BR-EXO-002 | Only "Approved" requests can be executed |
| BR-EXO-003 | Inventory decreases only upon completion |
| BR-EXO-004 | Picked quantity cannot exceed available inventory |
| BR-EXO-005 | Sales Order is updated after outbound completion |

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

### Request:
```
Approved → In Progress (Staff starts picking)
In Progress → Completed (Staff completes shipment)
```

### Sales Order (if applicable):
```
Fulfillment Requested → Partially Shipped (partial pick)
Fulfillment Requested → Completed (full pick)
Partially Shipped → Completed (remaining items shipped)
```

---

## Inventory Impact
| Action | Effect |
|--------|--------|
| Complete outbound | Decrease inventory quantity for each product at source warehouse |

---

## UI Requirements
- Pick list with item locations
- Editable quantity fields for actual picked amounts
- Pick status per item (Not started, In progress, Picked)
- Barcode/scanner support (simulated)
- Notes field for discrepancies
- Progress indicator
- Shipping details form
- Complete button with confirmation
- Link to Sales Order (if applicable)
- Record actual quantities picked
- Record discrepancy notes
- Full inventory transaction history
- Shipping details captured
