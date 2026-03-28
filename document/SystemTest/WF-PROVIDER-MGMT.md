# WF-PROVIDER-MGMT – Provider Management

| | | | | | | | | | | | | | | | |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| **Workflow** | WF-PROVIDER-MGMT – Provider Management | | | | | | | | | | | | | | **Passed** |
| **Test requirement** | Tests covering Provider CRUD, status toggling (UC-PRO-001 to UC-PRO-004), and Inbound integration. Verifies role-based access to create and update providers, code uniqueness constraints, that inactive providers cannot be referenced in new Inbound requests, and that Provider selection remains optional when creating an Inbound request. | | | | | | | | | | | | | | **Failed** |
| **Number of TCs** | 10 | | | | | | | | | | | | | | **Pending** |
| **Testing Round** | Passed | Failed | Pending | | | | | | | | | | | | |
| Round 1 | 0 | 0 | 10 | 0 | | | | | | | | | | | |
| Round 2 | 0 | 0 | 10 | 0 | | | | | | | | | | | |
| Round 3 | 0 | 0 | 10 | 0 | | | | | | | | | | | |

| Test Case ID | Test Case Description | Test Case Procedure | Expected Results | Pre-conditions | Round 1 | Test date | Tester | Round 2 | Test date | Tester | Round 3 | Test date | Tester | Note | |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| **Scenario A: Create Provider (UC-PRO-001)** | | | | | | | | | | | | | | | |
| TC-PRO-001 | Manager creates a new provider successfully | 1. Login as `manager`<br>2. Navigate to Provider Management → Create<br>3. Enter Provider Code: `PROV-TEST-001`<br>4. Enter Name: `Global Supplies Inc`<br>5. Enter contact info (phone, email, address)<br>6. Click "Save" | - Provider `Global Supplies Inc` created with status Active<br>- Success message displayed<br>- Appears in provider list | Manager user logged in | Pending | | | Pending | | | Pending | | | | |
| TC-PRO-002 | Creating a provider with duplicate code is rejected | 1. Login as `manager`<br>2. Navigate to Create Provider<br>3. Enter Provider Code that already exists<br>4. Click "Save" | - Creation rejected<br>- Error message: "Provider code already exists"<br>- No duplicate provider created | Provider with same code exists | Pending | | | Pending | | | Pending | | | | |
| **Scenario B: Update Provider (UC-PRO-002)** | | | | | | | | | | | | | | | |
| TC-PRO-003 | Manager updates provider contact information | 1. Login as `manager`<br>2. Navigate to Provider list → select `Global Supplies Inc`<br>3. Click "Edit"<br>4. Update phone and email<br>5. Click "Save" | - Provider updated successfully<br>- Success message shown<br>- Updated info visible in list and detail view | Provider `Global Supplies Inc` exists | Pending | | | Pending | | | Pending | | | | |
| **Scenario C: Toggle Provider Status (UC-PRO-003)** | | | | | | | | | | | | | | | |
| TC-PRO-004 | Manager deactivates an active provider | 1. Login as `manager`<br>2. Navigate to Provider list<br>3. Find active provider `Global Supplies Inc`<br>4. Click "Toggle Status" (Deactivate) | - Provider status changes to Inactive<br>- Success message shown | `Global Supplies Inc` is Active | Pending | | | Pending | | | Pending | | | | |
| TC-PRO-005 | Inactive provider cannot be selected in new Inbound Request | 1. Deactivate a provider (see TC-PRO-004)<br>2. Navigate to Create Inbound Request<br>3. Open provider dropdown | - Inactive provider does NOT appear in the provider dropdown<br>- Only Active providers are selectable | Inactive provider exists | Pending | | | Pending | | | Pending | | | | |
| TC-PRO-006 | Manager re-activates an inactive provider | 1. Login as `manager`<br>2. Navigate to Provider list<br>3. Find Inactive provider<br>4. Click "Toggle Status" (Activate) | - Provider status changes to Active<br>- Provider again selectable in Inbound Requests | Inactive provider exists | Pending | | | Pending | | | Pending | | | | |
| **Scenario D: View Provider List (UC-PRO-004)** | | | | | | | | | | | | | | | |
| TC-PRO-007 | Manager views provider list | 1. Login as `manager`<br>2. Navigate to Provider Management | - All providers listed in table<br>- Table shows: Code, Name, Contact Info, Status<br>- Pagination and filtering work | Manager logged in; providers exist | Pending | | | Pending | | | Pending | | | | |
| **Scenario E: Inbound Request Integration** | | | | | | | | | | | | | | | |
| TC-PRO-008 | Manager creates Inbound Request with a Provider | 1. Login as `manager`<br>2. Navigate to Create Inbound Request<br>3. Select an active provider from dropdown<br>4. Add products and submit | - Inbound Request created successfully<br>- Selected provider is linked to the Inbound Request in detail view | Manager logged in; active provider exists | Pending | | | Pending | | | Pending | | | | |
| TC-PRO-009 | Manager creates Inbound Request without a Provider (Optional) | 1. Login as `manager`<br>2. Navigate to Create Inbound Request<br>3. Leave the provider dropdown empty/unselected<br>4. Add products and submit | - Inbound Request created successfully<br>- Provider field is empty/null in detail view<br>- System accepts the request without validation errors regarding provider | Manager logged in | Pending | | | Pending | | | Pending | | | | |
| **Scenario F: Access Control** | | | | | | | | | | | | | | | |
| TC-PRO-010 | Staff cannot access Provider Management | 1. Login as `staff`<br>2. Attempt to navigate to `/provider` | - Access denied<br>- Redirect to error page | Staff logged in | Pending | | | Pending | | | Pending | | | | |
