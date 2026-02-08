# Smart Warehouse Management System (Smart WMS)

A comprehensive Java-based web application for managing warehouse operations including authentication, role-based access control, inventory management, product management, customer management, sales order processing, inbound/outbound/transfer workflows, and detailed warehouse logistics.

**Status**: Fully detailed with 47+ use cases documented in [Detail Design Documents](document/detail-design/README.md)

## 📚 Documentation

This project is thoroughly documented with comprehensive design specifications:

- **[Detail Design Documents](document/detail-design/README.md)** - 47+ use cases organized by functional area with detailed flows, business rules, access control, and UI requirements
- **[SRS (Software Requirements Specification)](document/SRS.md)** - Complete business requirements and functional specifications
- **[Authentication System](document/AUTHENTICATION.md)** - Authentication and authorization details
- **[Quick Reference](document/AUTH_QUICK_REF.md)** - Quick authentication reference

## 🔐 Authentication & Authorization

Smart WMS includes comprehensive authentication and authorization:

- **Secure Login**: SHA-256 password hashing with salt
- **Role-Based Access Control**: Admin, Manager, Staff, and Sales roles
- **Session Management**: 30-minute timeout for security
- **Protected Resources**: Authorization filter for all endpoints

### Quick Start

1. Run database migration: `database/auth_migration.sql`
2. Login at `/auth?action=login` with test credentials:
   - Username: `admin` / Password: `password123` (Admin)
   - Username: `manager` / Password: `password123` (Manager)
   - Username: `staff` / Password: `password123` (Staff)
   - Username: `sales` / Password: `password123` (Sales)

**⚠️ Change passwords immediately!**

### Role Responsibilities

| Role | Primary Responsibilities |
|------|--------------------------|
| **Admin** | System configuration, user management, full access |
| **Manager** | Request creation, approval, inventory oversight |
| **Staff** | Request execution, physical operations |
| **Sales** | Sales order management (no warehouse access) |

## 📋 Core Features

### Authentication & User Management
- User login/logout with session management
- Password change and admin password reset
- Session timeout (30 minutes)
- Role-based access control

### Warehouse Management
- Create and update warehouses
- View warehouse inventory and details
- Location management within warehouses

### Product & Category Management
- Create, update, and manage products
- Product categorization with CRUD operations
- Product search and detailed product views
- Inventory tracking by product

### Customer Management
- Create and update customer profiles
- Manage customer status (active/inactive)
- View customer lists with filtering

### Sales Order Processing
- Create sales orders with line items
- Confirm sales orders
- Generate outbound requests from sales orders
- Cancel sales orders

### Warehouse Operations
- **Inbound Management**: Create, approve, and execute inbound requests
- **Outbound Management**: Approve and execute outbound requests
- **Internal Movements**: Create and execute internal movements
- **Inventory Transfers**: Create transfer requests and execute bi-directional transfers

### Inventory Management
- View inventory by warehouse
- View inventory by product
- Search inventory across facilities
- Track inventory locations and quantities

## Use Case Coverage

Smart WMS includes detailed design for 47+ use cases:

- **Authentication & Authorization**: 5 use cases
- **User Management**: 5 use cases
- **Warehouse Management**: 3 use cases
- **Location Management**: 4 use cases
- **Product Management**: 5 use cases
- **Category Management**: 4 use cases
- **Customer Management**: 4 use cases
- **Sales Order Processing**: 4 use cases
- **Inbound Management**: 3 use cases
- **Outbound Management**: 3 use cases
- **Inter-Warehouse Transfer**: 3 use cases
- **Internal Movement**: 2 use cases
- **Inventory Management**: 3 use cases

See [Detail Design Documents](document/detail-design/README.md) for complete specifications.

## Architecture

This project follows the **MVC (Model-View-Controller)** pattern:

- **Model**: Entity classes representing database tables
- **View**: JSP pages for user interface
- **Controller**: Servlets handling HTTP requests

### Architectural Layers

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

## Project Structure

```
buildms/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── vn/edu/fpt/swp/
│   │   │       ├── controller/      # HTTP request handlers
│   │   │       ├── service/         # Business logic
│   │   │       ├── dao/             # Data access objects
│   │   │       ├── model/           # Entity models
│   │   │       ├── filter/          # Request filters (auth, etc)
│   │   │       └── util/            # Utilities (DB, security, etc)
│   │   │
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   ├── views/           # JSP templates
│   │       │   │   ├── auth/
│   │       │   │   ├── product/
│   │       │   │   ├── customer/
│   │       │   │   ├── warehouse/
│   │       │   │   ├── inventory/
│   │       │   │   ├── order/
│   │       │   │   └── common/
│   │       │   └── web.xml
│   │       └── assets/              # CSS, JS, images
│   │
│   └── test/                        # Unit and integration tests
│
├── database/
│   ├── schema.sql                   # Complete database schema
│   └── auth_migration.sql           # Authentication setup
│
├── document/
│   ├── detail-design/               # 47+ detailed use case documents
│   ├── SRS.md                       # Software Requirements
│   ├── AUTHENTICATION.md            # Auth system details
│   └── AUTH_QUICK_REF.md           # Quick reference
│
└── pom.xml                          # Maven configuration
```

## Technologies Used

- **Java 21**
- **Jakarta EE 10** (Servlets 6.0, JSP 3.1)
- **JSTL** (JSP Standard Tag Library)
- **SQL Server** (Database with JDBC driver)
- **Maven** (Build tool)
- **Apache Tomcat 10+** (Web server)
- **SHA-256** (Password hashing with salt)
- **Bootstrap 5** (Frontend UI framework)

## Setup Instructions

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
- Login: Use test credentials from the Quick Start section

## API Endpoints

### Authentication Endpoints
| Method | URL | Description |
|--------|-----|-------------|
| GET | `/auth?action=login` | Show login page |
| POST | `/auth` (action=login) | Process login |
| GET | `/auth?action=logout` | Logout user |

### User Management Endpoints (Admin Only)
| Method | URL | Description |
|--------|-----|-------------|
| GET | `/user` | List all users |
| POST | `/user` | Create new user |
| GET | `/user?action=edit&id={id}` | Show edit form |
| POST | `/user?action=update` | Update user |

### Product Management Endpoints
| Method | URL | Description |
|--------|-----|-------------|
| GET | `/product` | List all products |
| GET | `/product?action=view&id={id}` | View product details |
| GET | `/product?action=create` | Show create form |
| POST | `/product?action=create` | Create new product |
| GET | `/product?action=edit&id={id}` | Show edit form |
| POST | `/product?action=update` | Update product |
| POST | `/product?action=delete&id={id}` | Delete product |
| GET | `/product?action=search&keyword={keyword}` | Search products |

## Database Schema

See [schema.sql](database/schema.sql) for the complete database structure. The schema includes tables for:
- Users and authentication
- Warehouses and locations
- Products and categories
- Customers
- Sales orders and items
- Inbound/outbound requests
- Inventory and transfers

## Future Enhancements

- ✅ ~~User authentication and authorization~~ (Completed)
- ✅ ~~40+ use case specifications~~ (Completed)
- RESTful API layer
- Advanced reporting and analytics
- Image upload support
- Email notifications
- Two-factor authentication
- API token authentication
- Performance optimization and caching
- Mobile application support

## License

This project is for educational purposes.
