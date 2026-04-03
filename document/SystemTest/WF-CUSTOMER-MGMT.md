# WF-CUSTOMER-MGMT – Customer Management

| | | | | | | | | | | | | | | | |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| **Workflow** | WF-CUSTOMER-MGMT – Customer Management | | | | | | | | | | | | | | **Passed** |
| **Test requirement** | Tests covering Customer CRUD and status toggling (UC-CUS-001 to UC-CUS-004). Verifies that Sales, Manager, and Admin roles can create and update customers, that customer codes are unique, and that inactive customers cannot be referenced in new Sales Orders. | | | | | | | | | | | | | | **Failed** |
| **Number of TCs** | 8 | | | | | | | | | | | | | | **Pending** |
| **Testing Round** | Passed | Failed | Pending | | | | | | | | | | | | |
| Round 1 | 0 | 0 | 8 | 0 | | | | | | | | | | | |
| Round 2 | 0 | 0 | 8 | 0 | | | | | | | | | | | |
| Round 3 | 0 | 0 | 8 | 0 | | | | | | | | | | | |

| Test Case ID | Test Case Description | Test Case Procedure | Expected Results | Pre-conditions | Round 1 | Test date | Tester | Round 2 | Test date | Tester | Round 3 | Test date | Tester | Note | |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| **Scenario A: Create Customer (UC-CUS-001)** | | | | | | | | | | | | | | | |
| TC-CUS-001 | Sales user creates a new customer successfully | 1. Login as `sales`<br>2. Navigate to Customer Management → Create<br>3. Enter Customer Code: `CUST-TEST-001`<br>4. Enter Name: `Test Corp`<br>5. Enter contact info (phone, email, address)<br>6. Click "Save" | - Customer `Test Corp` created with status Active<br>- Success message displayed<br>- Appears in customer list | Sales user logged in | Pending | | | Pending | | | Pending | | | | |
| TC-CUS-002 | Creating a customer with duplicate code is rejected | 1. Login as `sales`<br>2. Navigate to Create Customer<br>3. Enter Customer Code that already exists<br>4. Click "Save" | - Creation rejected<br>- Error: "Customer code already exists"<br>- No duplicate customer created | Customer with same code exists | Pending | | | Pending | | | Pending | | | | |
| **Scenario B: Update Customer (UC-CUS-002)** | | | | | | | | | | | | | | | |
| TC-CUS-003 | Manager updates customer contact information | 1. Login as `manager`<br>2. Navigate to Customer list → select `Test Corp`<br>3. Click "Edit"<br>4. Update phone and email<br>5. Click "Save" | - Customer updated successfully<br>- Success message shown<br>- Updated info visible in detail view | Customer `Test Corp` exists | Pending | | | Pending | | | Pending | | | | |
| **Scenario C: Toggle Customer Status (UC-CUS-003)** | | | | | | | | | | | | | | | |
| TC-CUS-004 | Manager deactivates an active customer | 1. Login as `manager`<br>2. Navigate to Customer list<br>3. Find active customer `Test Corp`<br>4. Click "Toggle Status" (Deactivate) | - Customer status changes to Inactive<br>- Success message shown | `Test Corp` is Active | Pending | | | Pending | | | Pending | | | | |
| TC-CUS-005 | Inactive customer cannot be selected in new Sales Order | 1. Deactivate a customer (see TC-CUS-004)<br>2. Login as `sales`<br>3. Navigate to Create Sales Order<br>4. Open customer dropdown | - Inactive customer does NOT appear in the customer dropdown<br>- Only Active customers are selectable | Inactive customer exists | Pending | | | Pending | | | Pending | | | | |
| TC-CUS-006 | Manager re-activates an inactive customer | 1. Login as `manager`<br>2. Navigate to Customer list<br>3. Find Inactive customer<br>4. Click "Toggle Status" (Activate) | - Customer status changes to Active<br>- Customer again selectable in Sales Orders | Inactive customer exists | Pending | | | Pending | | | Pending | | | | |
| **Scenario D: View Customer List (UC-CUS-004)** | | | | | | | | | | | | | | | |
| TC-CUS-007 | Sales user views customer list | 1. Login as `sales`<br>2. Navigate to Customer Management | - All customers listed in table<br>- Table shows: Code, Name, Contact Info, Status<br>- Pagination and filtering work | Sales logged in; customers exist | Pending | | | Pending | | | Pending | | | | |
| **Scenario E: Access Control** | | | | | | | | | | | | | | | |
| TC-CUS-008 | Staff cannot access Customer Management | 1. Login as `staff`<br>2. Attempt to navigate to `/customer` | - Access denied<br>- Redirect to error page | Staff logged in | Pending | | | Pending | | | Pending | | | | |
