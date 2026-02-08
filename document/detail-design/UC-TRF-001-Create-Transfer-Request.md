# UC-TRF-001: Create Inter-Warehouse Transfer Request

## Use Case Overview
| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-TRF-001 |
| **Use Case Name** | Create Inter-Warehouse Transfer Request |
| **Primary Actor** | Manager |
| **Description** | Create a request to transfer goods between warehouses |
| **Preconditions** | Manager is logged in; At least two warehouses exist; Products exist |
| **Postconditions** | Transfer request created; Linked outbound and inbound requests generated |

---

## Main Flow

### Step 1: Navigate to Transfer Requests
- Manager navigates to Transfer Management section
- System displays list of transfer requests

### Step 2: Initiate New Transfer
- Manager clicks "Create Transfer Request" button
- System displays transfer creation form

### Step 3: Display Creation Form
- System displays form with fields:
  - Source Warehouse (dropdown, required)
  - Destination Warehouse (dropdown, required)
  - Expected Transfer Date (date picker, optional)
  - Notes/Reason (text area, optional)
  - Transfer Items section

### Step 4: Select Source Warehouse
- Manager selects source warehouse from dropdown
- System loads available inventory for this warehouse

### Step 5: Select Destination Warehouse
- Manager selects destination warehouse from dropdown
- System validates destination is different from source
- If same warehouse → **Alternative Flow A1**

### Step 6: Add Transfer Items
- Manager clicks "Add Item" button
- For each item:
  - Product (dropdown/search, required)
  - Quantity (number, required, > 0)
  - Available at source (displayed, informational)
- Manager can add multiple items
- If no items added → **Alternative Flow A2**

### Step 7: Validate Transfer Items
- **Validation Rules:**
  - Product must be selected and active
  - Quantity must be positive integer
  - No duplicate products
  - Quantity should not exceed source availability (warning)
- If validation fails → **Alternative Flow A3**

### Step 8: Submit Transfer Request
- Manager clicks "Submit" button
- System performs final validation

### Step 9: Create Transfer Request Record
- System creates Transfer Request record with:
  - Request Type: "Transfer"
  - Status: "Created"
  - Source Warehouse ID
  - Destination Warehouse ID
  - Created By: Current Manager's ID
  - Created Date: Current timestamp
  - Expected Date (if provided)
  - Notes

### Step 10: Generate Outbound Request
- System creates linked Outbound Request:
  - Request Type: "Outbound" (Transfer)
  - Status: "Created"
  - Source Warehouse ID
  - Reference: Transfer Request ID
  - Items: Same as transfer items

### Step 11: Generate Inbound Request
- System creates linked Inbound Request:
  - Request Type: "Inbound" (Transfer)
  - Status: "Created" (or "Pending" until outbound completes)
  - Destination Warehouse ID
  - Reference: Transfer Request ID
  - Items: Same as transfer items

### Step 12: Display Confirmation
- System displays success message: "Transfer Request [ID] created successfully"
- Display linked request IDs (outbound and inbound)

---

## Alternative Flows

### A1: Same Source and Destination
- **Trigger:** Manager selects same warehouse for both
- **Steps:**
  1. System displays error: "Source and destination warehouses must be different"
  2. Return to Step 5

### A2: No Items Added
- **Trigger:** Manager submits without items
- **Steps:**
  1. System displays error: "At least one item is required"
  2. Return to Step 6

### A3: Item Validation Failed
- **Trigger:** Validation rules not met
- **Steps:**
  1. System displays errors for invalid items
  2. Warning for insufficient inventory (non-blocking)
  3. Return to Step 6

---

## Business Rules
| Rule ID | Description |
|---------|-------------|
| BR-TRF-001 | Only Manager can create transfer requests |
| BR-TRF-002 | Source and destination must be different |
| BR-TRF-003 | Transfer generates linked outbound and inbound requests |
| BR-TRF-004 | Inventory consistency maintained across warehouses |
| BR-TRF-005 | Outbound must complete before inbound can execute |

---

## Access Control
| Role | Permission |
|------|------------|
| Admin | ✓ Can create transfer requests |
| Manager | ✓ Can create transfer requests |
| Staff | ✗ Cannot create transfer requests |
| Sales | ✗ Cannot create transfer requests |

---

## Linked Request Lifecycle
```
Transfer Request Created
    ├── Outbound Request (Source) → Created → Approved → Completed
    └── Inbound Request (Destination) → Created → (waits) → Approved → Completed

Outbound completion triggers Inbound availability for execution
```

---

## UI Requirements
- Clear source/destination selection
- Different warehouse validation
- Product search with source inventory display
- Quantity validation
- Linked request preview before submission
- Submit and Cancel buttons
