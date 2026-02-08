# UC-AUTH-002: Change Password

## Use Case Overview
| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-AUTH-002 |
| **Use Case Name** | Change Password |
| **Primary Actor** | Authenticated User (All Roles) |
| **Description** | Allow authenticated user to change their own password |
| **Preconditions** | User is logged in with valid session |
| **Postconditions** | User password is updated; session remains active |

---

## Main Flow

### Step 1: Navigate to Change Password
- User navigates to Account Settings or Profile page
- User selects "Change Password" option

### Step 2: Display Change Password Form
- System displays form with fields:
  - Current Password (password input, required)
  - New Password (password input, required)
  - Confirm New Password (password input, required)
  - Submit button

### Step 3: User Submits Password Change
- User enters current password
- User enters new password
- User confirms new password
- User clicks submit button

### Step 4: Validate Input Fields
- **Validation Rules:**
  - Current Password: required, not empty
  - New Password: required, minimum 6 characters
  - Confirm New Password: must match New Password
  - New Password must be different from Current Password
- If validation fails → **Alternative Flow A1**

### Step 5: Verify Current Password
- System retrieves stored hash and salt for current user
- System computes hash of entered current password
- System compares with stored hash
- If hashes do not match → **Alternative Flow A2**

### Step 6: Generate New Password Hash
- System generates new random salt (16 bytes)
- System computes SHA-256 hash of (new password + new salt)

### Step 7: Update Password in Database
- System updates user record with:
  - New password hash
  - New salt
  - Password updated timestamp (if tracked)

### Step 8: Display Confirmation
- System displays success message: "Password changed successfully"
- User remains on current page or redirected to profile

---

## Alternative Flows

### A1: Input Validation Failed
- **Trigger:** Validation rules not met
- **Steps:**
  1. System displays specific error messages:
     - "Current password is required"
     - "New password must be at least 6 characters"
     - "New passwords do not match"
     - "New password must be different from current password"
  2. System highlights invalid fields
  3. Return to Step 2

### A2: Current Password Incorrect
- **Trigger:** Entered current password does not match stored password
- **Steps:**
  1. System displays error message: "Current password is incorrect"
  2. System clears current password field
  3. Return to Step 2

---

## Business Rules
| Rule ID | Description |
|---------|-------------|
| BR-PWD-001 | User must verify identity by entering current password |
| BR-PWD-002 | New password must be minimum 6 characters |
| BR-PWD-003 | New password must be hashed with SHA-256 and new random salt |
| BR-PWD-004 | New password cannot be the same as current password |

---

## UI Requirements
- Form accessible from user profile/settings
- All password fields must mask input
- Clear error and success message display
- Cancel button to return without changes
