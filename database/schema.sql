-- =====================================================
-- Smart WMS - SQL Server Initialization Script
-- =====================================================

/* =====================================================
   1. Create Database
   ===================================================== */
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'smartwms_db')
BEGIN
    CREATE DATABASE smartwms_db;
END
GO

USE smartwms_db;
GO

/* =====================================================
   2. Master / Catalog Tables
   ===================================================== */

-- User table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Users')
BEGIN
    CREATE TABLE Users (
        Id BIGINT IDENTITY(1,1) PRIMARY KEY,
        Username NVARCHAR(100) NOT NULL UNIQUE,
        Name NVARCHAR(255) NOT NULL,
        Email NVARCHAR(255) NOT NULL UNIQUE,
        PasswordHash NVARCHAR(500) NOT NULL,
        Role NVARCHAR(50) NOT NULL, -- Admin / Manager / Staff / Sales
        Status NVARCHAR(50) NOT NULL DEFAULT 'Active',
        WarehouseId BIGINT NULL,
        CreatedAt DATETIME2 DEFAULT GETDATE(),
        LastLogin DATETIME2 NULL
    );
    
    CREATE INDEX IDX_User_Username ON Users(Username);
    CREATE INDEX IDX_User_Email ON Users(Email);
    CREATE INDEX IDX_User_Role ON Users(Role);
END
GO

-- Warehouse table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Warehouses')
BEGIN
    CREATE TABLE Warehouses (
        Id BIGINT IDENTITY(1,1) PRIMARY KEY,
        Name NVARCHAR(255) NOT NULL,
        Location NVARCHAR(255),
        CreatedAt DATETIME2 DEFAULT GETDATE()
    );
END
GO

-- Category table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Categories')
BEGIN
    CREATE TABLE Categories (
        Id BIGINT IDENTITY(1,1) PRIMARY KEY,
        Name NVARCHAR(255) NOT NULL,
        Description NVARCHAR(500)
    );
END
GO

-- Product table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Products')
BEGIN
    CREATE TABLE Products (
        Id BIGINT IDENTITY(1,1) PRIMARY KEY,
        SKU NVARCHAR(100) NOT NULL UNIQUE,
        Name NVARCHAR(255) NOT NULL,
        Unit NVARCHAR(50),
        CategoryId BIGINT NOT NULL,
        IsActive BIT DEFAULT 1,
        CreatedAt DATETIME2 DEFAULT GETDATE(),
        CONSTRAINT FK_Product_Category FOREIGN KEY (CategoryId) REFERENCES Categories(Id)
    );

    CREATE INDEX IDX_Product_Name ON Products(Name);
    CREATE INDEX IDX_Product_SKU ON Products(SKU);
END
GO

-- Location (Bin)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Locations')
BEGIN
    CREATE TABLE Locations (
        Id BIGINT IDENTITY(1,1) PRIMARY KEY,
        WarehouseId BIGINT NOT NULL,
        Code NVARCHAR(100) NOT NULL,
        Type NVARCHAR(50) NOT NULL, -- Storage / Picking / Staging
        IsActive BIT DEFAULT 1,
        CONSTRAINT FK_Location_Warehouse FOREIGN KEY (WarehouseId) REFERENCES Warehouses(Id)
    );
END
GO

/* =====================================================
   3. Inventory & Request
   ===================================================== */

-- Inventory
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Inventory')
BEGIN
    CREATE TABLE Inventory (
        ProductId BIGINT NOT NULL,
        WarehouseId BIGINT NOT NULL,
        LocationId BIGINT NOT NULL,
        Quantity INT NOT NULL DEFAULT 0,
        PRIMARY KEY (ProductId, WarehouseId, LocationId),
        CONSTRAINT FK_Inventory_Product FOREIGN KEY (ProductId) REFERENCES Products(Id),
        CONSTRAINT FK_Inventory_Warehouse FOREIGN KEY (WarehouseId) REFERENCES Warehouses(Id),
        CONSTRAINT FK_Inventory_Location FOREIGN KEY (LocationId) REFERENCES Locations(Id)
    );
END
GO

-- Request
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Requests')
BEGIN
    CREATE TABLE Requests (
        Id BIGINT IDENTITY(1,1) PRIMARY KEY,
        Type NVARCHAR(50) NOT NULL, -- Inbound / Outbound / Transfer / Internal
        Status NVARCHAR(50) NOT NULL, -- Created / Approved / InProgress / Completed / Rejected
        CreatedBy BIGINT NOT NULL,
        ApprovedBy BIGINT NULL,
        ApprovedDate DATETIME2 NULL,
        RejectedBy BIGINT NULL,
        RejectedDate DATETIME2 NULL,
        RejectionReason NVARCHAR(500) NULL,
        CompletedBy BIGINT NULL,
        CompletedDate DATETIME2 NULL,
        SalesOrderId BIGINT NULL,
        SourceWarehouseId BIGINT NULL, -- For Transfer requests
        DestinationWarehouseId BIGINT NULL, -- For Transfer requests
        ExpectedDate DATETIME2 NULL,
        Notes NVARCHAR(500) NULL,
        Reason NVARCHAR(100) NULL, -- For Internal Outbound
        CreatedAt DATETIME2 DEFAULT GETDATE(),
        CONSTRAINT FK_Request_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES Users(Id),
        CONSTRAINT FK_Request_SourceWarehouse FOREIGN KEY (SourceWarehouseId) REFERENCES Warehouses(Id),
        CONSTRAINT FK_Request_DestWarehouse FOREIGN KEY (DestinationWarehouseId) REFERENCES Warehouses(Id)
    );

    CREATE INDEX IDX_Request_Status ON Requests(Status);
    CREATE INDEX IDX_Request_Type ON Requests(Type);
END
GO

-- RequestItem
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'RequestItems')
BEGIN
    CREATE TABLE RequestItems (
        RequestId BIGINT NOT NULL,
        ProductId BIGINT NOT NULL,
        Quantity INT NOT NULL,
        LocationId BIGINT NULL, -- Target location for Inbound
        SourceLocationId BIGINT NULL, -- For Internal Movement
        DestinationLocationId BIGINT NULL, -- For Internal Movement
        ReceivedQuantity INT NULL, -- Actual received for Inbound
        PickedQuantity INT NULL, -- Actual picked for Outbound
        PRIMARY KEY (RequestId, ProductId),
        CONSTRAINT FK_RequestItem_Request FOREIGN KEY (RequestId) REFERENCES Requests(Id),
        CONSTRAINT FK_RequestItem_Product FOREIGN KEY (ProductId) REFERENCES Products(Id),
        CONSTRAINT FK_RequestItem_Location FOREIGN KEY (LocationId) REFERENCES Locations(Id),
        CONSTRAINT FK_RequestItem_SourceLoc FOREIGN KEY (SourceLocationId) REFERENCES Locations(Id),
        CONSTRAINT FK_RequestItem_DestLoc FOREIGN KEY (DestinationLocationId) REFERENCES Locations(Id)
    );
END
GO

/* =====================================================
   4. Sales (Non-financial)
   ===================================================== */

-- Customer
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Customers')
BEGIN
    CREATE TABLE Customers (
        Id BIGINT IDENTITY(1,1) PRIMARY KEY,
        Code NVARCHAR(50) NOT NULL UNIQUE,
        Name NVARCHAR(255) NOT NULL,
        ContactInfo NVARCHAR(500),
        Status NVARCHAR(50) DEFAULT 'Active'
    );
END
GO

-- SalesOrder
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'SalesOrders')
BEGIN
    CREATE TABLE SalesOrders (
        Id BIGINT IDENTITY(1,1) PRIMARY KEY,
        OrderNo NVARCHAR(50) NOT NULL UNIQUE,
        CustomerId BIGINT NOT NULL,
        Status NVARCHAR(50) NOT NULL, -- Draft / Confirmed / FulfillmentRequested / Completed / Cancelled
        CreatedBy BIGINT NOT NULL,
        CreatedAt DATETIME2 DEFAULT GETDATE(),
        ConfirmedBy BIGINT NULL,
        ConfirmedDate DATETIME2 NULL,
        CancelledBy BIGINT NULL,
        CancelledDate DATETIME2 NULL,
        CancellationReason NVARCHAR(500) NULL,
        CONSTRAINT FK_SalesOrder_Customer FOREIGN KEY (CustomerId) REFERENCES Customers(Id),
        CONSTRAINT FK_SalesOrder_User FOREIGN KEY (CreatedBy) REFERENCES Users(Id)
    );
END
GO

-- SalesOrderItem
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'SalesOrderItems')
BEGIN
    CREATE TABLE SalesOrderItems (
        SalesOrderId BIGINT NOT NULL,
        ProductId BIGINT NOT NULL,
        Quantity INT NOT NULL,
        PRIMARY KEY (SalesOrderId, ProductId),
        CONSTRAINT FK_SOItem_Order FOREIGN KEY (SalesOrderId) REFERENCES SalesOrders(Id),
        CONSTRAINT FK_SOItem_Product FOREIGN KEY (ProductId) REFERENCES Products(Id)
    );
END
GO

/* =====================================================
   End of Script
   ===================================================== */
