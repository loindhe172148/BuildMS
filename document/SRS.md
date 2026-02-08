# Software Requirements Specification (SRS)

## Smart Warehouse Management System (Smart WMS)

---

## 1. Introduction

### 1.1 Purpose

This document specifies the functional and non-functional requirements of the **Smart Warehouse Management System (Smart WMS)**. It is intended for academic use to demonstrate warehouse operations integrated with a non-financial sales flow.

### 1.2 Scope

Smart WMS is a system that simulates real-world warehouse operations including inbound, outbound, internal transfer, and sales-driven outbound processes. The system emphasizes role-based control, approval workflows, and inventory traceability.

The system **does not handle financial operations** such as pricing, payment, or accounting.

### 1.3 Definitions, Acronyms, and Abbreviations

* **WMS**: Warehouse Management System
* **Inbound**: Goods receipt into warehouse
* **Outbound**: Goods issue from warehouse
* **Transfer**: Movement between warehouses
* **Internal Movement**: Movement within a warehouse
* **SalesOrder (SO)**: Non-financial sales order triggering outbound flow
* **Request**: A warehouse operation request that affects inventory

---

## 2. Overall Description

### 2.1 Product Perspective

Smart WMS is a standalone academic system. Sales and warehouse operations are logically separated but connected through SalesOrder-driven outbound requests.

### 2.2 User Classes and Characteristics

| User Class           | Description                                            |
| -------------------- | ------------------------------------------------------ |
| Admin                | System configuration and master data management        |
| Manager              | Inventory control, request approval, sales fulfillment |
| Staff                | Physical warehouse operations                          |
| Sales (logical role) | Create and manage SalesOrders (no warehouse access)    |

**Authentication & Authorization:**
* All users must authenticate using username and password
* Passwords are hashed using SHA-256 with salt for security
* Role-based access control (RBAC) enforces permissions
* Session management with 30-minute timeout
* Users can be Active or Inactive status

### 2.3 Operating Environment

* Web-based application
* Relational Database Management System
* No hardware integration (barcode scanners are simulated)

### 2.4 Design and Implementation Constraints

* Academic scope only
* No financial processing
* No optimization for large-scale data

---

## 3. System Features

### 3.0 Authentication & Authorization

**Description:** Secure user authentication and role-based authorization system.

**Primary Actor:** All Users

**Functional Requirements:**

* System shall authenticate users using username and password.
* System shall hash passwords using SHA-256 with random salt.
* System shall create and manage user sessions upon successful login.
* System shall invalidate sessions after 30 minutes of inactivity.
* System shall enforce role-based access control for all resources.
* System shall prevent unauthorized access to restricted features.
* Users shall be able to register new accounts with email verification.
* Users shall be able to change their passwords.
* Admin shall be able to reset user passwords.
* System shall track last login timestamp for each user.

**Access Control Matrix:**

| Resource          | Admin | Manager | Staff | Sales |
| ----------------- | ----- | ------- | ----- | ----- |
| User Management   | ✓     | ✗       | ✗     | ✗     |
| Warehouse Config  | ✓     | ✓       | ✗     | ✗     |
| Product CRUD      | ✓     | ✓       | View  | View  |
| Inventory View    | ✓     | ✓       | ✓     | ✗     |
| Request Approval  | ✓     | ✓       | ✗     | ✗     |
| Request Execution | ✓     | ✓       | ✓     | ✗     |
| Sales Orders      | ✓     | ✓       | ✗     | ✓     |
| Reports           | ✓     | ✓       | View  | View  |

---

### 3.1 Inbound Management

**Description:** Manage goods receipt into warehouses.

**Primary Actor:** Manager, Staff

**Functional Requirements:**

* Manager shall create inbound requests.
* Manager shall approve inbound requests.
* Staff shall execute inbound operations.
* System shall increase inventory upon completion.

---

### 3.2 Sales Order Management

**Description:** Manage customer orders as a trigger for outbound operations.

**Primary Actor:** Sales, Manager

**Functional Requirements:**

* Sales shall create SalesOrders.
* System shall not modify inventory directly from SalesOrders.
* Manager shall generate outbound requests from SalesOrders.
* SalesOrder shall track fulfillment status.

---

### 3.3 Outbound Management (Sales-driven)

**Description:** Ship goods based on SalesOrders.

**Primary Actor:** Manager, Staff

**Functional Requirements:**

* Outbound requests shall reference a SalesOrder.
* Manager shall approve outbound requests.
* Staff shall pick and ship goods.
* System shall reduce inventory after completion.

---

### 3.4 Internal Outbound Management

**Description:** Handle outbound requests not related to sales.

**Primary Actor:** Manager, Staff

**Functional Requirements:**

* Manager shall create non-sales outbound requests.
* Approval and execution follow standard outbound flow.

---

### 3.5 Inter-Warehouse Transfer

**Description:** Transfer goods between warehouses.

**Primary Actor:** Manager, Staff

**Functional Requirements:**

* System shall generate outbound request for source warehouse.
* System shall generate inbound request for destination warehouse.
* Inventory consistency shall be maintained.

---

### 3.6 Internal Movement

**Description:** Move goods between locations within a warehouse.

**Primary Actor:** Staff

**Functional Requirements:**

* Staff shall create internal movement requests.
* System shall update location data and history.

---

### 3.7 Warehouse Management

**Description:** Manage warehouse facilities and configuration.

**Primary Actor:** Admin

**Functional Requirements:**

* Admin shall create new warehouses with name and location.
* Admin shall update warehouse information.
* Admin shall view list of all warehouses.
* System shall display warehouse inventory summary.

---

### 3.8 Location Management

**Description:** Manage storage locations (bins) within warehouses.

**Primary Actor:** Admin, Manager

**Functional Requirements:**

* Admin/Manager shall create locations within a warehouse.
* Admin/Manager shall update location details (code, type).
* Admin/Manager shall activate or deactivate locations.
* Location types include: Storage, Picking, Staging.
* System shall prevent deactivation of locations with inventory.

---

### 3.9 Category Management

**Description:** Manage product categories for classification.

**Primary Actor:** Admin, Manager

**Functional Requirements:**

* Admin/Manager shall create product categories.
* Admin/Manager shall update category details.
* Admin/Manager shall delete unused categories.
* System shall prevent deletion of categories with associated products.

---

### 3.10 Product Management

**Description:** Manage product master data.

**Primary Actor:** Admin, Manager

**Functional Requirements:**

* Admin/Manager shall create products with SKU, name, unit, and category.
* Admin/Manager shall update product information.
* Admin/Manager shall activate or deactivate products.
* Staff and Sales shall view product information (read-only).
* SKU must be unique across the system.

---

### 3.11 Customer Management

**Description:** Manage customer master data for sales orders.

**Primary Actor:** Sales, Manager, Admin

**Functional Requirements:**

* Sales/Manager/Admin shall create customers with code, name, and contact info.
* Sales/Manager/Admin shall update customer information.
* Admin shall activate or deactivate customers.
* Customer code must be unique across the system.

---

### 3.12 User Management

**Description:** Manage system users and their access.

**Primary Actor:** Admin

**Functional Requirements:**

* Admin shall create new users with role assignment.
* Admin shall update user information.
* Admin shall activate or deactivate user accounts.
* Admin shall assign users to warehouses.
* Admin shall view list of all users.

---

### 3.13 Inventory Viewing

**Description:** View and search inventory across warehouses and locations.

**Primary Actor:** Admin, Manager, Staff

**Functional Requirements:**

* Users shall view inventory by warehouse.
* Users shall view inventory by product.
* Users shall view inventory by location.
* Users shall search inventory by product SKU or name.
* System shall display real-time quantity information.

---

## 4. Business Rules

* **Authentication is mandatory** - All users must login to access the system.
* **Passwords must be secure** - Minimum 6 characters, hashed with SHA-256 and salt.
* **Role-based permissions** - Users can only access features allowed for their role.
* **Session timeout** - Inactive sessions expire after 30 minutes.
* All inventory changes must be executed through Requests.
* Requests follow a predefined lifecycle.
* Staff cannot manually adjust inventory quantities.
* SalesOrders cannot directly affect inventory.
* All sales outbound operations must reference valid SalesOrders.
* Audit logs must record creator, approver, and executor.

---

## 5. State Models

### 5.1 Request Lifecycle

* Created
* Approved
* In Progress
* Completed
* Rejected

### 5.2 SalesOrder Lifecycle

* Draft
* Confirmed
* Fulfillment Requested
* Partially Shipped
* Completed
* Cancelled

---

## 6. Data Requirements

### 6.1 Master Data

* User (with authentication fields: username, email, passwordHash, lastLogin)
* Warehouse
* Product
* Category
* Location

### 6.2 Transactional Data

* Inventory
* Request
* RequestItem
* SalesOrder
* SalesOrderItem
* Customer

---

## 7. Non-Functional Requirements

* **Security:** Password hashing using SHA-256 with salt
* **Security:** Protection against SQL injection using prepared statements
* **Security:** Session-based authentication with timeout
* **Security:** Role-based access control for all resources
* Role-based access control
* Full audit trail for all inventory operations
* Data consistency across warehouses
* Clear separation between Sales and Warehouse domains
* **Performance:** Session timeout of 30 minutes for idle users
* **Usability:** Clear login and registration interface

---

## 8. Assumptions and Dependencies

* Sales operations are non-financial.
* Users act according to assigned roles.
* Inventory availability is checked manually by Manager.

---

## 9. Conclusion

Smart WMS demonstrates an enterprise-style separation of concerns between sales and warehouse operations. The system provides a realistic academic model for understanding inventory control, approval workflows, and sales-driven fulfillment without financial complexity.
