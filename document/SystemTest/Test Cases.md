# Test Cases

| | TEST CASE LIST | | | |
|:---|:---|:---|:---|:---|
| Project Name | Smart Warehouse Management System (Smart WMS) | | | |
| Project Code | BUILDMS | | | |
| Test Environment Setup Description | **Environment requirements for this system test:** | | | |
| | 1. **Server**: Apache Tomcat 10.1+ running on Windows, port 8080; Application deployed as `buildms.war` at `http://localhost:8080/buildms/` | | | |
| | 2. **Database**: Microsoft SQL Server 2019+ with database `smartwms_db`; schema.sql and full_seed_data.sql fully loaded; TCP/IP enabled on port 1433 | | | |
| | 3. **Web Browser**: Google Chrome (latest) or Microsoft Edge (latest); JavaScript enabled; No browser cache from previous test sessions | | | |
| | 4. **Build Tool**: Maven 3.8+ for building the WAR; Java JDK 17+ installed and JAVA_HOME set | | | |
| | 5. **Test Accounts**: admin/password123 (Admin), manager/password123 (Manager), staff/password123 (Staff), sales/password123 (Sales) pre-seeded in the database | | | |
| | > All test cases must be executed against a freshly-seeded database to avoid state conflicts. | | | |

| No | Function Name | Sheet Name | Description | Pre-Condition |
|:---|:---|:---|:---|:---|
| 1 | User Login | WF-AUTH | Test login with valid/invalid credentials, empty fields, inactive account | Test accounts exist in the database |
| 2 | User Logout | WF-AUTH | Test logout clears session | User is logged in |
| 3 | Change Password | WF-AUTH | Test changing own password, validation, wrong current password | User is logged in |
| 4 | Admin Reset Password | WF-AUTH | Admin resets another user's password | Admin is logged in; target user exists |
| 5 | Session Timeout | WF-AUTH | Test 30-minute inactivity session expiry | User is logged in |
| 6 | Create Category | WF-MASTER-DATA | Test category creation, duplicate name validation | Admin or Manager logged in |
| 7 | Update Category | WF-MASTER-DATA | Test category editing | Category exists in system |
| 8 | Delete Category | WF-MASTER-DATA | Test deletion with no products, deletion blocked with products | Category exists |
| 9 | View Category List | WF-MASTER-DATA | Test listing and filtering categories | At least one category exists |
| 10 | Create Product | WF-MASTER-DATA | Test product creation, SKU uniqueness | Admin or Manager logged in; category exists |
| 11 | Update Product | WF-MASTER-DATA | Test product update | Product exists |
| 12 | Toggle Product Status | WF-MASTER-DATA | Test activate/deactivate product | Product exists |
| 13 | View Product List | WF-MASTER-DATA | Test product listing, search/filter | Products exist |
| 14 | View Product Details | WF-MASTER-DATA | Test detailed product view with inventory levels | Product exists |
| 15 | Create Warehouse | WF-MASTER-DATA | Test warehouse creation | Admin or Manager logged in |
| 16 | Update Warehouse | WF-MASTER-DATA | Test warehouse update | Warehouse exists |
| 17 | View Warehouse List | WF-MASTER-DATA | Test warehouse listing | Warehouses exist |
| 18 | Create Location | WF-MASTER-DATA | Test location creation within warehouse | Warehouse exists |
| 19 | Update Location | WF-MASTER-DATA | Test location update | Location exists |
| 20 | Toggle Location Status | WF-MASTER-DATA | Test activate/deactivate, block deactivate of occupied location | Location exists |
| 21 | View Location List | WF-MASTER-DATA | Test location listing | Locations exist |
| 22 | Create User | WF-USER-MGMT | Test user creation, role assignment, duplicate username | Admin logged in |
| 23 | Update User | WF-USER-MGMT | Test user profile update | User exists |
| 24 | Toggle User Status | WF-USER-MGMT | Test activate/deactivate user | User exists |
| 25 | View User List | WF-USER-MGMT | Test user listing | Users exist |
| 26 | Assign User to Warehouse | WF-USER-MGMT | Test warehouse assignment | User and warehouse exist |
| 27 | Create Customer | WF-CUSTOMER-MGMT | Test customer creation, unique code | Sales, Manager, or Admin logged in |
| 28 | Update Customer | WF-CUSTOMER-MGMT | Test customer update | Customer exists |
| 29 | Toggle Customer Status | WF-CUSTOMER-MGMT | Test activate/deactivate customer | Customer exists |
| 30 | View Customer List | WF-CUSTOMER-MGMT | Test customer listing | Customers exist |
| 31 | Create Inbound Request | WF-INBOUND | Test inbound request creation, validation | Manager logged in; warehouse and products exist |
| 32 | Approve Inbound Request | WF-INBOUND | Test approve and reject, rejection reason required | Inbound request in "Created" status |
| 33 | Execute Inbound Request | WF-INBOUND | Test full execution, quantity discrepancy handling, inventory update | Inbound request in "Approved" status |
| 34 | View Inventory by Warehouse | WF-INVENTORY | Test inventory view filtered by warehouse | Staff or Manager logged in; inventory exists |
| 35 | View Inventory by Product | WF-INVENTORY | Test inventory view filtered by product | Inventory exists |
| 36 | Search Inventory | WF-INVENTORY | Test inventory search by SKU and product name | Inventory exists |
| 37 | Create Internal Movement | WF-MOVEMENT | Test internal location-to-location movement creation | Manager/Staff logged in; inventory at source location |
| 38 | Execute Internal Movement | WF-MOVEMENT | Test movement execution and location update | Movement request created |
| 39 | Create Internal Outbound Request | WF-OUTBOUND | Test non-sales outbound creation | Manager logged in |
| 40 | Approve Outbound Request | WF-OUTBOUND | Test approve and reject outbound | Outbound request in "Created" status |
| 41 | Execute Outbound Request | WF-OUTBOUND | Test pick and ship, insufficient inventory handling, inventory deduction | Outbound request in "Approved" status |
| 42 | Create Sales Order | WF-SALES-ORDER | Test SO creation, customer selection, item validation | Sales or Manager logged in; customer/products exist |
| 43 | Confirm Sales Order | WF-SALES-ORDER | Test Manager confirms a draft Sales Order | SO in "Draft" status |
| 44 | Generate Outbound from Sales Order | WF-SALES-ORDER | Test outbound generation from confirmed SO | SO in "Confirmed" status |
| 45 | Cancel Sales Order | WF-SALES-ORDER | Test cancellation, block cancellation of confirmed SO with dependent outbound | SO exists |
| 46 | Create Transfer Request | WF-TRANSFER | Test inter-warehouse transfer creation, same-warehouse validation | Manager logged in; 2+ warehouses exist |
| 47 | Approve Transfer Request | WF-TRANSFER | Test destination warehouse manager approves/rejects | Transfer in "Created" status |
| 48 | Execute Transfer Outbound | WF-TRANSFER | Test source warehouse outbound execution | Transfer in "Approved" status |
| 49 | Execute Transfer Inbound | WF-TRANSFER | Test destination warehouse inbound execution, inventory consistency | Transfer in "InTransit" status |
| 50 | Role-Based Access Control | WF-AUTH | Test unauthorized access redirects for all roles | Users with different roles exist |
