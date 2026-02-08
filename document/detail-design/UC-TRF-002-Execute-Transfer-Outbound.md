# UC-TRF-002: Execute Transfer Outbound

## Use Case Overview
| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-TRF-002 |
| **Use Case Name** | Execute Transfer Outbound |
| **Primary Actor** | Staff |
| **Secondary Actor** | Manager |
| **Description** | Pick and dispatch goods from source warehouse for inter-warehouse transfer |
| **Preconditions** | User is logged in; Transfer outbound request is "Approved" |
| **Postconditions** | Outbound completed; Inventory reduced at source; Inbound ready at destination |

---

## Main Flow

### Step 1: Navigate to Approved Requests
- Staff at source warehouse navigates to Outbound Management
- System displays requests filtered by source warehouse
- Staff selects transfer-related outbound request with status "Approved"

### Step 2: Display Request for Execution
- System displays:
  - Request ID and type (Transfer Outbound)
  - Status: "Approved"
  - Source warehouse (current location)
  - Destination warehouse
  - Transfer Request reference
  - Items to pick:
    - Product name
    - Quantity to transfer
    - Storage location at source
    - Pick status

### Step 3: Start Execution
- Staff clicks "Start Picking" button
- System updates request status to "In Progress"
- System records start timestamp

### Step 4: Pick Items
- For each item:
  - Staff locates item at storage location
  - Staff physically picks the item
  - Staff enters picked quantity
  - Staff confirms pick
  - Staff notes any issues (damage, shortage)

### Step 5: Validate Picked Quantities
- **Validation Rules:**
  - Picked quantity >= 0
  - Picked quantity <= available inventory
  - Warning if differs from requested
- If discrepancy → **Alternative Flow A1**

### Step 6: Complete Picking
- Staff confirms all items picked
- Staff prepares for dispatch to destination warehouse

### Step 7: Dispatch Goods
- Staff enters dispatch details:
  - Dispatch date
  - Transport method (internal/external)
  - Notes
- Staff clicks "Dispatch"

### Step 8: Update Source Inventory
- For each picked item:
  - System decreases inventory at source warehouse
  - System creates inventory transaction:
    - Type: "Transfer Out"
    - Request ID reference
    - Product ID
    - Quantity (negative)
    - Source Warehouse ID
    - Executor ID
    - Timestamp

### Step 9: Update Outbound Request Status
- System updates outbound request:
  - Status: "Completed"
  - Completed By: Current user's ID
  - Completed Date: Current timestamp
  - Actual quantities recorded

### Step 10: Enable Inbound Request
- System updates linked inbound request:
  - Status: "Approved" (ready for execution)
  - Actual quantities from outbound
  - Expected arrival based on dispatch

### Step 11: Update Transfer Request Status
- Transfer request status:
  - If outbound completed → "In Transit"
  - Both outbound and inbound completed → "Completed"

### Step 12: Display Confirmation
- System displays: "Transfer outbound completed. Goods dispatched to [Destination Warehouse]"
- Display inbound request ID for tracking

---

## Alternative Flows

### A1: Quantity Discrepancy
- **Trigger:** Picked quantity differs from requested
- **Steps:**
  1. System displays warning
  2. Staff enters discrepancy reason
  3. Continue with actual quantity
  4. Inbound request updated with actual quantities
  5. Discrepancy logged

---

## Business Rules
| Rule ID | Description |
|---------|-------------|
| BR-TRO-001 | Staff at source warehouse executes outbound |
| BR-TRO-002 | Outbound completion enables inbound execution |
| BR-TRO-003 | Actual quantities determine inbound expectations |
| BR-TRO-004 | Source inventory decreases on completion |
| BR-TRO-005 | Goods are "in transit" between outbound and inbound completion |

---

## Access Control
| Role | Permission |
|------|------------|
| Admin | ✓ Can execute |
| Manager | ✓ Can execute |
| Staff | ✓ Can execute |
| Sales | ✗ Cannot execute |

---

## State Transition
```
Transfer Outbound: Approved → In Progress → Completed
Transfer Request: Created → In Transit
Linked Inbound: Created → Approved (auto)
```

---

## Inventory Impact
| Location | Action |
|----------|--------|
| Source Warehouse | Decrease inventory by picked quantity |
| In Transit | Goods conceptually in transit (no inventory record) |
| Destination | No change yet (awaiting inbound) |

---

## UI Requirements
- Clear identification as transfer operation
- Destination warehouse displayed
- Pick list with locations
- Dispatch details form
- Linked request navigation
- Completion confirmation
