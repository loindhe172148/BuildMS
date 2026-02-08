# UC-MOV-002: Execute Internal Movement

## Use Case Overview
| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-MOV-002 |
| **Use Case Name** | Execute Internal Movement |
| **Primary Actor** | Staff |
| **Description** | Physically move goods between locations and update system records |
| **Preconditions** | Staff is logged in; Movement request exists and is approved/ready |
| **Postconditions** | Goods moved; Location data updated; Request completed |

---

## Main Flow

### Step 1: Navigate to Movement Requests
- Staff navigates to Internal Movement section
- System displays list of movement requests
- Staff filters by status "Approved" or "Created" (based on workflow)

### Step 2: Select Request to Execute
- Staff clicks on a movement request
- System displays request detail page

### Step 3: Display Movement Details
- System displays:
  - Request ID
  - Warehouse
  - Status
  - Created by and date
  - Movement items:
    - Product name
    - Source location (with current quantity)
    - Destination location
    - Quantity to move
    - Movement status per item

### Step 4: Start Execution
- Staff clicks "Start Movement" button
- System updates request status to "In Progress"
- System records start timestamp

### Step 5: Execute Each Movement Item
- For each item:
  - Staff navigates to source location
  - Staff picks the specified quantity
  - Staff transports to destination location
  - Staff places items at destination
  - Staff marks item as moved in system
  - Staff can add notes if needed

### Step 6: Validate Movement
- **Validation per item:**
  - Moved quantity matches requested
  - Source still has sufficient inventory
- If discrepancy → **Alternative Flow A1**

### Step 7: Complete Movement
- Staff confirms all items moved
- Staff clicks "Complete Movement" button

### Step 8: Update Location Data
- For each moved item:
  - System decreases inventory at source location
  - System increases inventory at destination location
  - System creates location transaction record:
    - Type: "Internal Movement"
    - Request ID reference
    - Product ID
    - Source Location ID
    - Destination Location ID
    - Quantity
    - Executed By
    - Timestamp

### Step 9: Update Request Status
- System updates request record:
  - Status: "Completed"
  - Completed By: Staff's User ID
  - Completed Date: Current timestamp

### Step 10: Display Confirmation
- System displays: "Internal Movement [ID] completed successfully"
- Display summary of location changes

---

## Alternative Flows

### A1: Movement Discrepancy
- **Trigger:** Actual quantity differs from requested
- **Steps:**
  1. Staff enters actual moved quantity
  2. Staff provides reason for discrepancy
  3. System updates with actual quantity
  4. Discrepancy logged for review
  5. Continue with actual quantities

### A2: Source Inventory Changed
- **Trigger:** Source location inventory insufficient (concurrent changes)
- **Steps:**
  1. System displays warning: "Insufficient inventory at source"
  2. Staff can:
     - Move available quantity (partial)
     - Cancel movement for this item
     - Investigate discrepancy
  3. Continue with available quantity

---

## Business Rules
| Rule ID | Description |
|---------|-------------|
| BR-MXE-001 | Staff executes internal movements |
| BR-MXE-002 | Total warehouse inventory unchanged |
| BR-MXE-003 | Only location quantities change |
| BR-MXE-004 | Movement history recorded for traceability |

---

## Access Control
| Role | Permission |
|------|------------|
| Admin | ✓ Can execute movements |
| Manager | ✓ Can execute movements |
| Staff | ✓ Can execute movements |
| Sales | ✗ Cannot execute movements |

---

## State Transition
```
Created/Approved → In Progress (Staff starts)
In Progress → Completed (Staff completes)
```

---

## Inventory Impact
| Location | Action |
|----------|--------|
| Source Location | Decrease quantity by moved amount |
| Destination Location | Increase quantity by moved amount |
| Warehouse Total | No change |

---

## Location History Update
- Record product movement between locations
- Maintain location history for each product
- Enable location tracking and optimization

---

## UI Requirements
- Clear from/to location display
- Current quantities at both locations
- Progress indicator for multi-item movements
- Editable quantity for discrepancies
- Notes field
- Complete button with confirmation
- Movement history visible
