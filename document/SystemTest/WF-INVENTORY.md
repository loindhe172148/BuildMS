# WF-INVENTORY – Inventory Tracking

| | | | | | | | | | | | | | | | |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| **Workflow** | WF-INVENTORY – Inventory Tracking | | | | | | | | | | | | | | **Passed** |
| **Test requirement** | Tests covering inventory viewing and searching (UC-INV-001 to UC-INV-003). Verifies that Manager and Staff can view real-time inventory by warehouse, by product, and search across inventory. Verifies that Admin and Sales cannot access inventory views (per SRS access control matrix). | | | | | | | | | | | | | | **Failed** |
| **Number of TCs** | 8 | | | | | | | | | | | | | | **Pending** |
| **Testing Round** | Passed | Failed | Pending | | | | | | | | | | | | |
| Round 1 | 0 | 0 | 8 | 0 | | | | | | | | | | | |
| Round 2 | 0 | 0 | 8 | 0 | | | | | | | | | | | |
| Round 3 | 0 | 0 | 8 | 0 | | | | | | | | | | | |

| Test Case ID | Test Case Description | Test Case Procedure | Expected Results | Pre-conditions | Round 1 | Test date | Tester | Round 2 | Test date | Tester | Round 3 | Test date | Tester | Note | |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| **Scenario A: View Inventory by Warehouse (UC-INV-001)** | | | | | | | | | | | | | | | |
| TC-INV-001 | Manager views inventory for their assigned warehouse | 1. Login as `manager`<br>2. Navigate to Inventory Management → "By Warehouse"<br>3. Select warehouse from dropdown | - Inventory table displayed showing: Product Name, SKU, Location Code, Quantity<br>- Only inventory for selected warehouse is shown<br>- Real-time quantities visible | Manager logged in; inventory exists in warehouse | Pending | | | Pending | | | Pending | | | | |
| TC-INV-002 | Staff views inventory by warehouse | 1. Login as `staff`<br>2. Navigate to Inventory Management → "By Warehouse"<br>3. Select a warehouse | - Inventory displayed correctly for Staff role<br>- Read-only view (no create/edit controls) | Staff logged in; inventory data exists | Pending | | | Pending | | | Pending | | | | |
| **Scenario B: View Inventory by Product (UC-INV-002)** | | | | | | | | | | | | | | | |
| TC-INV-003 | Manager views inventory grouped by product | 1. Login as `manager`<br>2. Navigate to Inventory Management → "By Product"<br>3. Browse the product inventory view | - Table shows each product with total quantity across all warehouses<br>- Can expand to see per-warehouse/per-location breakdown<br>- Pagination works | Manager logged in; inventory across multiple warehouses exists | Pending | | | Pending | | | Pending | | | | |
| TC-INV-004 | Inventory reflects correct quantity after an inbound execution | 1. Record product quantity before test (e.g., 50 units)<br>2. Execute an inbound request adding 20 units<br>3. Navigate to Inventory → By Product<br>4. Find the product | - Product quantity shows 70 (50 + 20)<br>- Per-warehouse breakdown updated | Inbound request for known product completed | Pending | | | Pending | | | Pending | | | | |
| **Scenario C: Search Inventory (UC-INV-003)** | | | | | | | | | | | | | | | |
| TC-INV-005 | Manager searches inventory by product name | 1. Login as `manager`<br>2. Navigate to Inventory → Search<br>3. Enter product name or partial name in search field<br>4. Click "Search" | - Matching inventory records displayed<br>- Non-matching records hidden<br>- Empty search returns all records | Manager logged in; inventory with named products exists | Pending | | | Pending | | | Pending | | | | |
| TC-INV-006 | Manager searches inventory by product SKU | 1. Login as `manager`<br>2. Navigate to Inventory → Search<br>3. Enter exact SKU in search field<br>4. Click "Search" | - Inventory records for that SKU shown<br>- Qty-per-warehouse and location details visible | Manager logged in; product with known SKU has inventory | Pending | | | Pending | | | Pending | | | | |
| **Scenario D: Access Control for Inventory** | | | | | | | | | | | | | | | |
| TC-INV-007 | Admin cannot access Inventory views | 1. Login as `admin`<br>2. Attempt to navigate to `/inventory` | - Access denied (per SRS access control matrix: Admin does not have Inventory View permission)<br>- Redirect to 403 or dashboard | Admin logged in | Pending | | | Pending | | | Pending | | | | |
| TC-INV-008 | Sales user cannot access Inventory views | 1. Login as `sales`<br>2. Attempt to navigate to `/inventory?action=byProduct` | - Access denied<br>- Redirect to error page | Sales user logged in | Pending | | | Pending | | | Pending | | | | |
