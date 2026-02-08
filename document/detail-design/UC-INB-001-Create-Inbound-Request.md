# UC-INB-001: Create Inbound Request

## Use Case Overview
| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-INB-001 |
| **Use Case Name** | Create Inbound Request |
| **Primary Actor** | Manager |
| **Description** | Create a new request to receive goods into a warehouse |
| **Preconditions** | Manager is logged in; Warehouse exists; Products exist |
| **Postconditions** | Inbound request is created with status "Created" |

---

## Main Flow

### Step 1: Navigate to Inbound Requests
- Manager navigates to Inbound Management section
- System displays list of existing inbound requests

### Step 2: Initiate New Request
- Manager clicks "Create New Inbound Request" button
- System displays inbound request creation form

### Step 3: Display Creation Form
- System displays form with fields:
  - Destination Warehouse (dropdown, required)
  - Expected Delivery Date (date picker, optional)
  - Notes/Description (text area, optional)
  - Request Items section (add products)

### Step 4: Select Destination Warehouse
- Manager selects target warehouse from dropdown
- System validates warehouse is active

### Step 5: Add Request Items
- Manager clicks "Add Item" button
- For each item, Manager specifies:
  - Product (dropdown/search, required)
  - Quantity (number, required, > 0)
  - Target Location within warehouse (dropdown, optional)
- Manager can add multiple items
- If no items added → **Alternative Flow A1**

### Step 6: Validate Request Items
- **Validation Rules per item:**
  - Product must be selected and active
  - Quantity must be positive integer
  - No duplicate products in same request
- If validation fails → **Alternative Flow A2**

### Step 7: Submit Request
- Manager clicks "Submit" button
- System performs final validation

### Step 8: Create Request Record
- System creates Request record with:
  - Request Type: "Inbound"
  - Status: "Created"
  - Destination Warehouse ID
  - Created By: Current Manager's User ID
  - Created Date: Current timestamp
  - Expected Date (if provided)
  - Notes (if provided)

### Step 9: Create Request Items
- For each item:
  - System creates RequestItem record with:
    - Request ID (link to parent)
    - Product ID
    - Quantity
    - Target Location ID (if specified)

### Step 10: Display Confirmation
- System displays success message: "Inbound Request [ID] created successfully"
- System redirects to request detail page or list

---

## Alternative Flows

### A1: No Items Added
- **Trigger:** Manager tries to submit without adding any items
- **Steps:**
  1. System displays error: "At least one item is required"
  2. Return to Step 5

### A2: Item Validation Failed
- **Trigger:** Item validation rules not met
- **Steps:**
  1. System displays specific errors:
     - "Please select a product"
     - "Quantity must be greater than 0"
     - "Product [name] is already in the request"
  2. System highlights invalid items
  3. Return to Step 5

---

## Business Rules
| Rule ID | Description |
|---------|-------------|
| BR-INB-001 | Only Manager can create inbound requests |
| BR-INB-002 | Request must have at least one item |
| BR-INB-003 | All quantities must be positive integers |
| BR-INB-004 | Request is created with status "Created" |

---

## Access Control
| Role | Permission |
|------|------------|
| Admin | ✓ Can create inbound requests |
| Manager | ✓ Can create inbound requests |
| Staff | ✗ Cannot create inbound requests |
| Sales | ✗ Cannot create inbound requests |

---

## UI Requirements
- Clear form layout with sections
- Dynamic item list with add/remove functionality
- Product search/autocomplete for easy selection
- Quantity input with increment/decrement buttons
- Form validation feedback before submission
- Cancel button to discard and return to list
