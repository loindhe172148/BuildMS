# Detail Design Documents

## Overview

This folder contains detailed design documents for all use cases in the Smart Warehouse Management System (Smart WMS). Each use case is documented in a separate Markdown file following a consistent structure.

## Document Structure

Each use case document includes:

1. **Use Case Overview** - ID, name, actors, description, pre/post conditions
2. **Main Flow** - Step-by-step sequence of actions
3. **Alternative Flows** - Exception handling and alternate paths
4. **Business Rules** - Applicable rules and constraints
5. **Access Control** - Role-based permissions
6. **State Transitions** - State changes triggered by the use case
7. **UI Requirements** - Interface considerations

## Use Case Index

### Authentication & Authorization (UC-AUTH)
| ID | Name | File |
|----|------|------|
| UC-AUTH-001 | User Login | [UC-AUTH-001-User-Login.md](UC-AUTH-001-User-Login.md) |
| UC-AUTH-002 | Change Password | [UC-AUTH-002-Change-Password.md](UC-AUTH-002-Change-Password.md) |
| UC-AUTH-003 | Admin Reset Password | [UC-AUTH-003-Admin-Reset-Password.md](UC-AUTH-003-Admin-Reset-Password.md) |
| UC-AUTH-004 | User Logout | [UC-AUTH-004-User-Logout.md](UC-AUTH-004-User-Logout.md) |
| UC-AUTH-005 | Session Timeout | [UC-AUTH-005-Session-Timeout.md](UC-AUTH-005-Session-Timeout.md) |

### Inbound Management (UC-INB)
| ID | Name | File |
|----|------|------|
| UC-INB-001 | Create Inbound Request | [UC-INB-001-Create-Inbound-Request.md](UC-INB-001-Create-Inbound-Request.md) |
| UC-INB-002 | Approve Inbound Request | [UC-INB-002-Approve-Inbound-Request.md](UC-INB-002-Approve-Inbound-Request.md) |
| UC-INB-003 | Execute Inbound Request | [UC-INB-003-Execute-Inbound-Request.md](UC-INB-003-Execute-Inbound-Request.md) |

### Sales Order Management (UC-SO)
| ID | Name | File |
|----|------|------|
| UC-SO-001 | Create Sales Order | [UC-SO-001-Create-Sales-Order.md](UC-SO-001-Create-Sales-Order.md) |
| UC-SO-002 | Confirm Sales Order | [UC-SO-002-Confirm-Sales-Order.md](UC-SO-002-Confirm-Sales-Order.md) |
| UC-SO-003 | Generate Outbound from Sales Order | [UC-SO-003-Generate-Outbound-From-Sales-Order.md](UC-SO-003-Generate-Outbound-From-Sales-Order.md) |
| UC-SO-004 | Cancel Sales Order | [UC-SO-004-Cancel-Sales-Order.md](UC-SO-004-Cancel-Sales-Order.md) |

### Outbound Management (UC-OUT)
| ID | Name | File |
|----|------|------|
| UC-OUT-001 | Approve Outbound Request | [UC-OUT-001-Approve-Outbound-Request.md](UC-OUT-001-Approve-Outbound-Request.md) |
| UC-OUT-002 | Execute Outbound Request | [UC-OUT-002-Execute-Outbound-Request.md](UC-OUT-002-Execute-Outbound-Request.md) |
| UC-OUT-003 | Create Internal Outbound Request | [UC-OUT-003-Create-Internal-Outbound-Request.md](UC-OUT-003-Create-Internal-Outbound-Request.md) |

### Inter-Warehouse Transfer (UC-TRF)
| ID | Name | File |
|----|------|------|
| UC-TRF-001 | Create Transfer Request | [UC-TRF-001-Create-Transfer-Request.md](UC-TRF-001-Create-Transfer-Request.md) |
| UC-TRF-002 | Execute Transfer Outbound | [UC-TRF-002-Execute-Transfer-Outbound.md](UC-TRF-002-Execute-Transfer-Outbound.md) |
| UC-TRF-003 | Execute Transfer Inbound | [UC-TRF-003-Execute-Transfer-Inbound.md](UC-TRF-003-Execute-Transfer-Inbound.md) |

### Internal Movement (UC-MOV)
| ID | Name | File |
|----|------|------|
| UC-MOV-001 | Create Internal Movement | [UC-MOV-001-Create-Internal-Movement.md](UC-MOV-001-Create-Internal-Movement.md) |
| UC-MOV-002 | Execute Internal Movement | [UC-MOV-002-Execute-Internal-Movement.md](UC-MOV-002-Execute-Internal-Movement.md) |

### Warehouse Management (UC-WH)
| ID | Name | File |
|----|------|------|
| UC-WH-001 | Create Warehouse | [UC-WH-001-Create-Warehouse.md](UC-WH-001-Create-Warehouse.md) |
| UC-WH-002 | Update Warehouse | [UC-WH-002-Update-Warehouse.md](UC-WH-002-Update-Warehouse.md) |
| UC-WH-003 | View Warehouse List | [UC-WH-003-View-Warehouse-List.md](UC-WH-003-View-Warehouse-List.md) |

### Location Management (UC-LOC)
| ID | Name | File |
|----|------|------|
| UC-LOC-001 | Create Location | [UC-LOC-001-Create-Location.md](UC-LOC-001-Create-Location.md) |
| UC-LOC-002 | Update Location | [UC-LOC-002-Update-Location.md](UC-LOC-002-Update-Location.md) |
| UC-LOC-003 | Toggle Location Status | [UC-LOC-003-Toggle-Location-Status.md](UC-LOC-003-Toggle-Location-Status.md) |
| UC-LOC-004 | View Location List | [UC-LOC-004-View-Location-List.md](UC-LOC-004-View-Location-List.md) |

### Category Management (UC-CAT)
| ID | Name | File |
|----|------|------|
| UC-CAT-001 | Create Category | [UC-CAT-001-Create-Category.md](UC-CAT-001-Create-Category.md) |
| UC-CAT-002 | Update Category | [UC-CAT-002-Update-Category.md](UC-CAT-002-Update-Category.md) |
| UC-CAT-003 | Delete Category | [UC-CAT-003-Delete-Category.md](UC-CAT-003-Delete-Category.md) |
| UC-CAT-004 | View Category List | [UC-CAT-004-View-Category-List.md](UC-CAT-004-View-Category-List.md) |

### Product Management (UC-PRD)
| ID | Name | File |
|----|------|------|
| UC-PRD-001 | Create Product | [UC-PRD-001-Create-Product.md](UC-PRD-001-Create-Product.md) |
| UC-PRD-002 | Update Product | [UC-PRD-002-Update-Product.md](UC-PRD-002-Update-Product.md) |
| UC-PRD-003 | Toggle Product Status | [UC-PRD-003-Toggle-Product-Status.md](UC-PRD-003-Toggle-Product-Status.md) |
| UC-PRD-004 | View Product List | [UC-PRD-004-View-Product-List.md](UC-PRD-004-View-Product-List.md) |
| UC-PRD-005 | View Product Details | [UC-PRD-005-View-Product-Details.md](UC-PRD-005-View-Product-Details.md) |

### Customer Management (UC-CUS)
| ID | Name | File |
|----|------|------|
| UC-CUS-001 | Create Customer | [UC-CUS-001-Create-Customer.md](UC-CUS-001-Create-Customer.md) |
| UC-CUS-002 | Update Customer | [UC-CUS-002-Update-Customer.md](UC-CUS-002-Update-Customer.md) |
| UC-CUS-003 | Toggle Customer Status | [UC-CUS-003-Toggle-Customer-Status.md](UC-CUS-003-Toggle-Customer-Status.md) |
| UC-CUS-004 | View Customer List | [UC-CUS-004-View-Customer-List.md](UC-CUS-004-View-Customer-List.md) |

### User Management (UC-USER)
| ID | Name | File |
|----|------|------|
| UC-USER-001 | Create User | [UC-USER-001-Create-User.md](UC-USER-001-Create-User.md) |
| UC-USER-002 | Update User | [UC-USER-002-Update-User.md](UC-USER-002-Update-User.md) |
| UC-USER-003 | Toggle User Status | [UC-USER-003-Toggle-User-Status.md](UC-USER-003-Toggle-User-Status.md) |
| UC-USER-004 | View User List | [UC-USER-004-View-User-List.md](UC-USER-004-View-User-List.md) |
| UC-USER-005 | Assign User to Warehouse | [UC-USER-005-Assign-User-Warehouse.md](UC-USER-005-Assign-User-Warehouse.md) |

### Inventory Management (UC-INV)
| ID | Name | File |
|----|------|------|
| UC-INV-001 | View Inventory by Warehouse | [UC-INV-001-View-Inventory-By-Warehouse.md](UC-INV-001-View-Inventory-By-Warehouse.md) |
| UC-INV-002 | View Inventory by Product | [UC-INV-002-View-Inventory-By-Product.md](UC-INV-002-View-Inventory-By-Product.md) |
| UC-INV-003 | Search Inventory | [UC-INV-003-Search-Inventory.md](UC-INV-003-Search-Inventory.md) |

## State Models Reference

### Request Lifecycle
```
Created → Approved → In Progress → Completed
              ↓
           Rejected
```

### Sales Order Lifecycle
```
Draft → Confirmed → Fulfillment Requested → Partially Shipped → Completed
  ↓         ↓               ↓                      ↓
Cancelled  Cancelled     Cancelled              Cancelled
```

## Role Summary

| Role | Primary Responsibilities |
|------|--------------------------|
| Admin | System configuration, user management, full access |
| Manager | Request creation, approval, inventory oversight |
| Staff | Request execution, physical operations |
| Sales | Sales order management (no warehouse access) |

## Notes

- These documents describe **behavior and flow only**
- Entity/database models are defined in [database/schema.sql](../../database/schema.sql)
- Business rules follow the SRS in [document/SRS.md](../SRS.md)
- No source code is included in these documents
