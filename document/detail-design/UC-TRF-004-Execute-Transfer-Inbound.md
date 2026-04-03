# UC-TRF-004: Execute Transfer Inbound & Complete

## Use Case Overview
| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-TRF-004 |
| **Use Case Name** | Execute Transfer Inbound & Complete |
| **Primary Actor** | Staff / Manager (at destination warehouse) |
| **Description** | Staff at the **destination warehouse** receives transferred goods, adds them to inventory, and completes the transfer. Only the destination warehouse can execute this step, and only after the source warehouse has completed outbound (UC-TRF-003). |
| **Preconditions** | User is logged in; Transfer request is "InTransit" (outbound completed by source WH); User belongs to the destination warehouse or is Admin |
| **Postconditions** | Inbound completed; Inventory increased at destination warehouse; Transfer status becomes "Completed" |

---

## Key Principle

> **The destination warehouse receives goods and completes the transfer.**
>
> Source WH completed outbound → Dest WH receives & inspects goods →
> Dest WH assigns storage locations → Dest WH completes the transfer.

---

## Main Flow

### Step 1: Navigate to InTransit Transfers
- Staff/Manager at destination warehouse navigates to Transfer Management
- System displays transfers where user's warehouse is the **destination** and status is "InTransit"
- Staff selects a transfer to execute inbound

### Step 2: Display Request for Execution
- System displays:
  - Transfer Request ID
  - Status: "InTransit"
  - Source warehouse (origin)
  - Destination warehouse (user's warehouse)
  - Outbound completed by (source WH user)
  - Outbound completion date
  - Items to receive:
    - Product name, SKU
    - Expected quantity (actual picked quantity from outbound)
    - Target location at destination (to be assigned)
    - Receive status

### Step 3: Start Receiving
- Staff clicks "Start Receiving" button
- System updates transfer request status: **"InTransit" → "Receiving"**
- System records start timestamp and executor ID

### Step 4: Receive Items
- For each item:
  - Staff inspects received goods
  - Staff counts quantity
  - Staff enters received quantity
  - Staff assigns/selects storage location at destination warehouse
  - Staff notes any issues (damage, missing items)

### Step 5: Validate Received Quantities
- **Validation Rules:**
  - Received quantity >= 0
  - Each item must have a destination location assigned
  - Location must be active and belong to destination warehouse
  - Warning if received quantity differs from expected (dispatched)
- If discrepancy → **Alternative Flow A1**

### Step 6: Complete Receiving & Complete Transfer
- Staff confirms all items received and locations assigned
- Staff clicks "Complete Receiving" button

### Step 7: Update Destination Inventory
- For each received item:
  - System increases inventory at destination warehouse at the assigned location
  - If inventory record exists at (productId, warehouseId, locationId) → add quantity
  - If not exists → create new inventory record

### Step 8: Update Transfer Request Status — COMPLETE
- System updates transfer request:
  - Status: **"Completed"**
  - Completed By: Current user's ID (destination WH staff)
  - Completed Date: Current timestamp
  - Actual received quantities recorded
- **The destination warehouse completes the entire transfer**

### Step 9: Display Confirmation
- System displays: "Transfer completed. Goods received at [Destination Warehouse]"
- Display summary of inventory changes (items, quantities, locations)
- Link to completed Transfer Request detail view

---

## Alternative Flows

### A1: Quantity Discrepancy
- **Trigger:** Received quantity differs from expected (dispatched)
- **Steps:**
  1. System displays warning: "Received quantity differs from dispatched"
  2. Staff enters discrepancy reason:
     - Damage during transit
     - Missing items
     - Count error at source
  3. Continue with actual received quantity
  4. Only actual received quantity added to inventory
  5. Discrepancy logged

### A2: Damaged Goods
- **Trigger:** Some goods damaged during transit
- **Steps:**
  1. Staff notes damaged items
  2. Staff enters quantity of undamaged goods as received quantity
  3. Only undamaged quantity added to inventory
  4. Discrepancy recorded

### A3: No Permission (Not Destination Warehouse)
- **Trigger:** User's assigned warehouse is not the destination warehouse
- **Steps:**
  1. System displays error: "Only destination warehouse staff can execute transfer inbound"
  2. Redirect to transfer list

### A4: Transfer Not InTransit
- **Trigger:** Transfer status is not "InTransit" or "Receiving"
- **Steps:**
  1. System displays error: "Source warehouse must complete outbound before inbound can be executed"
  2. Redirect to transfer detail

---

## Business Rules
| Rule ID | Description |
|---------|-------------|
| BR-TRI-001 | **Only Staff/Manager at the destination warehouse can execute inbound** |
| BR-TRI-002 | Admin can execute inbound for any transfer |
| BR-TRI-003 | Inbound can only start when transfer status is "InTransit" (outbound completed by source WH) |
| BR-TRI-004 | Expected receive quantity is based on actual picked quantity from outbound |
| BR-TRI-005 | Destination inventory increases by received quantity on completion |
| BR-TRI-006 | **Destination warehouse completes the entire transfer** (status → "Completed") |
| BR-TRI-007 | Each item must be assigned a storage location at the destination warehouse |
| BR-TRI-008 | Discrepancies between dispatched and received quantities must be documented |

---

## Access Control
| Role | Permission |
|------|------------|
| Admin | ✓ Can execute inbound for any transfer |
| Manager | ✓ Can execute inbound only for transfers to their assigned warehouse (destination) |
| Staff | ✓ Can execute inbound only for transfers to their assigned warehouse (destination) |
| Sales | ✗ Cannot execute |

### Warehouse-Specific Access (Manager/Staff)
| User's Warehouse | Transfer Source WH | Transfer Dest WH | Can Execute Inbound? |
|------------------|-------------------|-------------------|---------------------|
| WH-A | WH-A | WH-B | ✗ No (user is at source, not destination) |
| WH-B | WH-A | WH-B | ✓ Yes (user is at destination) |
| WH-C | WH-A | WH-B | ✗ No (user is at unrelated warehouse) |

---

## State Transition
```
Transfer Request: InTransit ──[Dest WH starts receiving]──→ Receiving
                  Receiving ──[Dest WH completes receiving]──→ Completed
```

---

## Inventory Impact
| Location | Action |
|----------|--------|
| Destination Warehouse | Increase inventory by received quantity at assigned locations |

---

## Inventory Consistency Check
```
Source Outbound Picked Quantity vs. Destination Inbound Received Quantity
If not equal → Discrepancy logged and reported
```

---

## Complete Transfer Flow Summary
```
1. Source WH creates transfer                          → Status: Created
2. Destination WH Manager approves (UC-TRF-002)       → Status: Approved
3. Source WH Staff starts outbound (UC-TRF-003)        → Status: InProgress
4. Source WH Staff completes outbound                  → Status: InTransit
5. Destination WH Staff starts inbound (this UC)       → Status: Receiving
6. Destination WH Staff completes inbound              → Status: Completed ✓
```

---

## UI Requirements
- Transfer list shows "Execute Inbound" action for eligible transfers (status "InTransit"/"Receiving", user is destination WH)
- Clear identification as transfer inbound operation
- Source warehouse and outbound dispatch info displayed
- Expected quantities from outbound (actual picked quantities)
- Editable received quantity per item
- Location assignment dropdown per item (destination warehouse locations only)
- Discrepancy notes field
- Completion confirmation with inventory change summary
- Final completion message indicating the transfer is fully done
