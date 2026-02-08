# UC-AUTH-001: User Login

## Use Case Overview
| Attribute | Description |
|-----------|-------------|
| **Use Case ID** | UC-AUTH-001 |
| **Use Case Name** | User Login |
| **Primary Actor** | All Users (Admin, Manager, Staff, Sales) |
| **Description** | Authenticate a user using username or email and password to access the system |
| **Preconditions** | User account exists and is Active |
| **Postconditions** | User session is created; user is redirected to dashboard |

---

## Main Flow

### Step 1: Display Login Form
- System displays login form with fields:
  - Username or email (text input, required)
  - Password (password input, required)
  - Submit button

### Step 2: User Submits Credentials
- User enters username or email and password
- User clicks submit button

### Step 3: Validate Input Fields
- **Validation Rules:**
  - Username or email must not be empty
  - Password must not be empty
- If validation fails → **Alternative Flow A1**

### Step 4: Authenticate User
- System retrieves user record by username or email
- If user not found → **Alternative Flow A2**
- If user status is Inactive → **Alternative Flow A3**

### Step 5: Verify Password
- System retrieves stored password hash and salt for user
- System computes hash of entered password using SHA-256 with stored salt
- System compares computed hash with stored hash
- If hashes do not match → **Alternative Flow A4**

### Step 6: Create User Session
- System creates new session for authenticated user
- System stores in session:
  - User ID
  - Username
  - User Role
  - Session creation timestamp
- System sets session timeout to 30 minutes

### Step 7: Update Last Login
- System updates `lastLogin` timestamp for user record

### Step 8: Redirect to Dashboard
- System redirects user to role-appropriate dashboard
- Display success message: "Login successful"

---

## Alternative Flows

### A1: Input Validation Failed
- **Trigger:** Username or password field is empty
- **Steps:**
  1. System displays error message: "Username or email and password are required"
  2. System highlights empty fields
  3. Return to Step 1 (form retains entered username/email)

### A2: User Not Found
- **Trigger:** No user exists with provided username or email
- **Steps:**
  1. System displays error message: "Invalid username or password"
  2. Return to Step 1

### A3: User Account Inactive
- **Trigger:** User status is Inactive
- **Steps:**
  1. System displays error message: "Your account has been deactivated. Please contact administrator"
  2. Return to Step 1

### A4: Password Incorrect
- **Trigger:** Password hash does not match stored hash
- **Steps:**
  1. System displays error message: "Invalid username or password"
  2. Return to Step 1

---

## Business Rules
| Rule ID | Description |
|---------|-------------|
| BR-AUTH-001 | All users must authenticate before accessing any system feature |
| BR-AUTH-002 | Passwords are verified using SHA-256 hash with salt comparison |
| BR-AUTH-003 | Error messages must not reveal whether username or password was incorrect |
| BR-AUTH-004 | Session timeout is 30 minutes of inactivity |

---

## UI Requirements
- Login form centered on page
- Clear error message display area
- Password field must mask input
- "Forgot Password" link available
- "Register" link for new users
