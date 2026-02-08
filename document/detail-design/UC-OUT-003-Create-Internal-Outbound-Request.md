# UC-OUT-003: Create Internal Outbound Request

## Use Case Overview
| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-OUT-003 |
| **Use Case Name** | Create Internal Outbound Request |
| **Primary Actor** | Manager |
| **Description** | Create an outbound request not related to sales orders |
| **Preconditions** | Manager is logged in; Warehouse exists; Products exist |
| **Postconditions** | Internal outbound request created with status "Created" |

---

## Main Flow

### Step 1: Navigate to Outbound Requests
- Manager navigates to Outbound Management section
- System displays list of outbound requests

### Step 2: Initiate New Internal Request
- Manager clicks "Create Internal Outbound Request" button
- System displays request creation form

### Step 3: Display Creation Form
- System displays form with fields:
  - Source Warehouse (dropdown, required)
  - Outbound Reason (dropdown, required):
    - Damage/Disposal
    - Return to Supplier
    - Sample/Demo
    - Adjustment
    - Other
  - Description/Notes (text area, optional)
  - Request Items section

### Step 4: Select Source Warehouse
- Manager selects warehouse from dropdown
- System validates warehouse is active

### Step 5: Select Outbound Reason
- Manager selects reason from predefined list
- If "Other" selected, description becomes required

### Step 6: Add Request Items
- Manager clicks "Add Item" button
- For each item:
  - Product (dropdown/search, required)
  - Quantity (number, required, > 0)
  - Current inventory displayed (informational)
- Manager can add multiple items
- If no items added → **Alternative Flow A1**

### Step 7: Validate Request Items
- **Validation Rules:**
  - Product must be selected and active
  - Quantity must be positive integer
  - No duplicate products in same request
  - Warning if quantity exceeds available inventory
- If validation fails → **Alternative Flow A2**

### Step 8: Submit Request
- Manager clicks "Submit" button
- System performs final validation

### Step 9: Create Request Record
- System creates Request record with:
  - Request Type: "Outbound" (Internal)
  - Status: "Created"
  - Source Warehouse ID
  - Outbound Reason
  - Reference: null (not sales-driven)
  - Created By: Current Manager's ID
  - Created Date: Current timestamp
  - Notes/Description

### Step 10: Create Request Items
- For each item:
  - System creates RequestItem record:
    - Request ID (link to parent)
    - Product ID
    - Quantity

### Step 11: Display Confirmation
- System displays success message: "Internal Outbound Request [ID] created successfully"
- Request requires approval before execution

---

## Alternative Flows

### A1: No Items Added
- **Trigger:** Manager tries to submit without items
- **Steps:**
  1. System displays error: "At least one item is required"
  2. Return to Step 6

### A2: Item Validation Failed
- **Trigger:** Validation rules not met
- **Steps:**
  1. System displays errors:
     - "Please select a product"
     - "Quantity must be greater than 0"
     - "Product already in request"
  2. Inventory warning (if applicable)
  3. Return to Step 6

---

## Business Rules
| Rule ID | Description |
|---------|-------------|
| BR-INT-001 | Only Manager can create internal outbound requests |
| BR-INT-002 | Internal requests have no sales order reference |
| BR-INT-003 | Outbound reason must be specified |
| BR-INT-004 | Request follows standard approval workflow |
| BR-INT-005 | Inventory check is informational only |

---

## Access Control
| Role | Permission |
|------|------------|
| Admin | ✓ Can create internal outbound |
| Manager | ✓ Can create internal outbound |
| Staff | ✗ Cannot create internal outbound |
| Sales | ✗ Cannot create internal outbound |

---

## Outbound Reasons
| Reason | Description |
|--------|-------------|
| Damage/Disposal | Remove damaged or expired inventory |
| Return to Supplier | Return goods to vendor |
| Sample/Demo | Items for demonstration purposes |
| Adjustment | Inventory correction |
| Other | Requires description |

---

## UI Requirements
- Clear form with reason selection
- Dynamic item list with add/remove
- Product search with current inventory display
- Quantity validation
- Inventory warnings (non-blocking)
- Submit and Cancel buttons
