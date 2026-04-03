# UC-TRF-003: Execute Transfer Outbound

## Use Case Overview
| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-TRF-003 |
| **Use Case Name** | Execute Transfer Outbound |
| **Primary Actor** | Staff / Manager (at source warehouse) |
| **Description** | Staff at the **source warehouse** picks and dispatches goods for the inter-warehouse transfer. Only the source warehouse can execute this step, and only after the destination warehouse has approved (UC-TRF-002). |
| **Preconditions** | User is logged in; Transfer request is "Approved" (by destination warehouse); User belongs to the source warehouse or is Admin |
| **Postconditions** | Outbound completed; Inventory reduced at source warehouse; Transfer status becomes "InTransit"; Destination warehouse can now execute inbound |

---

## Key Principle

> **The source warehouse executes outbound after destination warehouse approval.**
>
> Dest WH approved → Source WH picks & ships → Status becomes "InTransit" →
> Dest WH can then receive the goods.

---

## Main Flow

### Step 1: Navigate to Approved Transfers
- Staff/Manager at source warehouse navigates to Transfer Management
- System displays transfers where user's warehouse is the **source** and status is "Approved"
- Staff selects a transfer to execute outbound

### Step 2: Display Request for Execution
- System displays:
  - Transfer Request ID
  - Status: "Approved"
  - Source warehouse (user's warehouse)
  - Destination warehouse
  - Approved By (destination warehouse Manager)
  - Items to pick:
    - Product name, SKU
    - Quantity to transfer
    - Available inventory at source locations
    - Pick status

### Step 3: Start Execution
- Staff clicks "Start Picking" button
- System updates transfer request status: **"Approved" → "InProgress"**
- System records start timestamp and executor ID

### Step 4: Pick Items
- For each item:
  - Staff locates item at storage locations in source warehouse
  - Staff physically picks the item
  - Staff enters picked quantity
  - System shows available inventory across locations to fulfill the pick
  - Staff notes any issues (damage, shortage)

### Step 5: Validate Picked Quantities
- **Validation Rules:**
  - Picked quantity >= 0
  - Picked quantity <= available inventory at source
  - Warning if picked quantity differs from requested
- If discrepancy → **Alternative Flow A1**

### Step 6: Complete Outbound
- Staff confirms all items picked
- Staff clicks "Complete Outbound" / "Dispatch" button

### Step 7: Update Source Inventory
- For each picked item:
  - System decreases inventory at source warehouse
  - Deducts from appropriate location(s) using multi-location pattern
  - Records picked quantities on request items

### Step 8: Update Transfer Request Status
- System updates transfer request:
  - Status: **"InTransit"**
  - Completed By (outbound): Current user's ID
  - Outbound Completed Date: Current timestamp
  - Actual picked quantities recorded

### Step 9: Enable Destination Inbound
- Transfer status "InTransit" signals to the destination warehouse that goods are on the way
- Destination warehouse Staff/Manager can now execute inbound (UC-TRF-004)

### Step 10: Display Confirmation
- System displays: "Transfer outbound completed. Goods dispatched to [Destination Warehouse]"
- Inform user that destination warehouse will now receive the goods

---

## Alternative Flows

### A1: Quantity Discrepancy
- **Trigger:** Picked quantity differs from requested
- **Steps:**
  1. System displays warning
  2. Staff enters discrepancy reason
  3. Continue with actual picked quantity
  4. Inbound will expect the actual picked quantity (not original requested)
  5. Discrepancy logged

### A2: No Permission (Not Source Warehouse)
- **Trigger:** User's assigned warehouse is not the source warehouse
- **Steps:**
  1. System displays error: "Only source warehouse staff can execute transfer outbound"
  2. Redirect to transfer list

### A3: Transfer Not Approved
- **Trigger:** Transfer status is not "Approved" or "InProgress"
- **Steps:**
  1. System displays error: "Transfer must be approved before outbound can be executed"
  2. Redirect to transfer detail

---

## Business Rules
| Rule ID | Description |
|---------|-------------|
| BR-TRO-001 | **Only Staff/Manager at the source warehouse can execute outbound** |
| BR-TRO-002 | Admin can execute outbound for any transfer |
| BR-TRO-003 | Outbound can only start when transfer status is "Approved" (approved by destination WH) |
| BR-TRO-004 | Outbound completion changes status to "InTransit" |
| BR-TRO-005 | Source inventory decreases by picked quantity on completion |
| BR-TRO-006 | Actual picked quantities determine inbound expectations |
| BR-TRO-007 | Goods are "in transit" between outbound and inbound completion |

---

## Access Control
| Role | Permission |
|------|------------|
| Admin | ✓ Can execute outbound for any transfer |
| Manager | ✓ Can execute outbound only for transfers from their assigned warehouse (source) |
| Staff | ✓ Can execute outbound only for transfers from their assigned warehouse (source) |
| Sales | ✗ Cannot execute |

### Warehouse-Specific Access (Manager/Staff)
| User's Warehouse | Transfer Source WH | Transfer Dest WH | Can Execute Outbound? |
|------------------|-------------------|-------------------|----------------------|
| WH-A | WH-A | WH-B | ✓ Yes (user is at source) |
| WH-B | WH-A | WH-B | ✗ No (user is at destination, not source) |
| WH-C | WH-A | WH-B | ✗ No (user is at unrelated warehouse) |

---

## State Transition
```
Transfer Request: Approved ──[Source WH starts picking]──→ InProgress
                  InProgress ──[Source WH completes outbound]──→ InTransit
```

---

## Inventory Impact
| Location | Action |
|----------|--------|
| Source Warehouse | Decrease inventory by picked quantity |
| In Transit | Goods conceptually in transit (no DB inventory record) |
| Destination | No change yet (awaiting inbound — UC-TRF-004) |

---

## UI Requirements
- Transfer list shows "Execute Outbound" action for eligible transfers (status "Approved"/"InProgress", user is source WH)
- Clear identification as transfer outbound operation
- Destination warehouse displayed prominently
- Pick list with source warehouse locations and available quantities
- Multi-location pick support (iterate locations to fulfill quantity)
- Picked quantity validation
- Completion confirmation
- Success message with next-step information (destination warehouse inbound)
