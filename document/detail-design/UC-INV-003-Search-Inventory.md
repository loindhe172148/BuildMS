# UC-INV-003: Search Inventory

## 1. Use Case Overview

| Field | Description |
|-------|-------------|
| **Use Case ID** | UC-INV-003 |
| **Use Case Name** | Search Inventory |
| **Actor(s)** | Admin, Manager, Staff |
| **Description** | User searches for inventory by product SKU, name, or location |
| **Trigger** | User uses inventory search functionality |
| **Pre-conditions** | - User is logged in with appropriate role |
| **Post-conditions** | - Matching inventory records are displayed |

---

## 2. Main Flow

| Step | Actor | System |
|------|-------|--------|
| 1 | User navigates to inventory search | System displays search form |
| 2 | User enters search criteria | System validates input |
| 3 | User clicks "Search" | System queries inventory |
| 4 | | System applies role-based filters |
| 5 | | System displays matching inventory records |
| 6 | User reviews search results | |
| 7 | User optionally clicks on a result | System navigates to detailed view |

---

## 3. Alternative Flows

### AF-1: No Results Found
| Step | Description |
|------|-------------|
| 4a | No inventory matches search criteria |
| 4b | System displays message: "No inventory found matching your search" |
| 4c | System suggests broadening search criteria |

### AF-2: Quick Search
| Step | Description |
|------|-------------|
| 1a | User uses quick search bar in header |
| 1b | User types search term and presses Enter |
| 1c | System performs search with default filters |
| 1d | Continue from step 5 |

### AF-3: Advanced Filters
| Step | Description |
|------|-------------|
| 2a | User clicks "Advanced Filters" |
| 2b | System shows additional filter options |
| 2c | User sets filters (warehouse, location, category, quantity range) |
| 2d | Continue from step 3 |

---

## 4. Business Rules

| Rule ID | Description |
|---------|-------------|
| BR-INV-001 | Staff can only search inventory in their assigned warehouse |
| BR-INV-002 | Admin and Manager can search all warehouses |
| BR-INV-005 | Search is case-insensitive |
| BR-INV-006 | Partial matches are supported |

---

## 5. Access Control

| Role | Access Level |
|------|--------------|
| Admin | Full access - search all warehouses |
| Manager | Full access - search all warehouses |
| Staff | Limited - search only assigned warehouse |
| Sales | No access |

---

## 6. Data Requirements

### Search Criteria
| Field | Type | Description |
|-------|------|-------------|
| Search Term | String | Match against SKU or product name |
| Warehouse | Dropdown | Filter by warehouse |
| Location | Dropdown | Filter by location |
| Category | Dropdown | Filter by product category |
| Min Quantity | Number | Minimum quantity filter |
| Max Quantity | Number | Maximum quantity filter |

### Result Fields
| Field | Description |
|-------|-------------|
| SKU | Product code |
| Product Name | Product description |
| Category | Product category |
| Warehouse | Warehouse name |
| Location | Location code |
| Quantity | Current stock level |
| Unit | Unit of measure |

---

## 7. UI Requirements

- Search bar prominently displayed
- Quick search in header/navbar
- Advanced filter collapsible panel
- Results in sortable data table
- Click on result to view details
- Clear filters button
- Export results option
- Pagination for large result sets
- Show result count
- For Staff: warehouse filter pre-set and locked
