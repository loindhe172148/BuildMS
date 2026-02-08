# Authentication Quick Reference Card

## 🚀 Quick Start

### Login
```
URL: /auth?action=login
Credentials: admin/password123
```

### Test Users
| User    | Password    | Role    |
| ------- | ----------- | ------- |
| admin   | password123 | Admin   |
| manager | password123 | Manager |
| staff   | password123 | Staff   |
| sales   | password123 | Sales   |

## 📋 Common Code Patterns

### Check if User is Logged In (JSP)
```jsp
<c:if test="${not empty sessionScope.user}">
    Welcome, ${sessionScope.user.name}!
</c:if>
<c:if test="${empty sessionScope.user}">
    <a href="${pageContext.request.contextPath}/auth?action=login">Login</a>
</c:if>
```

### Check User Role (JSP)
```jsp
<c:if test="${sessionScope.userRole == 'Admin'}">
    <a href="${pageContext.request.contextPath}/user">User Management</a>
</c:if>
```

### Get Current User (Servlet)
```java
HttpSession session = request.getSession(false);
User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
if (currentUser == null) {
    response.sendRedirect(request.getContextPath() + "/auth?action=login");
    return;
}
```

### Check User Role (Servlet)
```java
User user = (User) session.getAttribute("user");
if (!"Admin".equals(user.getRole())) {
    response.sendRedirect(request.getContextPath() + "/error/403.jsp");
    return;
}
```

### Register New User (Service)
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

### Authenticate User (Service)
```java
AuthService authService = new AuthService();
User user = authService.authenticate("username", "password");
if (user != null) {
    HttpSession session = request.getSession(true);
    session.setAttribute("user", user);
    session.setAttribute("userRole", user.getRole());
}
```

### Hash Password
```java
String hash = PasswordUtil.hashPassword("plainPassword");
```

### Verify Password
```java
boolean valid = PasswordUtil.verifyPassword("plainPassword", storedHash);
```

## 🔐 Access Control

### Admin Only
```java
// In servlet doGet/doPost
User user = (User) request.getSession().getAttribute("user");
if (user == null || !"Admin".equals(user.getRole())) {
    response.sendRedirect(contextPath + "/error/403.jsp");
    return;
}
```

### Multiple Roles
```java
AuthService authService = new AuthService();
if (!authService.hasAnyRole(user, "Admin", "Manager")) {
    response.sendRedirect(contextPath + "/error/403.jsp");
    return;
}
```

## 🛠️ Utility Commands

### Generate Password Hash
```bash
cd target/classes
java vn.edu.fpt.swp.util.PasswordHashGenerator mypassword
```

### Run Migration
```bash
sqlcmd -S localhost -d smartwms_db -i database/auth_migration.sql
```

## 🌐 URLs

| Action | URL |
| ------ | --- |
| Login Page | `/auth?action=login` |
| Register Page | `/auth?action=register` |
| Logout | `/auth?action=logout` |
| User List (Admin) | `/user` |
| Create User (Admin) | `/user?action=create` |

## 🎯 Role Access

| Path | Admin | Manager | Staff | Sales |
| ---- | ----- | ------- | ----- | ----- |
| /admin/* | ✓ | ✗ | ✗ | ✗ |
| /manager/* | ✓ | ✓ | ✗ | ✗ |
| /product/* | ✓ | ✓ | ✓ | ✓ |
| /warehouse/* | ✓ | ✓ | ✓ | ✗ |
| /sales/* | ✓ | ✓ | ✗ | ✓ |

## 🔍 Debugging

### Check Session
```java
HttpSession session = request.getSession(false);
System.out.println("Session ID: " + (session != null ? session.getId() : "null"));
System.out.println("User: " + (session != null ? session.getAttribute("user") : "null"));
```

### Check Database Connection
```java
try (Connection conn = DBConnection.getConnection()) {
    System.out.println("Connected: " + !conn.isClosed());
} catch (SQLException e) {
    e.printStackTrace();
}
```

### Verify User Exists
```java
UserDAO dao = new UserDAO();
User user = dao.findByUsername("admin");
System.out.println("User: " + user);
```

## ⚠️ Common Issues

### Issue: Login fails
**Check:**
- User status is 'Active'
- Password hash is not null
- Database connection works

### Issue: Redirected to login after login
**Check:**
- Session is created properly
- AuthFilter allows authenticated users
- Browser accepts cookies

### Issue: 403 error
**Check:**
- User role matches requirements
- AuthFilter ROLE_ACCESS_MAP
- Session contains user object

## 📞 Support

- Full docs: [AUTHENTICATION.md](AUTHENTICATION.md)
- Requirements: [SRS.md](SRS.md)
- Setup: [README.md](../README.md)

---
**Last Updated**: January 25, 2026
