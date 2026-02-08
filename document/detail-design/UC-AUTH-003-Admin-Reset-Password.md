# UC-AUTH-003: Admin Reset Password

## Use Case Overview
| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-AUTH-003 |
| **Use Case Name** | Admin Reset Password |
| **Primary Actor** | Admin |
| **Description** | Admin resets a user's password when user cannot access their account |
| **Preconditions** | Admin is logged in; Target user account exists |
| **Postconditions** | Target user's password is reset; User can login with new password |

---

## Main Flow

### Step 1: Navigate to User Management
- Admin navigates to User Management section
- System displays list of users

### Step 2: Select User to Reset
- Admin searches or browses for target user
- Admin selects "Reset Password" action for the user

### Step 3: Display Reset Password Form
- System displays reset password form with:
  - User information (username, email) - read only
  - New Password (password input, required)
  - Confirm New Password (password input, required)
  - OR: "Generate Random Password" checkbox
  - Submit button

### Step 4: Admin Submits New Password
- Admin enters new password OR selects generate random
- If generate random selected:
  - System generates secure random password (minimum 8 characters)
  - System displays generated password to Admin
- Admin clicks submit button

### Step 5: Validate Input
- **Validation Rules:**
  - New Password: required, minimum 6 characters
  - Confirm Password: must match New Password
- If validation fails → **Alternative Flow A1**

### Step 6: Generate New Password Hash
- System generates new random salt (16 bytes)
- System computes SHA-256 hash of (new password + new salt)

### Step 7: Update User Password
- System updates target user record with:
  - New password hash
  - New salt
  - Password reset timestamp
  - Password reset by (Admin user ID)

### Step 8: Invalidate User Sessions
- System invalidates all active sessions for target user
- This forces user to login with new password

### Step 9: Notify User (Optional)
- System sends email to user with:
  - Notification that password was reset
  - New temporary password (if generated)
  - Instructions to change password after login

### Step 10: Display Confirmation
- System displays success message: "Password has been reset for user [username]"
- Admin remains on User Management page

---

## Alternative Flows

### A1: Input Validation Failed
- **Trigger:** Password validation rules not met
- **Steps:**
  1. System displays error messages:
     - "New password must be at least 6 characters"
     - "Passwords do not match"
  2. Return to Step 3

---

## Business Rules
| Rule ID | Description |
|---------|-------------|
| BR-RST-001 | Only Admin role can reset other users' passwords |
| BR-RST-002 | Reset password must meet minimum 6 character requirement |
| BR-RST-003 | All active sessions for user must be invalidated after reset |

---

## Access Control
| Role | Permission |
|------|------------|
| Admin | ✓ Can reset any user's password |
| Manager | ✗ Cannot reset passwords |
| Staff | ✗ Cannot reset passwords |
| Sales | ✗ Cannot reset passwords |

---

## UI Requirements
- Reset password accessible from User Management list
- Display target user info clearly before reset
- Option to generate random secure password
- Copy to clipboard for generated passwords
- Confirmation dialog before executing reset
