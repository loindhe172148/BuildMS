# UC-MOV-001: Create Internal Movement Request

## Use Case Overview
| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-MOV-001 |
| **Use Case Name** | Create Internal Movement Request |
| **Primary Actor** | Staff |
| **Description** | Create a request to move goods between locations within the same warehouse |
| **Preconditions** | Staff is logged in; Warehouse has multiple locations; Inventory exists at source location |
| **Postconditions** | Internal movement request created |

---

## Main Flow

### Step 1: Navigate to Internal Movement
- Staff navigates to Internal Movement section
- System displays list of internal movement requests

### Step 2: Initiate New Movement
- Staff clicks "Create Internal Movement" button
- System displays movement creation form

### Step 3: Display Creation Form
- System displays form with fields:
  - Warehouse (dropdown or auto-selected based on Staff assignment)
  - Movement Items section
  - Reason/Notes (text area, optional)

### Step 4: Select/Confirm Warehouse
- Staff confirms or selects warehouse
- System loads locations within the warehouse

### Step 5: Add Movement Items
- Staff clicks "Add Item" button
- For each item:
  - Product (dropdown/search, required)
  - Source Location (dropdown, required)
  - Destination Location (dropdown, required)
  - Quantity (number, required, > 0)
  - Current quantity at source location displayed
- Staff can add multiple items
- If no items → **Alternative Flow A1**

### Step 6: Validate Movement Items
- **Validation Rules:**
  - Product must be selected
  - Source and destination locations must be different
  - Quantity must be positive
  - Quantity cannot exceed available at source location
  - Locations must be within same warehouse
- If validation fails → **Alternative Flow A2**

### Step 7: Submit Request
- Staff clicks "Submit" button
- System performs final validation

### Step 8: Create Movement Request Record
- System creates Request record with:
  - Request Type: "Internal Movement"
  - Status: "Created"
  - Warehouse ID
  - Created By: Staff's User ID
  - Created Date: Current timestamp
  - Notes

### Step 9: Create Movement Items
- For each item:
  - System creates RequestItem record:
    - Request ID
    - Product ID
    - Source Location ID
    - Destination Location ID
    - Quantity

### Step 10: Display Confirmation
- System displays: "Internal Movement Request [ID] created"
- Request may auto-execute or require approval based on configuration

---

## Alternative Flows

### A1: No Items Added
- **Trigger:** Staff submits without items
- **Steps:**
  1. System displays error: "At least one movement item is required"
  2. Return to Step 5

### A2: Validation Failed
- **Trigger:** Validation rules not met
- **Steps:**
  1. System displays specific errors:
     - "Source and destination locations must be different"
     - "Quantity exceeds available at source location"
     - "Locations must be in the same warehouse"
  2. Return to Step 5

---

## Business Rules
| Rule ID | Description |
|---------|-------------|
| BR-MOV-001 | Staff can create internal movement requests |
| BR-MOV-002 | Movement within same warehouse only |
| BR-MOV-003 | Source and destination must be different |
| BR-MOV-004 | Quantity limited by source availability |
| BR-MOV-005 | Total warehouse inventory unchanged |

---

## Access Control
| Role | Permission |
|------|------------|
| Admin | ✓ Can create movements |
| Manager | ✓ Can create movements |
| Staff | ✓ Can create movements |
| Sales | ✗ Cannot create movements |

---

## Location Hierarchy
```
Warehouse
├── Zone A
│   ├── Location A-01
│   ├── Location A-02
├── Zone B
│   ├── Location B-01
│   ├── Location B-02
```

---

## UI Requirements
- Warehouse selection or auto-detection
- Location dropdowns filtered by warehouse
- Product search with location-specific inventory
- Quantity validation against source
- Visual representation of from/to locations
- Submit and Cancel buttons
