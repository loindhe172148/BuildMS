# Smart Warehouse Management System (Smart WMS)

A Java-based web application for managing warehouse operations using JSP, Servlets, and SQL Server. Features include authentication, role-based access control, inventory management, and sales-driven fulfillment workflows.

## 🔐 Authentication System

**NEW:** Smart WMS now includes comprehensive authentication and authorization!

- **Secure Login/Registration**: SHA-256 password hashing with salt
- **Role-Based Access Control**: Admin, Manager, Staff, and Sales roles
- **Session Management**: 30-minute timeout for security
- **Protected Resources**: Authorization filter checks permissions

### Quick Start

1. Run database migration: `database/auth_migration.sql`
2. Login at `/auth?action=login` with test credentials:
   - Username: `admin` / Password: `password123` (Admin)
   - Username: `manager` / Password: `password123` (Manager)
   - Username: `staff` / Password: `password123` (Staff)
   - Username: `sales` / Password: `password123` (Sales)

**⚠️ Change passwords immediately!**

📖 **Full Documentation**: See [AUTHENTICATION.md](document/AUTHENTICATION.md)

## Project Structure

```
buildms/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── vn/edu/fpt/swp/
│   │   │       ├── controller/
│   │   │       │   ├── AuthController.java
│   │   │       │   ├── UserController.java
│   │   │       │   └── ProductController.java
│   │   │       ├── dao/
│   │   │       │   ├── UserDAO.java
│   │   │       │   └── ProductDAO.java
│   │   │       ├── model/
│   │   │       │   ├── User.java
│   │   │       │   └── Product.java
│   │   │       ├── service/
│   │   │       │   ├── AuthService.java
│   │   │       │   └── ProductService.java
│   │   │       ├── filter/
│   │   │       │   └── AuthFilter.java
│   │   │       │   
│   │   │       └── util/
│   │   │           ├── DBConnection.java
│   │   │           └── PasswordUtil.java
│   │   │
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   ├── views/
│   │       │   │   ├── common/
│   │       │   │   │   ├── header.jsp
|   |       |   |   |   ├── navbar.jsp
│   │       │   │   │   └── footer.jsp
│   │       │   │   ├── auth/
│   │       │   │   │   ├── login.jsp
│   │       │   │   │   └── register.jsp
│   │       │   │   ├── product/
│   │       │   │   │   ├── list.jsp
│   │       │   │   │   ├── create.jsp
│   │       │   │   │   ├── edit.jsp
│   │       │   │   │   └── view.jsp
│   │       │   │   └── error/
│   │       │   │       ├── 403.jsp
│   │       │   │       ├── 404.jsp
│   │       │   │       └── 500.jsp
│   │       │   │
│   │       │   └── web.xml
│   │       │
│   │       ├── assets/
│   │       │   ├── css/
│   │       │   ├── js/
│   │       │   └── images/
│   │       │
│   │       └── index.jsp
│   │
│   └── test/
│
├── database/
│   ├── schema.sql
│   └── auth_migration.sql
│
├── document/
│   ├── SRS.md
│   └── AUTHENTICATION.md
│
└── pom.xml

```

## Architecture

This project follows the **MVC (Model-View-Controller)** pattern:

- **Model**: Entity classes representing database tables (Product.java)
- **View**: JSP pages for user interface
- **Controller**: Servlets handling HTTP requests (ProductController.java)

### Layers:

1. **Presentation Layer** (JSP Views)
   - User interface
   - Display data and forms

2. **Controller Layer** (Servlets)
   - Handle HTTP requests
   - Route requests to appropriate services
   - Prepare data for views

3. **Service Layer**
   - Business logic
   - Data validation
   - Transaction management

4. **Data Access Layer** (DAOs)
   - Database operations (CRUD)
   - SQL queries
   - Data mapping

5. **Model Layer** (Entities)
   - Data representation
   - Domain objects

## Technologies Used

- **Java 21**
- **Jakarta EE 10** (Servlets 6.0, JSP 3.1)
- **JSTL** (JSP Standard Tag Library)
- **SQL Server** (Database with JDBC driver)
- **Maven** (Build tool)
- **Apache Tomcat 10+** (Web server)
- **SHA-256** (Password hashing with salt)
- **Bootstrap 5** (Frontend UI framework)

## 🔐 Authentication & Authorization
- **Secure Login**: Username/password with SHA-256 hashing
- **Role-Based Access**: Admin, Manager, Staff, Sales roles
- **Session Management**: 30-minute inactivity timeout
- **Protected Routes**: Authorization filter for all resources
- **Password Management**: Change password and admin reset

### 📦 Product Management
- **List Products**: View all products with search functionality
- **Create Product**: Add new products to inventory
- **View Product**: Display detailed product information
### Authentication Endpoints
| Method | URL | Description |
|--------|-----|-------------|
| GET | `/auth?action=login` | Show login page |
| POST | `/auth` (action=login) | Process login |
| GET | `/auth?action=register` | Show registration page |
| POST | `/auth` (action=register) | Process registration |
| GET | `/auth?action=logout` | Logout user |

### User Management Endpoints (Admin Only)
| Method | URL | Description |
|--------|-----|-------------|
| GET | `/user` | List all users |
| GEUsers table
```sql
Id           BIGINT (PK, Auto Increment)
Username     NVARCHAR(100) UNIQUE NOT NULL
Name         NVARCHAR(255) NOT NULL
Email        NVARCHAR(255) UNIQUE NOT NULL
PasswordHash NVARCHAR(500) NOT NULL
Role         NVARCHAR(50) NOT NULL      -- Admin/Manager/Staff/Sales
Status       NVARCHAR(50) DEFAULT 'Active'
WarehouseId  BIGINT NULL
CreatedAt    DATETIME2
LastLogin    DATETIME2
```

###Setup Instructions

### 1. Database Setup
```bash
# Create database and run schema
sqlcmd -S localhost -i database/schema.sql

# Run authentication migration
sqlcmd -S localhost -d smartwms_db -i database/auth_migration.sql
```

### 2. Configure Database Connection
Edit `src/main/resources/db.properties`:
```properties
db.url=jdbc:sqlserver://localhost;databaseName=smartwms_db;encrypt=true;trustServerCertificate=true
db.username=your_username
db.password=your_password
db.driver=com.microsoft.sqlserver.jdbc.SQLServerDriver
```

**Benefits of Properties File:**
- No need to recompile when changing database credentials
- Easy to configure different environments (dev/staging/prod)
- Keeps sensitive data separate from source code

### 3. Build Project
```bash
mvn clean package
```

### 4. Deploy to Tomcat
Copy `target/buildms.war` to Tomcat's `webapps/` directory.

### 5. Access Application
- URL: `http://localhost:8080/buildms/`
- Login: Use test credentials from auth_migration.sql

## Documentation

- **[SRS.md](document/SRS.md)** - Software Requirements Specification
- **[AUTHENTICATION.md](document/AUTHENTICATION.md)** - Authentication system details
- **[schema.sql](database/schema.sql)** - Database schema
- **[auth_migration.sql](database/auth_migration.sql)** - Authentication migration

## Future Enhancements

- ✅ ~~User authentication and authorization~~ (Completed)
- Order management
- Warehouse operations (Inbound/Outbound/Transfer)
- Sales order management
- Inventory tracking
- Image upload support
- Advanced reporting
- RESTful API
- Pagination for product lists
- Export/Import functionality
- Email notifications
- Two-factor authentication
- API token authentication
```

See [schema.sql](database/schema.sql) for complete database structure.
### 👥 User Management (Admin Only)
- **User CRUD**: Create, read, update, delete users
- **Role Assignment**: Assign roles to users
- **Password Reset**: Admin can reset user passwords
- **User Status**: Activate/deactivate user accounts
- **Delete Product**: Soft delete products (marks as inactive)
- **Search Products**: Find products by name, category, or description

## API Endpoints

| Method | URL | Description |
|--------|-----|-------------|
| GET | `/product` | List all products |
| GET | `/product?action=view&id={id}` | View product details |
| GET | `/product?action=create` | Show create form |
| POST | `/product?action=create` | Create new product |
| GET | `/product?action=edit&id={id}` | Show edit form |
| POST | `/product?action=update` | Update product |
| GET | `/product?action=delete&id={id}` | Delete product |
| GET | `/product?action=search&keyword={keyword}` | Search products |

## Database Schema

### products table
```sql
id           BIGINT (PK, Auto Increment)
name         VARCHAR(255) NOT NULL
description  TEXT
price        DECIMAL(10, 2) NOT NULL
quantity     INT NOT NULL
category     VARCHAR(100)
image_url    VARCHAR(500)
created_at   TIMESTAMP
updated_at   TIMESTAMP
active       BOOLEAN
```

## Future Enhancements

- User authentication and authorization
- Order management
- Image upload support
- Advanced reporting
- RESTful API
- Pagination for product lists
- Export/Import functionality

## License

This project is for educational purposes.
