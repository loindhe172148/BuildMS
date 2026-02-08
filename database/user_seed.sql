-- =====================================================
-- Smart WMS - User Seed Data
-- =====================================================
-- This script creates test users for each role
-- All passwords are hashed using SHA-256 with salt
-- Default password for all users: password123
-- ⚠️ CHANGE PASSWORDS IN PRODUCTION!
-- =====================================================

USE smartwms_db;
GO

-- Clear existing test users (optional - uncomment if needed)
-- DELETE FROM Users WHERE Username IN ('admin', 'manager', 'staff', 'sales', 'testuser1', 'testuser2');
-- GO

-- Admin User
-- Username: admin
-- Password: password123
-- Role: Admin (full system access)
IF NOT EXISTS (SELECT 1 FROM Users WHERE Username = 'admin')
BEGIN
    INSERT INTO Users (Username, Name, Email, PasswordHash, Role, Status, CreatedAt)
    VALUES ('admin', 'System Administrator', 'admin@smartwms.com', 
            'ySH1msblDV9A5mIhccyCyA==:qpNUJGRQUR2j/NDJ9RR0HjIPqqGingQMxu9zgbQMDOQ=', 
            'Admin', 'Active', GETDATE());
    PRINT 'Created user: admin (Admin)';
END
ELSE
BEGIN
    PRINT 'User admin already exists';
END
GO

-- Manager User
-- Username: manager
-- Password: password123
-- Role: Manager (warehouse operations management)
IF NOT EXISTS (SELECT 1 FROM Users WHERE Username = 'manager')
BEGIN
    INSERT INTO Users (Username, Name, Email, PasswordHash, Role, Status, WarehouseId, CreatedAt)
        VALUES ('manager', 'Warehouse Manager', 'manager@smartwms.com', 
            'HtP9svA7PCLX+KbNSg6SLg==:GrYU4rhzbSwCeRRWVLAePvk22fZ/CyukvK0LztFHbo8=',
            'Manager', 'Active', 1, GETDATE());
    PRINT 'Created user: manager (Manager)';
END
ELSE
BEGIN
    PRINT 'User manager already exists';
END
GO

-- Staff User
-- Username: staff
-- Password: password123
-- Role: Staff (inventory operations)
IF NOT EXISTS (SELECT 1 FROM Users WHERE Username = 'staff')
BEGIN
    INSERT INTO Users (Username, Name, Email, PasswordHash, Role, Status, WarehouseId, CreatedAt)
        VALUES ('staff', 'Warehouse Staff', 'staff@smartwms.com', 
            '+v2UFEWbu2OH5fjtrrg/2A==:B7gfAxygBXVOpVmuTkJQybApgOSOJVTrxE3whcIJ2Zs=',
            'Staff', 'Active', 1, GETDATE());
    PRINT 'Created user: staff (Staff)';
END
ELSE
BEGIN
    PRINT 'User staff already exists';
END
GO

-- Sales User
-- Username: sales
-- Password: password123
-- Role: Sales (sales order management)
IF NOT EXISTS (SELECT 1 FROM Users WHERE Username = 'sales')
BEGIN
    INSERT INTO Users (Username, Name, Email, PasswordHash, Role, Status, CreatedAt)
        VALUES ('sales', 'Sales Representative', 'sales@smartwms.com', 
            'Y+til+fcii/WiLxxWssyOg==:9kNxa9TkKpG8Hz59fOr9QX9PbCgisbbSOAtKEJJbB/U=',
            'Sales', 'Active', GETDATE());
    PRINT 'Created user: sales (Sales)';
END
ELSE
BEGIN
    PRINT 'User sales already exists';
END
GO

-- Additional Test Users

-- Test Manager 2
IF NOT EXISTS (SELECT 1 FROM Users WHERE Username = 'testmanager')
BEGIN
    INSERT INTO Users (Username, Name, Email, PasswordHash, Role, Status, WarehouseId, CreatedAt)
        VALUES ('testmanager', 'Test Manager', 'testmanager@smartwms.com', 
            'HtP9svA7PCLX+KbNSg6SLg==:GrYU4rhzbSwCeRRWVLAePvk22fZ/CyukvK0LztFHbo8=',
            'Manager', 'Active', 2, GETDATE());
    PRINT 'Created user: testmanager (Manager)';
END
ELSE
BEGIN
    PRINT 'User testmanager already exists';
END
GO

-- Test Staff 2
IF NOT EXISTS (SELECT 1 FROM Users WHERE Username = 'teststaff')
BEGIN
    INSERT INTO Users (Username, Name, Email, PasswordHash, Role, Status, WarehouseId, CreatedAt)
        VALUES ('teststaff', 'Test Staff', 'teststaff@smartwms.com', 
            '+v2UFEWbu2OH5fjtrrg/2A==:B7gfAxygBXVOpVmuTkJQybApgOSOJVTrxE3whcIJ2Zs=',
            'Staff', 'Active', 2, GETDATE());
    PRINT 'Created user: teststaff (Staff)';
END
ELSE
BEGIN
    PRINT 'User teststaff already exists';
END
GO

-- Display created users
PRINT '';
PRINT '==============================================';
PRINT 'User Seed Data Successfully Created';
PRINT '==============================================';
PRINT 'Total Users: ' + CAST((SELECT COUNT(*) FROM Users) AS VARCHAR);
PRINT '';
PRINT 'Test Credentials:';
PRINT '  Admin:    admin / password123';
PRINT '  Manager:  manager / password123';
PRINT '  Staff:    staff / password123';
PRINT '  Sales:    sales / password123';
PRINT '';
PRINT '⚠️  CHANGE ALL PASSWORDS IMMEDIATELY IN PRODUCTION!';
PRINT '==============================================';
GO

-- Display user summary
SELECT 
    Username,
    Name,
    Email,
    Role,
    Status,
    WarehouseId,
    CONVERT(VARCHAR, CreatedAt, 120) AS CreatedAt
FROM Users
ORDER BY 
    CASE Role 
        WHEN 'Admin' THEN 1
        WHEN 'Manager' THEN 2
        WHEN 'Staff' THEN 3
        WHEN 'Sales' THEN 4
    END,
    Username;
GO
