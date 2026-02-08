# UC-SO-001: Create Sales Order

## Use Case Overview
| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-SO-001 |
| **Use Case Name** | Create Sales Order |
| **Primary Actor** | Sales |
| **Secondary Actor** | Manager |
| **Description** | Create a new sales order as a trigger for outbound fulfillment |
| **Preconditions** | User is logged in with Sales or Manager role; Customer exists; Products exist |
| **Postconditions** | Sales Order is created with status "Draft" |

---

## Main Flow

### Step 1: Navigate to Sales Orders
- Sales user navigates to Sales Order Management section
- System displays list of existing sales orders

### Step 2: Initiate New Order
- Sales clicks "Create New Sales Order" button
- System displays sales order creation form

### Step 3: Display Creation Form
- System displays form with fields:
  - Customer (dropdown/search, required)
  - Order Date (date, defaults to today)
  - Required Delivery Date (date picker, optional)
  - Notes (text area, optional)
  - Order Items section

### Step 4: Select Customer
- Sales selects customer from dropdown or searches
- System validates customer is active
- If no customers available → **Alternative Flow A1**

### Step 5: Add Order Items
- Sales clicks "Add Item" button
- For each item, Sales specifies:
  - Product (dropdown/search, required)
  - Quantity (number, required, > 0)
- Sales can add multiple items
- If no items added → **Alternative Flow A2**

### Step 6: Validate Order Items
- **Validation Rules per item:**
  - Product must be selected and active
  - Quantity must be positive integer
  - No duplicate products in same order
- If validation fails → **Alternative Flow A3**
- Note: Inventory availability is NOT checked at this stage

### Step 7: Submit Order
- Sales clicks "Save as Draft" or "Submit" button
- System performs final validation

### Step 8: Create Sales Order Record
- System creates SalesOrder record with:
  - Status: "Draft"
  - Customer ID
  - Order Date
  - Required Delivery Date (if provided)
  - Created By: Current user's ID
  - Created Date: Current timestamp
  - Notes (if provided)

### Step 9: Create Order Items
- For each item:
  - System creates SalesOrderItem record with:
    - SalesOrder ID (link to parent)
    - Product ID
    - Quantity
    - Fulfilled Quantity: 0 (initial)

### Step 10: Display Confirmation
- System displays success message: "Sales Order [ID] created successfully"
- System redirects to order detail page

---

## Alternative Flows

### A1: No Customers Available
- **Trigger:** No active customers in system
- **Steps:**
  1. System displays message: "No customers available. Please create a customer first."
  2. Provide link to Customer Management (if user has permission)

### A2: No Items Added
- **Trigger:** Sales tries to submit without adding items
- **Steps:**
  1. System displays error: "At least one item is required"
  2. Return to Step 5

### A3: Item Validation Failed
- **Trigger:** Item validation rules not met
- **Steps:**
  1. System displays specific errors:
     - "Please select a product"
     - "Quantity must be greater than 0"
     - "Product [name] is already in the order"
  2. System highlights invalid items
  3. Return to Step 5

---

## Business Rules
| Rule ID | Description |
|---------|-------------|
| BR-SO-001 | Only Sales and Manager can create sales orders |
| BR-SO-002 | Sales Order must have at least one item |
| BR-SO-003 | Sales Order does NOT modify inventory directly |
| BR-SO-004 | All quantities must be positive integers |
| BR-SO-005 | Order is created with status "Draft" |
| BR-SO-006 | Inventory availability is checked by Manager later |

---

## Access Control
| Role | Permission |
|------|------------|
| Admin | ✓ Can create sales orders |
| Manager | ✓ Can create sales orders |
| Staff | ✗ Cannot create sales orders |
| Sales | ✓ Can create sales orders |

---

## State: Initial Status
- Sales Order starts as "Draft"
- Can be edited while in Draft status
- Must be Confirmed before fulfillment

---

## UI Requirements
- Clean order form with customer selection
- Dynamic item list with add/remove
- Product search with availability display (informational only)
- Quantity input validation
- Save as Draft button
- Cancel button to discard

---

## Important Notes
- **No inventory impact** at order creation
- **No inventory validation** at order creation
- Manager will verify availability when generating outbound request
