# Authentication System Documentation

## Overview

Smart WMS now includes a comprehensive authentication and authorization system with password hashing, role-based access control, and session management.

## Features

### 1. Secure Password Hashing
- Uses SHA-256 algorithm with random salt
- Each password has unique 16-byte salt
- Format: `salt:hash` (both Base64 encoded)
- Resistant to rainbow table attacks

### 2. Role-Based Access Control (RBAC)
Four user roles with distinct permissions:

| Role    | Permissions                                           |
| ------- | ----------------------------------------------------- |
| Admin   | Full system access, user management, all operations   |
| Manager | Approve requests, manage inventory, view reports      |
| Staff   | Execute warehouse operations, view inventory          |
| Sales   | Create/manage sales orders, view products             |

### 3. Session Management
- 30-minute session timeout for inactive users
- Secure session storage with HttpOnly cookies
- Automatic logout on session expiry
- Login state preserved across pages

## Database Schema Changes

### Updated Users Table
```sql
CREATE TABLE Users (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(100) NOT NULL UNIQUE,
    Name NVARCHAR(255) NOT NULL,
    Email NVARCHAR(255) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(500) NOT NULL,
    Role NVARCHAR(50) NOT NULL,
    Status NVARCHAR(50) NOT NULL DEFAULT 'Active',
    WarehouseId BIGINT NULL,
    CreatedAt DATETIME2 DEFAULT GETDATE(),
    LastLogin DATETIME2 NULL
);
```

### New Indexes
- `IDX_User_Username` - Fast username lookup
- `IDX_User_Email` - Fast email lookup
- `IDX_User_Role` - Role-based queries

## Setup Instructions

### 1. Database Migration

Run the migration script to add authentication fields:

```bash
# From SQL Server Management Studio or sqlcmd
sqlcmd -S localhost -d smartwms_db -i database/auth_migration.sql
```

Or execute [auth_migration.sql](../database/auth_migration.sql) manually in your SQL client.

### 2. Initial Users

The migration script creates four test users:

| Username | Password     | Role    | Email                 |
| -------- | ------------ | ------- | --------------------- |
| admin    | password123  | Admin   | admin@smartwms.com    |
| manager  | password123  | Manager | manager@smartwms.com  |
| staff    | password123  | Staff   | staff@smartwms.com    |
| sales    | password123  | Sales   | sales@smartwms.com    |

**⚠️ IMPORTANT:** Change these passwords immediately after first login!

### 3. Create New Users

#### Option A: Via Registration Page
1. Navigate to `/auth?action=register`
2. Fill in the registration form
3. Select appropriate role
4. Submit to create account

#### Option B: Programmatically
```java
AuthService authService = new AuthService();
User user = authService.register(
    "username",
    "password",
    "Full Name",
    "email@example.com",
    "Staff"
);
```

## Usage

### Login Process

1. Navigate to `/auth?action=login`
2. Enter username and password
3. System authenticates and creates session
4. Redirects to role-appropriate dashboard

### Protected Resources

All URLs except public resources require authentication:

**Public URLs (no login required):**
- `/auth` - Login/Register/Logout
- `/assets/*` - Static assets
- `/css/*`, `/js/*`, `/libs/*`, `/fonts/*`
- `/favicon.ico`

**Protected URLs:**
- Everything else requires login
- Authorization filter checks role permissions
- Unauthorized access → 403 error page

### Access Control Rules

**Admin only:**
- `/admin/*` - Admin dashboard and user management

**Manager + Admin:**
- `/manager/*` - Manager dashboard
- Request approval workflows

**Staff + Manager + Admin:**
- `/warehouse/*` - Warehouse operations
- `/product/*` - Product management
- `/inventory/*` - Inventory views
- `/request/*` - Request execution

**Sales + Manager + Admin:**
- `/sales/*` - Sales dashboard
- `/salesorder/*` - Sales order management
- `/customer/*` - Customer management

### Logout

Access `/auth?action=logout` to:
1. Invalidate current session
2. Clear user data
3. Redirect to login page

## API Reference

### AuthController

**Endpoints:**

| Method | URL                      | Action   | Description              |
| ------ | ------------------------ | -------- | ------------------------ |
| GET    | /auth?action=login       | login    | Show login page          |
| POST   | /auth                    | login    | Process login            |
| GET    | /auth?action=register    | register | Show registration page   |
| POST   | /auth?action=register    | register | Process registration     |
| GET    | /auth?action=logout      | logout   | Logout and clear session |

### AuthService Methods

```java
// Authenticate user
User authenticate(String username, String password)

// Register new user
User register(String username, String password, String name, String email, String role)

// Change password
boolean changePassword(Long userId, String oldPassword, String newPassword)

// Reset password (admin only)
boolean resetPassword(Long userId, String newPassword)

// Check if user has role
boolean hasRole(User user, String requiredRole)

// Check if user has any of the roles
boolean hasAnyRole(User user, String... requiredRoles)
```

### UserDAO Methods

```java
User findByUsername(String username)
User findByEmail(String email)
User findById(Long id)
List<User> findAll()
List<User> findByRole(String role)
boolean create(User user)
boolean update(User user)
boolean updatePassword(Long userId, String passwordHash)
boolean updateLastLogin(Long userId)
boolean delete(Long id)  // Soft delete
boolean usernameExists(String username)
boolean emailExists(String email)
```

### PasswordUtil Methods

```java
// Hash password with random salt
String hashPassword(String password)

// Verify password against stored hash
boolean verifyPassword(String password, String storedHash)
```

## Security Best Practices

### For Developers

1. **Never log passwords** - Don't print or log plain text passwords
2. **Use prepared statements** - Already implemented in DAO layer
3. **Validate input** - Check for null, empty, and malicious input
4. **Hash all passwords** - Use PasswordUtil.hashPassword()
5. **Check authorization** - Use AuthFilter or manual role checks
6. **Session security** - Don't store sensitive data in session

### For Administrators

1. **Change default passwords** - Update test user passwords
2. **Strong password policy** - Enforce minimum 8-10 characters
3. **Regular audits** - Review user access and permissions
4. **Disable inactive users** - Set status to 'Inactive'
5. **Backup database** - Regular encrypted backups

### For Users

1. **Use strong passwords** - Mix letters, numbers, symbols
2. **Don't share accounts** - Each user should have own account
3. **Logout when done** - Especially on shared computers
4. **Report suspicious activity** - Contact admin immediately

## Common Issues & Solutions

### Issue: Login fails with correct credentials
**Solution:** 
- Check if user status is 'Active'
- Verify password hash in database is not null
- Check database connection in DBConnection.java

### Issue: Redirected to login after successful login
**Solution:**
- Check session is being created properly
- Verify AuthFilter is not blocking authenticated users
- Check browser accepts cookies

### Issue: 403 Access Denied error
**Solution:**
- Check user role matches resource requirements
- Review ROLE_ACCESS_MAP in AuthFilter.java
- Verify session contains user object

### Issue: Password reset not working
**Solution:**
- Ensure PasswordUtil.hashPassword() generates valid hash
- Check UserDAO.updatePassword() executes successfully
- Verify user ID exists in database

## Testing

### Manual Testing Checklist

- [ ] Login with valid credentials succeeds
- [ ] Login with invalid credentials fails
- [ ] Registration creates new user
- [ ] Duplicate username/email rejected
- [ ] Password must be 6+ characters
- [ ] Session expires after 30 minutes
- [ ] Logout clears session properly
- [ ] Admin can access all resources
- [ ] Manager cannot access admin pages
- [ ] Staff cannot access manager pages
- [ ] Sales cannot access warehouse pages
- [ ] Unauthenticated users redirected to login
- [ ] Password change works correctly
- [ ] Last login timestamp updates

### Example Test Data

```sql
-- Test user with known password
INSERT INTO Users (Username, Name, Email, PasswordHash, Role, Status, CreatedAt)
VALUES (
    'testuser',
    'Test User',
    'test@example.com',
    'generated_hash_here',
    'Staff',
    'Active',
    GETDATE()
);
```

## Architecture

### Component Diagram

```
Browser
   ↓
AuthController (Servlet)
   ↓
AuthService (Business Logic)
   ↓
UserDAO (Database Access)
   ↓
DBConnection (SQL Server)

AuthFilter (Security)
   ↓ (intercepts all requests)
   ↓ (checks authentication & authorization)
   ↓
Protected Resources
```

### Request Flow

1. User submits login form → AuthController
2. AuthController extracts credentials
3. Calls AuthService.authenticate()
4. AuthService calls UserDAO.findByUsername()
5. PasswordUtil.verifyPassword() checks hash
6. Creates HttpSession with user data
7. Redirects to role-specific dashboard
8. All subsequent requests checked by AuthFilter

## Future Enhancements

- [ ] Email verification on registration
- [ ] Forgot password / password reset via email
- [ ] Two-factor authentication (2FA)
- [ ] Account lockout after failed login attempts
- [ ] Password expiration policy
- [ ] OAuth2 integration (Google, Microsoft)
- [ ] API token authentication for REST APIs
- [ ] Audit log for all authentication events
- [ ] Password strength meter on registration
- [ ] Remember me functionality with secure tokens

## Support

For issues or questions:
1. Check this documentation
2. Review SRS.md for requirements
3. Check code comments in implementation
4. Contact development team

---

**Last Updated:** January 25, 2026  
**Version:** 1.0
