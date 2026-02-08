# UC-TRF-003: Execute Transfer Inbound

## Use Case Overview
| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-TRF-003 |
| **Use Case Name** | Execute Transfer Inbound |
| **Primary Actor** | Staff |
| **Secondary Actor** | Manager |
| **Description** | Receive transferred goods at destination warehouse |
| **Preconditions** | User is logged in; Transfer inbound request is "Approved"; Transfer outbound is completed |
| **Postconditions** | Inbound completed; Inventory increased at destination; Transfer complete |

---

## Main Flow

### Step 1: Navigate to Approved Requests
- Staff at destination warehouse navigates to Inbound Management
- System displays requests filtered by destination warehouse
- Staff selects transfer-related inbound request with status "Approved"

### Step 2: Display Request for Execution
- System displays:
  - Request ID and type (Transfer Inbound)
  - Status: "Approved"
  - Source warehouse (origin)
  - Destination warehouse (current location)
  - Transfer Request reference
  - Dispatch information from outbound
  - Items to receive:
    - Product name
    - Expected quantity (from outbound actual)
    - Target location at destination
    - Receive status

### Step 3: Start Execution
- Staff clicks "Start Receiving" button
- System updates request status to "In Progress"
- System records start timestamp

### Step 4: Receive Items
- For each item:
  - Staff inspects received goods
  - Staff counts quantity
  - Staff enters received quantity
  - Staff assigns/confirms storage location
  - Staff notes any issues (damage, missing)

### Step 5: Validate Received Quantities
- **Validation Rules:**
  - Received quantity >= 0
  - Warning if differs from expected (dispatched)
- If discrepancy → **Alternative Flow A1**

### Step 6: Complete Receiving
- Staff confirms all items received
- Staff verifies storage locations assigned
- Staff clicks "Complete Receiving"

### Step 7: Update Destination Inventory
- For each received item:
  - System increases inventory at destination warehouse
  - System updates location data
  - System creates inventory transaction:
    - Type: "Transfer In"
    - Request ID reference
    - Product ID
    - Quantity (positive)
    - Destination Warehouse ID
    - Location ID
    - Executor ID
    - Timestamp

### Step 8: Update Inbound Request Status
- System updates inbound request:
  - Status: "Completed"
  - Completed By: Current user's ID
  - Completed Date: Current timestamp
  - Actual received quantities

### Step 9: Complete Transfer Request
- System updates Transfer Request:
  - Status: "Completed"
  - Completed Date: Current timestamp
- Both outbound and inbound now completed

### Step 10: Display Confirmation
- System displays: "Transfer inbound completed. Goods received at [Destination Warehouse]"
- Display summary of inventory changes
- Link to completed Transfer Request

---

## Alternative Flows

### A1: Quantity Discrepancy
- **Trigger:** Received quantity differs from expected
- **Steps:**
  1. System displays warning: "Received quantity differs from dispatched"
  2. Staff enters discrepancy reason:
     - Damage during transit
     - Missing items
     - Count error at source
  3. Continue with actual received quantity
  4. Discrepancy logged and reported
  5. Manager notified if significant variance

### A2: Damaged Goods
- **Trigger:** Some goods damaged during transit
- **Steps:**
  1. Staff notes damaged items
  2. Staff enters quantity of undamaged goods
  3. Staff creates damage report (if required)
  4. Only undamaged quantity added to inventory
  5. Discrepancy recorded

---

## Business Rules
| Rule ID | Description |
|---------|-------------|
| BR-TRI-001 | Staff at destination warehouse executes inbound |
| BR-TRI-002 | Inbound only available after outbound completion |
| BR-TRI-003 | Expected quantity based on actual dispatched |
| BR-TRI-004 | Destination inventory increases on completion |
| BR-TRI-005 | Transfer completes when inbound is done |
| BR-TRI-006 | Discrepancies must be documented |

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
Transfer Inbound: Approved → In Progress → Completed
Transfer Request: In Transit → Completed
```

---

## Inventory Impact
| Location | Action |
|----------|--------|
| Destination Warehouse | Increase inventory by received quantity |

---

## Inventory Consistency Check
```
Source Outbound Quantity == Destination Inbound Quantity
If not equal → Discrepancy reported
```

---

## UI Requirements
- Clear identification as transfer inbound
- Source warehouse and dispatch info displayed
- Expected quantities from outbound
- Editable received quantities
- Location assignment per item
- Discrepancy notes field
- Completion confirmation with summary
