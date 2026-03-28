# UC-TRF-001: Create Inter-Warehouse Transfer Request

## Use Case Overview
| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-TRF-001 |
| **Use Case Name** | Create Inter-Warehouse Transfer Request |
| **Primary Actor** | Manager (at source warehouse) |
| **Description** | Source warehouse creates a request to transfer goods to a destination warehouse. The destination warehouse must approve before execution can proceed. |
| **Preconditions** | User is logged in as Admin or Manager; At least two warehouses exist; Products exist in source warehouse |
| **Postconditions** | Transfer request created with status "Created"; Awaiting approval from destination warehouse |

---

## Transfer Workflow Overview

The inter-warehouse transfer follows a **cross-warehouse collaborative workflow**:

```
Source WH creates → Dest WH approves → Source WH executes outbound → Dest WH executes inbound & completes
```

| Phase | Actor | Status Transition |
|-------|-------|-------------------|
| 1. Create | Source WH Manager/Admin | → Created |
| 2. Approve/Reject | Destination WH Manager | Created → Approved / Rejected |
| 3. Execute Outbound | Source WH Staff/Manager | Approved → InProgress → InTransit |
| 4. Execute Inbound | Destination WH Staff/Manager | InTransit → Receiving → Completed |

---

## Main Flow

### Step 1: Navigate to Transfer Requests
- Manager at source warehouse navigates to Transfer Management section
- System displays list of transfer requests relevant to user's warehouse

### Step 2: Initiate New Transfer
- Manager clicks "Create Transfer Request" button
- System displays transfer creation form

### Step 3: Display Creation Form
- System displays form with fields:
  - Source Warehouse (dropdown, required)
    - **If Manager:** Auto-selected to Manager's assigned warehouse (read-only)
    - **If Admin:** All active warehouses shown
  - Destination Warehouse (dropdown, required)
  - Expected Transfer Date (date picker, optional)
  - Notes/Reason (text area, optional)
  - Transfer Items section

### Step 4: Select Source Warehouse
- **If Manager:** Source warehouse is pre-selected and locked to their assigned warehouse
- **If Admin:** Admin selects source warehouse from dropdown
- System loads available inventory for this warehouse

### Step 5: Select Destination Warehouse
- User selects destination warehouse from dropdown
- System validates destination is different from source
- If same warehouse → **Alternative Flow A1**

### Step 6: Add Transfer Items
- User clicks "Add Item" button
- For each item:
  - Product (dropdown/search, required) — filtered by source warehouse inventory
  - Quantity (number, required, > 0)
  - Available at source (displayed, informational)
- User can add multiple items
- If no items added → **Alternative Flow A2**

### Step 7: Validate Transfer Items
- **Validation Rules:**
  - Product must be selected and active
  - Quantity must be positive integer
  - No duplicate products
  - Quantity should not exceed source availability (warning, non-blocking)
- If validation fails → **Alternative Flow A3**

### Step 8: Submit Transfer Request
- User clicks "Submit" button
- System performs final validation

### Step 9: Create Transfer Request Record
- System creates a single Transfer Request record with:
  - Request Type: "Transfer"
  - Status: **"Created"**
  - Source Warehouse ID
  - Destination Warehouse ID
  - Created By: Current user's ID
  - Created Date: Current timestamp
  - Expected Date (if provided)
  - Notes
  - Request Items: list of (productId, quantity) pairs

### Step 10: Display Confirmation
- System displays success message: "Transfer Request [ID] created successfully"
- System informs: "Awaiting approval from destination warehouse"
- Redirect to transfer list or transfer detail view

---

## Alternative Flows

### A1: Same Source and Destination
- **Trigger:** User selects same warehouse for both
- **Steps:**
  1. System displays error: "Source and destination warehouses must be different"
  2. Return to Step 5

### A2: No Items Added
- **Trigger:** User submits without items
- **Steps:**
  1. System displays error: "At least one item is required"
  2. Return to Step 6

### A3: Item Validation Failed
- **Trigger:** Validation rules not met
- **Steps:**
  1. System displays specific errors for invalid items
  2. Warning for insufficient inventory (non-blocking)
  3. Return to Step 6

---

## Business Rules
| Rule ID | Description |
|---------|-------------|
| BR-TRF-001 | Only Admin and Manager can create transfer requests |
| BR-TRF-002 | Source and destination must be different warehouses |
| BR-TRF-003 | Manager can only create transfer requests with their assigned warehouse as **source** |
| BR-TRF-004 | Transfer request starts as "Created", requiring destination warehouse approval (see UC-TRF-002) |
| BR-TRF-005 | Outbound must complete before inbound can execute |
| BR-TRF-006 | Inventory consistency maintained across warehouses |
| BR-TRF-007 | Manager can only view/list transfer requests related to their assigned warehouse (source or destination) |
| BR-TRF-008 | A single Request record is used for the entire transfer lifecycle (no linked sub-requests) |

---

## Access Control
| Role | Permission |
|------|------------|
| Admin | ✓ Can create transfer requests (any source warehouse) |
| Manager | ✓ Can create transfer requests (own assigned warehouse as source only) |
| Staff | ✗ Cannot create transfer requests |
| Sales | ✗ Cannot create transfer requests |

---

## Transfer Status Flow
```
Created ──[Dest WH approves]──→ Approved ──[Source WH starts outbound]──→ InProgress
   │                                                                           │
   │                                                                    [Source WH completes outbound]
   │                                                                           │
   └──[Dest WH rejects]──→ Rejected                                      InTransit
                                                                               │
                                                                    [Dest WH starts inbound]
                                                                               │
                                                                          Receiving
                                                                               │
                                                                    [Dest WH completes inbound]
                                                                               │
                                                                          Completed
```

---

## UI Requirements
- Clear source/destination warehouse selection
- Source auto-locked to Manager's assigned warehouse
- Real-time different-warehouse validation
- Product search filtered by source warehouse inventory
- Available quantity displayed per product
- Quantity validation (positive integer)
- Submit and Cancel buttons
- Confirmation message indicating next step (destination warehouse approval)
