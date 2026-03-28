# WF-USER-MGMT – User Management

| | | | | | | | | | | | | | | | |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| **Workflow** | WF-USER-MGMT – User Management | | | | | | | | | | | | | | **Passed** |
| **Test requirement** | Tests covering User CRUD and warehouse assignment (UC-USER-001 to UC-USER-005). Verifies that only Admin can create, update, toggle status, view, and assign warehouse to user accounts. Non-admin users must not access User Management features. | | | | | | | | | | | | | | **Failed** |
| **Number of TCs** | 10 | | | | | | | | | | | | | | **Pending** |
| **Testing Round** | Passed | Failed | Pending | | | | | | | | | | | | |
| Round 1 | 0 | 0 | 10 | 0 | | | | | | | | | | | |
| Round 2 | 0 | 0 | 10 | 0 | | | | | | | | | | | |
| Round 3 | 0 | 0 | 10 | 0 | | | | | | | | | | | |

| Test Case ID | Test Case Description | Test Case Procedure | Expected Results | Pre-conditions | Round 1 | Test date | Tester | Round 2 | Test date | Tester | Round 3 | Test date | Tester | Note | |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| **Scenario A: Create User (UC-USER-001)** | | | | | | | | | | | | | | | |
| TC-USER-001 | Admin creates a new Staff user | 1. Login as `admin`<br>2. Navigate to User Management → Create User<br>3. Enter Username: `newstaff`<br>4. Enter Email, Password<br>5. Select Role: `Staff`<br>6. Click "Save" | - User `newstaff` created with role Staff<br>- Success message displayed<br>- User appears in user list as Active | Admin logged in | Pending | | | Pending | | | Pending | | | | |
| TC-USER-002 | Creating a user with an existing username is rejected | 1. Login as `admin`<br>2. Navigate to Create User<br>3. Enter Username: `manager` (already exists)<br>4. Fill all other fields and click "Save" | - Creation rejected<br>- Error: "Username already exists"<br>- Duplicate user not created | Admin logged in; `manager` user exists | Pending | | | Pending | | | Pending | | | | |
| TC-USER-003 | Creating a user without required fields is rejected | 1. Login as `admin`<br>2. Navigate to Create User<br>3. Leave Username empty<br>4. Click "Save" | - Validation error: "Username is required"<br>- No user created | Admin logged in | Pending | | | Pending | | | Pending | | | | |
| **Scenario B: Update User (UC-USER-002)** | | | | | | | | | | | | | | | |
| TC-USER-004 | Admin updates a user's email and role | 1. Login as `admin`<br>2. Navigate to User list → select `newstaff`<br>3. Click "Edit"<br>4. Update email and change role to `Manager`<br>5. Click "Save" | - User details updated successfully<br>- Success message shown<br>- Role shows `Manager` in list | `newstaff` user exists | Pending | | | Pending | | | Pending | | | | |
| **Scenario C: Toggle User Status (UC-USER-003)** | | | | | | | | | | | | | | | |
| TC-USER-005 | Admin deactivates an active user | 1. Login as `admin`<br>2. Navigate to User list<br>3. Find active user `newstaff`<br>4. Click "Toggle Status" (Deactivate) | - User status changes to Inactive<br>- Success message shown<br>- User cannot login while Inactive | `newstaff` user is Active | Pending | | | Pending | | | Pending | | | | |
| TC-USER-006 | Admin re-activates a deactivated user | 1. Login as `admin`<br>2. Navigate to User list<br>3. Find Inactive user<br>4. Click "Toggle Status" (Activate) | - User status changes to Active<br>- User can login again | Inactive user exists | Pending | | | Pending | | | Pending | | | | |
| **Scenario D: View User List (UC-USER-004)** | | | | | | | | | | | | | | | |
| TC-USER-007 | Admin views all users in the system | 1. Login as `admin`<br>2. Navigate to User Management | - All system users listed<br>- Table shows: Username, Email, Role, Status, Assigned Warehouse<br>- Pagination works | Admin logged in; multiple users exist | Pending | | | Pending | | | Pending | | | | |
| **Scenario E: Assign User to Warehouse (UC-USER-005)** | | | | | | | | | | | | | | | |
| TC-USER-008 | Admin assigns a Manager user to a warehouse | 1. Login as `admin`<br>2. Navigate to User list → select a Manager user<br>3. Find "Assign Warehouse" option<br>4. Select a warehouse and confirm | - Warehouse assignment saved<br>- Manager's assigned warehouse displayed in user details<br>- Manager can now create inbound/outbound for that warehouse | Manager user exists; warehouse exists | Pending | | | Pending | | | Pending | | | | |
| **Scenario F: Access Control** | | | | | | | | | | | | | | | |
| TC-USER-009 | Manager cannot access User Management | 1. Login as `manager`<br>2. Attempt to navigate to `/user` | - Access denied<br>- Redirected to 403 or dashboard<br>- No user data visible | Manager logged in | Pending | | | Pending | | | Pending | | | | |
| TC-USER-010 | Staff cannot access User Management | 1. Login as `staff`<br>2. Attempt to navigate to `/user?action=create` | - Access denied<br>- Redirected to error page | Staff logged in | Pending | | | Pending | | | Pending | | | | |
