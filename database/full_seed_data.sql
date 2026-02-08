-- =====================================================
-- Smart WMS - Full Seed Data (Excluding Users)
-- Building Materials Warehouse Management System
-- =====================================================
-- This script populates all tables except Users
-- Run after schema.sql and user_seed.sql
-- =====================================================

USE smartwms_db;
GO

BEGIN TRANSACTION;

-- =====================================================
-- 1. CATEGORIES (Building Materials)
-- =====================================================
PRINT 'Inserting Categories...';

-- Clear existing data (in reverse FK order)
DELETE FROM RequestItems;
DELETE FROM Requests;
DELETE FROM SalesOrderItems;
DELETE FROM SalesOrders;
DELETE FROM Inventory;
DELETE FROM Locations;
DELETE FROM Products;
DELETE FROM Categories;
DELETE FROM Customers;
DELETE FROM Warehouses;

SET IDENTITY_INSERT Categories ON;

INSERT INTO Categories (Id, Name, Description) VALUES
(1, 'Cement & Concrete', 'Portland cement, ready-mix, concrete additives and mixing materials'),
(2, 'Bricks & Blocks', 'Clay bricks, concrete blocks, hollow blocks, AAC blocks'),
(3, 'Steel & Rebar', 'Reinforcement bars, steel sections, wire mesh, structural steel'),
(4, 'Tiles & Flooring', 'Ceramic tiles, porcelain, vinyl, floor tiles, wall tiles'),
(5, 'Timber & Plywood', 'Lumber, plywood sheets, timber products, MDF, particleboard'),
(6, 'Paints & Coatings', 'Interior/exterior paints, primers, coatings, varnishes'),
(7, 'Roofing & Gutters', 'Roof sheets, tiles, guttering, flashings, waterproofing'),
(8, 'Plumbing & Pipes', 'PVC/HDPE/Steel pipes, fittings, valves, plumbing fixtures'),
(9, 'Electrical', 'Cables, conduits, switches, fittings, circuit breakers'),
(10, 'Fasteners & Fixings', 'Nails, screws, bolts, anchors, adhesives');

SET IDENTITY_INSERT Categories OFF;

-- =====================================================
-- 2. PRODUCTS (Building Materials)
-- =====================================================
PRINT 'Inserting Products...';

SET IDENTITY_INSERT Products ON;

INSERT INTO Products (Id, SKU, Name, Unit, CategoryId, IsActive, CreatedAt) VALUES
-- Cement & Concrete (CategoryId = 1)
(1, 'CEM-50-OPC', 'Portland Cement OPC 50kg Bag', 'bag', 1, 1, GETDATE()),
(2, 'CEM-50-PPC', 'Portland Pozzolana Cement 50kg Bag', 'bag', 1, 1, GETDATE()),
(3, 'CEM-RM-25', 'Ready-Mix Concrete 25MPa (per m3)', 'm3', 1, 1, GETDATE()),
(4, 'CEM-RM-30', 'Ready-Mix Concrete 30MPa (per m3)', 'm3', 1, 1, GETDATE()),
(5, 'ADM-PLAST', 'Plasticizer Admixture 20L', 'litre', 1, 1, GETDATE()),
(6, 'ADM-RETARD', 'Retarder Admixture 20L', 'litre', 1, 1, GETDATE()),

-- Bricks & Blocks (CategoryId = 2)
(7, 'BRK-STD-RED', 'Red Clay Brick (Standard 230x110x76mm)', 'pcs', 2, 1, GETDATE()),
(8, 'BRK-STD-YEL', 'Yellow Clay Brick (Standard 230x110x76mm)', 'pcs', 2, 1, GETDATE()),
(9, 'BLK-100', 'Concrete Block 100x200x400mm', 'pcs', 2, 1, GETDATE()),
(10, 'BLK-150', 'Concrete Block 150x200x400mm', 'pcs', 2, 1, GETDATE()),
(11, 'BLK-200', 'Concrete Block 200x200x400mm', 'pcs', 2, 1, GETDATE()),
(12, 'BLK-AAC', 'AAC Lightweight Block 600x200x100mm', 'pcs', 2, 1, GETDATE()),

-- Steel & Rebar (CategoryId = 3)
(13, 'RBR-08', 'Rebar B500 8mm (per meter)', 'm', 3, 1, GETDATE()),
(14, 'RBR-10', 'Rebar B500 10mm (per meter)', 'm', 3, 1, GETDATE()),
(15, 'RBR-12', 'Rebar B500 12mm (per meter)', 'm', 3, 1, GETDATE()),
(16, 'RBR-16', 'Rebar B500 16mm (per meter)', 'm', 3, 1, GETDATE()),
(17, 'RBR-20', 'Rebar B500 20mm (per meter)', 'm', 3, 1, GETDATE()),
(18, 'STL-UB-100', 'Steel U-Channel 100x50 (per meter)', 'm', 3, 1, GETDATE()),
(19, 'STL-IB-200', 'Steel I-Beam 200x100 (per meter)', 'm', 3, 1, GETDATE()),
(20, 'WRM-6X6', 'Wire Mesh 6x6 (per sheet)', 'sheet', 3, 1, GETDATE()),

-- Tiles & Flooring (CategoryId = 4)
(21, 'TLE-FLR-300', 'Porcelain Floor Tile 300x300mm (per box)', 'box', 4, 1, GETDATE()),
(22, 'TLE-FLR-600', 'Porcelain Floor Tile 600x600mm (per box)', 'box', 4, 1, GETDATE()),
(23, 'TLE-WLL-250', 'Ceramic Wall Tile 250x400mm (per box)', 'box', 4, 1, GETDATE()),
(24, 'TLE-WLL-300', 'Ceramic Wall Tile 300x600mm (per box)', 'box', 4, 1, GETDATE()),
(25, 'VNL-PLK', 'Vinyl Plank Flooring (per box)', 'box', 4, 1, GETDATE()),
(26, 'TLE-GROUT', 'Tile Grout 5kg Bag', 'bag', 4, 1, GETDATE()),

-- Timber & Plywood (CategoryId = 5)
(27, 'PLY-12-1224', 'Plywood 12mm 1220x2440mm', 'sheet', 5, 1, GETDATE()),
(28, 'PLY-18-1224', 'Plywood 18mm 1220x2440mm', 'sheet', 5, 1, GETDATE()),
(29, 'PLY-25-1224', 'Plywood 25mm 1220x2440mm', 'sheet', 5, 1, GETDATE()),
(30, 'TMB-2X4', 'Sawn Timber 2x4 (per meter)', 'm', 5, 1, GETDATE()),
(31, 'TMB-2X6', 'Sawn Timber 2x6 (per meter)', 'm', 5, 1, GETDATE()),
(32, 'MDF-18', 'MDF Board 18mm 1220x2440mm', 'sheet', 5, 1, GETDATE()),

-- Paints & Coatings (CategoryId = 6)
(33, 'PNT-WHT-5L', 'Interior Emulsion Paint White 5L', 'can', 6, 1, GETDATE()),
(34, 'PNT-WHT-20L', 'Interior Emulsion Paint White 20L', 'can', 6, 1, GETDATE()),
(35, 'PNT-EXT-5L', 'Exterior Weather Paint White 5L', 'can', 6, 1, GETDATE()),
(36, 'PNT-EXT-20L', 'Exterior Weather Paint White 20L', 'can', 6, 1, GETDATE()),
(37, 'PRM-1L', 'Multi-surface Primer 1L', 'can', 6, 1, GETDATE()),
(38, 'PRM-5L', 'Multi-surface Primer 5L', 'can', 6, 1, GETDATE()),
(39, 'VRN-WOOD-1L', 'Wood Varnish Clear 1L', 'can', 6, 1, GETDATE()),

-- Roofing & Gutters (CategoryId = 7)
(40, 'RF-GL-06', 'Galvanized Roof Sheet 0.6mm (per sheet)', 'sheet', 7, 1, GETDATE()),
(41, 'RF-GL-08', 'Galvanized Roof Sheet 0.8mm (per sheet)', 'sheet', 7, 1, GETDATE()),
(42, 'RF-COLOR', 'Color Coated Roof Sheet (per sheet)', 'sheet', 7, 1, GETDATE()),
(43, 'RF-CLAY', 'Clay Roof Tile (interlocking)', 'pcs', 7, 1, GETDATE()),
(44, 'GT-PVC-100', 'PVC Gutter 100mm (per meter)', 'm', 7, 1, GETDATE()),
(45, 'WP-MEMBRANE', 'Waterproofing Membrane Roll', 'roll', 7, 1, GETDATE()),

-- Plumbing & Pipes (CategoryId = 8)
(46, 'PVC-50', 'PVC Pipe 50mm (per meter)', 'm', 8, 1, GETDATE()),
(47, 'PVC-75', 'PVC Pipe 75mm (per meter)', 'm', 8, 1, GETDATE()),
(48, 'PVC-110', 'PVC Pipe 110mm (per meter)', 'm', 8, 1, GETDATE()),
(49, 'PVC-ELB-50', 'PVC Elbow 50mm 90°', 'pcs', 8, 1, GETDATE()),
(50, 'PVC-ELB-110', 'PVC Elbow 110mm 90°', 'pcs', 8, 1, GETDATE()),
(51, 'PVC-TEE-50', 'PVC Tee 50mm', 'pcs', 8, 1, GETDATE()),
(52, 'HDPE-50', 'HDPE Pipe 50mm (per meter)', 'm', 8, 1, GETDATE()),
(53, 'VLV-GATE-50', 'Gate Valve 50mm', 'pcs', 8, 1, GETDATE()),

-- Electrical (CategoryId = 9)
(54, 'CBL-1C-2.5', 'Single Core Cable 2.5mm2 (per 100m)', 'roll', 9, 1, GETDATE()),
(55, 'CBL-3C-2.5', '3-Core Cable 2.5mm2 (per 100m)', 'roll', 9, 1, GETDATE()),
(56, 'CBL-3C-6', '3-Core Power Cable 6mm2 (per 100m)', 'roll', 9, 1, GETDATE()),
(57, 'CND-20', 'PVC Conduit 20mm (per meter)', 'm', 9, 1, GETDATE()),
(58, 'CND-25', 'PVC Conduit 25mm (per meter)', 'm', 9, 1, GETDATE()),
(59, 'SW-1G', 'Toggle Switch 1-Gang', 'pcs', 9, 1, GETDATE()),
(60, 'SW-2G', 'Toggle Switch 2-Gang', 'pcs', 9, 1, GETDATE()),
(61, 'SW-3G', 'Toggle Switch 3-Gang', 'pcs', 9, 1, GETDATE()),
(62, 'SCK-13A', 'Power Socket 13A', 'pcs', 9, 1, GETDATE()),
(63, 'MCB-20A', 'Circuit Breaker MCB 20A', 'pcs', 9, 1, GETDATE()),

-- Fasteners & Fixings (CategoryId = 10)
(64, 'SCR-40', 'Wood Screw 4x40mm Box (100 pcs)', 'box', 10, 1, GETDATE()),
(65, 'SCR-50', 'Wood Screw 5x50mm Box (100 pcs)', 'box', 10, 1, GETDATE()),
(66, 'SCR-75', 'Wood Screw 5x75mm Box (100 pcs)', 'box', 10, 1, GETDATE()),
(67, 'NL-50', 'Wire Nails 50mm (per kg)', 'kg', 10, 1, GETDATE()),
(68, 'NL-75', 'Wire Nails 75mm (per kg)', 'kg', 10, 1, GETDATE()),
(69, 'NL-100', 'Wire Nails 100mm (per kg)', 'kg', 10, 1, GETDATE()),
(70, 'ANR-08', 'Concrete Anchor M8 (pack of 10)', 'pack', 10, 1, GETDATE()),
(71, 'ANR-10', 'Concrete Anchor M10 (pack of 10)', 'pack', 10, 1, GETDATE()),
(72, 'ANR-12', 'Concrete Anchor M12 (pack of 10)', 'pack', 10, 1, GETDATE()),
(73, 'BLT-M10', 'Hex Bolt M10x50 (pack of 20)', 'pack', 10, 1, GETDATE()),
(74, 'BLT-M12', 'Hex Bolt M12x75 (pack of 20)', 'pack', 10, 1, GETDATE()),
(75, 'ADH-CONST', 'Construction Adhesive 310ml', 'tube', 10, 1, GETDATE());

SET IDENTITY_INSERT Products OFF;

-- =====================================================
-- 3. WAREHOUSES
-- =====================================================
PRINT 'Inserting Warehouses...';

SET IDENTITY_INSERT Warehouses ON;

INSERT INTO Warehouses (Id, Name, Location, CreatedAt) VALUES
(1, 'Central Distribution Center', '123 Industrial Avenue, District 7, Ho Chi Minh City', GETDATE()),
(2, 'North Region Warehouse', '456 Logistics Park, Long Bien, Hanoi', GETDATE()),
(3, 'South Region Warehouse', '789 Trade Zone, Binh Duong Province', GETDATE()),
(4, 'Construction Site Storage', '101 Project Boulevard, Thu Duc City', GETDATE());

SET IDENTITY_INSERT Warehouses OFF;

-- =====================================================
-- 4. LOCATIONS (Storage Bins within Warehouses)
-- =====================================================
PRINT 'Inserting Locations...';

SET IDENTITY_INSERT Locations ON;

-- Central Distribution Center (Warehouse 1) - Large facility with multiple zones
INSERT INTO Locations (Id, WarehouseId, Code, Type, IsActive) VALUES
-- Storage Zone A (Heavy materials - Cement, Steel)
(1, 1, 'A-01-01', 'Storage', 1),
(2, 1, 'A-01-02', 'Storage', 1),
(3, 1, 'A-01-03', 'Storage', 1),
(4, 1, 'A-02-01', 'Storage', 1),
(5, 1, 'A-02-02', 'Storage', 1),
(6, 1, 'A-02-03', 'Storage', 1),
-- Storage Zone B (Bricks, Blocks, Tiles)
(7, 1, 'B-01-01', 'Storage', 1),
(8, 1, 'B-01-02', 'Storage', 1),
(9, 1, 'B-02-01', 'Storage', 1),
(10, 1, 'B-02-02', 'Storage', 1),
-- Storage Zone C (Timber, Plywood)
(11, 1, 'C-01-01', 'Storage', 1),
(12, 1, 'C-01-02', 'Storage', 1),
(13, 1, 'C-02-01', 'Storage', 1),
-- Storage Zone D (Paints, Electrical, Small Items)
(14, 1, 'D-01-01', 'Storage', 1),
(15, 1, 'D-01-02', 'Storage', 1),
(16, 1, 'D-02-01', 'Storage', 1),
(17, 1, 'D-02-02', 'Storage', 1),
-- Picking Zone
(18, 1, 'PICK-01', 'Picking', 1),
(19, 1, 'PICK-02', 'Picking', 1),
(20, 1, 'PICK-03', 'Picking', 1),
-- Staging Area
(21, 1, 'STAGE-IN', 'Staging', 1),
(22, 1, 'STAGE-OUT', 'Staging', 1),

-- North Region Warehouse (Warehouse 2)
(23, 2, 'N-A-01', 'Storage', 1),
(24, 2, 'N-A-02', 'Storage', 1),
(25, 2, 'N-A-03', 'Storage', 1),
(26, 2, 'N-B-01', 'Storage', 1),
(27, 2, 'N-B-02', 'Storage', 1),
(28, 2, 'N-C-01', 'Storage', 1),
(29, 2, 'N-C-02', 'Storage', 1),
(30, 2, 'N-PICK-01', 'Picking', 1),
(31, 2, 'N-PICK-02', 'Picking', 1),
(32, 2, 'N-STAGE', 'Staging', 1),

-- South Region Warehouse (Warehouse 3)
(33, 3, 'S-A-01', 'Storage', 1),
(34, 3, 'S-A-02', 'Storage', 1),
(35, 3, 'S-A-03', 'Storage', 1),
(36, 3, 'S-B-01', 'Storage', 1),
(37, 3, 'S-B-02', 'Storage', 1),
(38, 3, 'S-C-01', 'Storage', 1),
(39, 3, 'S-PICK-01', 'Picking', 1),
(40, 3, 'S-STAGE', 'Staging', 1),

-- Construction Site Storage (Warehouse 4) - Smaller temporary storage
(41, 4, 'SITE-01', 'Storage', 1),
(42, 4, 'SITE-02', 'Storage', 1),
(43, 4, 'SITE-03', 'Storage', 1),
(44, 4, 'SITE-STAGE', 'Staging', 1);

SET IDENTITY_INSERT Locations OFF;

-- =====================================================
-- 5. CUSTOMERS
-- =====================================================
PRINT 'Inserting Customers...';

SET IDENTITY_INSERT Customers ON;

INSERT INTO Customers (Id, Code, Name, ContactInfo, Status) VALUES
(1, 'CUS-001', 'ABC Construction Co., Ltd.', 'Tel: 028-1234-5678 | Email: contact@abcconstruction.vn | Address: 100 Le Loi, District 1, HCMC', 'Active'),
(2, 'CUS-002', 'Vietnam Building Solutions', 'Tel: 024-9876-5432 | Email: sales@vbs.vn | Address: 50 Tran Hung Dao, Hoan Kiem, Hanoi', 'Active'),
(3, 'CUS-003', 'Green Home Developers', 'Tel: 028-2468-1357 | Email: info@greenhome.vn | Address: 200 Nguyen Van Linh, District 7, HCMC', 'Active'),
(4, 'CUS-004', 'Metro Infrastructure Ltd.', 'Tel: 028-1357-2468 | Email: procurement@metroinfra.vn | Address: 75 Vo Van Kiet, District 5, HCMC', 'Active'),
(5, 'CUS-005', 'Sunrise Property Group', 'Tel: 024-5555-6666 | Email: orders@sunriseprop.vn | Address: 25 Kim Ma, Ba Dinh, Hanoi', 'Active'),
(6, 'CUS-006', 'Delta Engineering Corp.', 'Tel: 028-7777-8888 | Email: supply@deltaeng.vn | Address: 300 CMT8, District 3, HCMC', 'Active'),
(7, 'CUS-007', 'Harmony Interiors', 'Tel: 028-3333-4444 | Email: purchase@harmonyint.vn | Address: 150 Nguyen Thi Minh Khai, District 3, HCMC', 'Active'),
(8, 'CUS-008', 'Foundation First Contractors', 'Tel: 024-1111-2222 | Email: materials@foundationfirst.vn | Address: 80 Giang Vo, Dong Da, Hanoi', 'Active'),
(9, 'CUS-009', 'Premier Builders Association', 'Tel: 028-9999-0000 | Email: orders@premierbuilders.vn | Address: 500 Dien Bien Phu, Binh Thanh, HCMC', 'Inactive'),
(10, 'CUS-010', 'Urban Development Partners', 'Tel: 024-4444-5555 | Email: procurement@urbandev.vn | Address: 120 Xuan Thuy, Cau Giay, Hanoi', 'Active');

SET IDENTITY_INSERT Customers OFF;

-- =====================================================
-- 6. INVENTORY (Stock in Warehouses)
-- =====================================================
PRINT 'Inserting Inventory...';

-- Central Distribution Center (Warehouse 1) - Main stock
INSERT INTO Inventory (ProductId, WarehouseId, LocationId, Quantity) VALUES
-- Cement & Concrete in Zone A
(1, 1, 1, 500),   -- OPC Cement in A-01-01
(2, 1, 2, 300),   -- PPC Cement in A-01-02
(5, 1, 3, 100),   -- Plasticizer in A-01-03
(6, 1, 3, 80),    -- Retarder in A-01-03

-- Steel & Rebar in Zone A
(13, 1, 4, 2000), -- Rebar 8mm in A-02-01
(14, 1, 4, 1500), -- Rebar 10mm in A-02-01
(15, 1, 5, 1200), -- Rebar 12mm in A-02-02
(16, 1, 5, 800),  -- Rebar 16mm in A-02-02
(17, 1, 6, 500),  -- Rebar 20mm in A-02-03
(18, 1, 6, 200),  -- U-Channel in A-02-03
(19, 1, 6, 150),  -- I-Beam in A-02-03
(20, 1, 6, 100),  -- Wire Mesh in A-02-03

-- Bricks & Blocks in Zone B
(7, 1, 7, 5000),  -- Red Brick in B-01-01
(8, 1, 7, 3000),  -- Yellow Brick in B-01-01
(9, 1, 8, 1000),  -- Block 100 in B-01-02
(10, 1, 8, 800),  -- Block 150 in B-01-02
(11, 1, 9, 600),  -- Block 200 in B-02-01
(12, 1, 9, 400),  -- AAC Block in B-02-01

-- Tiles in Zone B
(21, 1, 10, 200), -- Floor Tile 300 in B-02-02
(22, 1, 10, 150), -- Floor Tile 600 in B-02-02
(23, 1, 10, 180), -- Wall Tile 250 in B-02-02
(24, 1, 10, 120), -- Wall Tile 300 in B-02-02
(25, 1, 10, 80),  -- Vinyl Plank in B-02-02
(26, 1, 10, 100), -- Grout in B-02-02

-- Timber & Plywood in Zone C
(27, 1, 11, 100), -- Plywood 12mm in C-01-01
(28, 1, 11, 150), -- Plywood 18mm in C-01-01
(29, 1, 12, 80),  -- Plywood 25mm in C-01-02
(30, 1, 12, 500), -- Timber 2x4 in C-01-02
(31, 1, 13, 400), -- Timber 2x6 in C-02-01
(32, 1, 13, 60),  -- MDF Board in C-02-01

-- Paints in Zone D
(33, 1, 14, 200), -- Paint White 5L in D-01-01
(34, 1, 14, 100), -- Paint White 20L in D-01-01
(35, 1, 14, 150), -- Exterior Paint 5L in D-01-01
(36, 1, 14, 80),  -- Exterior Paint 20L in D-01-01
(37, 1, 15, 300), -- Primer 1L in D-01-02
(38, 1, 15, 100), -- Primer 5L in D-01-02
(39, 1, 15, 50),  -- Wood Varnish in D-01-02

-- Roofing in Zone D
(40, 1, 16, 200), -- Roof Sheet 0.6mm in D-02-01
(41, 1, 16, 150), -- Roof Sheet 0.8mm in D-02-01
(42, 1, 16, 100), -- Color Roof in D-02-01
(43, 1, 16, 500), -- Clay Tile in D-02-01
(44, 1, 16, 200), -- PVC Gutter in D-02-01
(45, 1, 16, 50),  -- Waterproofing in D-02-01

-- Plumbing in Zone D
(46, 1, 17, 500), -- PVC 50mm in D-02-02
(47, 1, 17, 400), -- PVC 75mm in D-02-02
(48, 1, 17, 300), -- PVC 110mm in D-02-02
(49, 1, 17, 200), -- PVC Elbow 50 in D-02-02
(50, 1, 17, 150), -- PVC Elbow 110 in D-02-02
(51, 1, 17, 180), -- PVC Tee in D-02-02
(52, 1, 17, 200), -- HDPE 50mm in D-02-02
(53, 1, 17, 50),  -- Gate Valve in D-02-02

-- Electrical in Picking Zone
(54, 1, 18, 30),  -- Cable 1C-2.5 in PICK-01
(55, 1, 18, 25),  -- Cable 3C-2.5 in PICK-01
(56, 1, 18, 20),  -- Cable 3C-6 in PICK-01
(57, 1, 18, 500), -- Conduit 20mm in PICK-01
(58, 1, 18, 400), -- Conduit 25mm in PICK-01
(59, 1, 19, 200), -- Switch 1G in PICK-02
(60, 1, 19, 150), -- Switch 2G in PICK-02
(61, 1, 19, 100), -- Switch 3G in PICK-02
(62, 1, 19, 300), -- Socket 13A in PICK-02
(63, 1, 19, 100), -- MCB 20A in PICK-02

-- Fasteners in Picking Zone
(64, 1, 20, 100), -- Screw 40mm in PICK-03
(65, 1, 20, 120), -- Screw 50mm in PICK-03
(66, 1, 20, 80),  -- Screw 75mm in PICK-03
(67, 1, 20, 200), -- Nails 50mm in PICK-03
(68, 1, 20, 180), -- Nails 75mm in PICK-03
(69, 1, 20, 150), -- Nails 100mm in PICK-03
(70, 1, 20, 100), -- Anchor M8 in PICK-03
(71, 1, 20, 80),  -- Anchor M10 in PICK-03
(72, 1, 20, 60),  -- Anchor M12 in PICK-03
(73, 1, 20, 50),  -- Bolt M10 in PICK-03
(74, 1, 20, 40),  -- Bolt M12 in PICK-03
(75, 1, 20, 100); -- Adhesive in PICK-03

-- North Region Warehouse (Warehouse 2)
INSERT INTO Inventory (ProductId, WarehouseId, LocationId, Quantity) VALUES
(1, 2, 23, 200),  -- OPC Cement
(2, 2, 23, 150),  -- PPC Cement
(7, 2, 24, 2000), -- Red Brick
(11, 2, 24, 300), -- Block 200
(14, 2, 25, 800), -- Rebar 10mm
(16, 2, 25, 400), -- Rebar 16mm
(21, 2, 26, 80),  -- Floor Tile 300
(22, 2, 26, 60),  -- Floor Tile 600
(27, 2, 27, 50),  -- Plywood 12mm
(28, 2, 27, 60),  -- Plywood 18mm
(33, 2, 28, 100), -- Paint White 5L
(40, 2, 28, 80),  -- Roof Sheet 0.6mm
(46, 2, 29, 200), -- PVC 50mm
(48, 2, 29, 150), -- PVC 110mm
(54, 2, 30, 15),  -- Cable 1C-2.5
(59, 2, 30, 80),  -- Switch 1G
(65, 2, 31, 60),  -- Screw 50mm
(67, 2, 31, 100); -- Nails 50mm

-- South Region Warehouse (Warehouse 3)
INSERT INTO Inventory (ProductId, WarehouseId, LocationId, Quantity) VALUES
(1, 3, 33, 300),  -- OPC Cement
(2, 3, 33, 200),  -- PPC Cement
(5, 3, 33, 50),   -- Plasticizer
(7, 3, 34, 3000), -- Red Brick
(9, 3, 34, 500),  -- Block 100
(11, 3, 34, 400), -- Block 200
(13, 3, 35, 1000),-- Rebar 8mm
(14, 3, 35, 800), -- Rebar 10mm
(15, 3, 35, 600), -- Rebar 12mm
(21, 3, 36, 100), -- Floor Tile 300
(23, 3, 36, 80),  -- Wall Tile 250
(27, 3, 37, 40),  -- Plywood 12mm
(28, 3, 37, 50),  -- Plywood 18mm
(33, 3, 38, 80),  -- Paint White 5L
(37, 3, 38, 120), -- Primer 1L
(46, 3, 39, 250), -- PVC 50mm
(48, 3, 39, 180); -- PVC 110mm

-- Construction Site Storage (Warehouse 4) - Working stock
INSERT INTO Inventory (ProductId, WarehouseId, LocationId, Quantity) VALUES
(1, 4, 41, 50),   -- OPC Cement
(7, 4, 41, 500),  -- Red Brick
(11, 4, 41, 200), -- Block 200
(14, 4, 42, 300), -- Rebar 10mm
(16, 4, 42, 200), -- Rebar 16mm
(28, 4, 42, 20),  -- Plywood 18mm
(33, 4, 43, 20),  -- Paint White 5L
(46, 4, 43, 50),  -- PVC 50mm
(65, 4, 43, 10),  -- Screw 50mm
(67, 4, 43, 30);  -- Nails 50mm

-- =====================================================
-- 7. SALES ORDERS
-- =====================================================
-- Note: CreatedBy references Users table. Using ID 4 (sales user)
PRINT 'Inserting Sales Orders...';

SET IDENTITY_INSERT SalesOrders ON;

INSERT INTO SalesOrders (Id, OrderNo, CustomerId, Status, CreatedBy, CreatedAt, ConfirmedBy, ConfirmedDate, CancelledBy, CancelledDate, CancellationReason) VALUES
-- Completed Orders
(1, 'SO-2025-0001', 1, 'Completed', 4, '2025-01-05 09:00:00', 2, '2025-01-05 14:00:00', NULL, NULL, NULL),
(2, 'SO-2025-0002', 2, 'Completed', 4, '2025-01-08 10:30:00', 2, '2025-01-08 16:00:00', NULL, NULL, NULL),
(3, 'SO-2025-0003', 3, 'Completed', 4, '2025-01-10 11:00:00', 2, '2025-01-10 15:30:00', NULL, NULL, NULL),

-- Confirmed Orders (pending fulfillment)
(4, 'SO-2025-0004', 1, 'Confirmed', 4, '2025-01-15 09:30:00', 2, '2025-01-15 14:00:00', NULL, NULL, NULL),
(5, 'SO-2025-0005', 4, 'Confirmed', 4, '2025-01-18 10:00:00', 2, '2025-01-18 16:30:00', NULL, NULL, NULL),
(6, 'SO-2025-0006', 5, 'Confirmed', 4, '2025-01-20 11:30:00', 2, '2025-01-20 17:00:00', NULL, NULL, NULL),

-- FulfillmentRequested (outbound created)
(7, 'SO-2025-0007', 6, 'FulfillmentRequested', 4, '2025-01-22 09:00:00', 2, '2025-01-22 14:30:00', NULL, NULL, NULL),
(8, 'SO-2025-0008', 7, 'FulfillmentRequested', 4, '2025-01-25 10:30:00', 2, '2025-01-25 15:00:00', NULL, NULL, NULL),

-- Draft Orders
(9, 'SO-2025-0009', 8, 'Draft', 4, '2025-01-28 09:00:00', NULL, NULL, NULL, NULL, NULL),
(10, 'SO-2025-0010', 10, 'Draft', 4, '2025-01-30 11:00:00', NULL, NULL, NULL, NULL, NULL),

-- Cancelled Order
(11, 'SO-2025-0011', 9, 'Cancelled', 4, '2025-01-12 10:00:00', 2, '2025-01-12 14:00:00', 2, '2025-01-13 09:00:00', 'Customer requested cancellation due to project postponement');

SET IDENTITY_INSERT SalesOrders OFF;

-- =====================================================
-- 8. SALES ORDER ITEMS
-- =====================================================
PRINT 'Inserting Sales Order Items...';

-- SO-2025-0001 (ABC Construction - Completed)
INSERT INTO SalesOrderItems (SalesOrderId, ProductId, Quantity) VALUES
(1, 1, 100),  -- OPC Cement x100 bags
(1, 7, 1000), -- Red Brick x1000 pcs
(1, 14, 200); -- Rebar 10mm x200 m

-- SO-2025-0002 (Vietnam Building Solutions - Completed)
INSERT INTO SalesOrderItems (SalesOrderId, ProductId, Quantity) VALUES
(2, 21, 50),  -- Floor Tile 300 x50 boxes
(2, 23, 40),  -- Wall Tile 250 x40 boxes
(2, 26, 20);  -- Grout x20 bags

-- SO-2025-0003 (Green Home - Completed)
INSERT INTO SalesOrderItems (SalesOrderId, ProductId, Quantity) VALUES
(3, 33, 30),  -- Paint White 5L x30 cans
(3, 37, 50),  -- Primer 1L x50 cans
(3, 28, 25);  -- Plywood 18mm x25 sheets

-- SO-2025-0004 (ABC Construction - Confirmed)
INSERT INTO SalesOrderItems (SalesOrderId, ProductId, Quantity) VALUES
(4, 1, 150),   -- OPC Cement x150 bags
(4, 2, 100),   -- PPC Cement x100 bags
(4, 11, 200),  -- Block 200 x200 pcs
(4, 16, 300);  -- Rebar 16mm x300 m

-- SO-2025-0005 (Metro Infrastructure - Confirmed)
INSERT INTO SalesOrderItems (SalesOrderId, ProductId, Quantity) VALUES
(5, 13, 500),  -- Rebar 8mm x500 m
(5, 14, 400),  -- Rebar 10mm x400 m
(5, 15, 300),  -- Rebar 12mm x300 m
(5, 19, 50);   -- I-Beam x50 m

-- SO-2025-0006 (Sunrise Property - Confirmed)
INSERT INTO SalesOrderItems (SalesOrderId, ProductId, Quantity) VALUES
(6, 40, 100),  -- Roof Sheet 0.6mm x100 sheets
(6, 42, 80),   -- Color Roof x80 sheets
(6, 44, 100),  -- PVC Gutter x100 m
(6, 45, 20);   -- Waterproofing x20 rolls

-- SO-2025-0007 (Delta Engineering - FulfillmentRequested)
INSERT INTO SalesOrderItems (SalesOrderId, ProductId, Quantity) VALUES
(7, 46, 200),  -- PVC 50mm x200 m
(7, 48, 150),  -- PVC 110mm x150 m
(7, 49, 100),  -- PVC Elbow 50 x100 pcs
(7, 50, 80),   -- PVC Elbow 110 x80 pcs
(7, 53, 20);   -- Gate Valve x20 pcs

-- SO-2025-0008 (Harmony Interiors - FulfillmentRequested)
INSERT INTO SalesOrderItems (SalesOrderId, ProductId, Quantity) VALUES
(8, 21, 80),   -- Floor Tile 300 x80 boxes
(8, 22, 60),   -- Floor Tile 600 x60 boxes
(8, 25, 40),   -- Vinyl Plank x40 boxes
(8, 33, 50),   -- Paint White 5L x50 cans
(8, 39, 30);   -- Wood Varnish x30 cans

-- SO-2025-0009 (Foundation First - Draft)
INSERT INTO SalesOrderItems (SalesOrderId, ProductId, Quantity) VALUES
(9, 1, 200),   -- OPC Cement x200 bags
(9, 5, 40),    -- Plasticizer x40 litres
(9, 14, 500),  -- Rebar 10mm x500 m
(9, 17, 200);  -- Rebar 20mm x200 m

-- SO-2025-0010 (Urban Development - Draft)
INSERT INTO SalesOrderItems (SalesOrderId, ProductId, Quantity) VALUES
(10, 54, 10),  -- Cable 1C-2.5 x10 rolls
(10, 55, 8),   -- Cable 3C-2.5 x8 rolls
(10, 59, 100), -- Switch 1G x100 pcs
(10, 62, 150), -- Socket 13A x150 pcs
(10, 63, 50);  -- MCB 20A x50 pcs

-- SO-2025-0011 (Premier Builders - Cancelled)
INSERT INTO SalesOrderItems (SalesOrderId, ProductId, Quantity) VALUES
(11, 7, 2000),  -- Red Brick x2000 pcs
(11, 11, 500);  -- Block 200 x500 pcs

-- =====================================================
-- 9. REQUESTS (Inbound, Outbound, Transfer, Internal)
-- =====================================================
-- Note: CreatedBy, ApprovedBy, etc. reference Users table
-- User IDs: 1=admin, 2=manager, 3=staff, 4=sales
PRINT 'Inserting Requests...';

SET IDENTITY_INSERT Requests ON;

INSERT INTO Requests (Id, Type, Status, CreatedBy, ApprovedBy, ApprovedDate, RejectedBy, RejectedDate, RejectionReason, CompletedBy, CompletedDate, SalesOrderId, SourceWarehouseId, DestinationWarehouseId, ExpectedDate, Notes, Reason, CreatedAt) VALUES
-- INBOUND REQUESTS
-- Completed Inbound (restocking)
(1, 'Inbound', 'Completed', 2, 1, '2025-01-03 10:00:00', NULL, NULL, NULL, 3, '2025-01-04 14:00:00', NULL, NULL, 1, '2025-01-04', 'Monthly cement restocking from supplier', NULL, '2025-01-02 09:00:00'),
(2, 'Inbound', 'Completed', 2, 1, '2025-01-06 11:00:00', NULL, NULL, NULL, 3, '2025-01-07 16:00:00', NULL, NULL, 1, '2025-01-07', 'Steel and rebar delivery', NULL, '2025-01-05 10:30:00'),
(3, 'Inbound', 'Completed', 2, 1, '2025-01-10 09:30:00', NULL, NULL, NULL, 3, '2025-01-11 15:00:00', NULL, NULL, 2, '2025-01-11', 'North warehouse initial stock', NULL, '2025-01-09 08:00:00'),

-- Approved Inbound (waiting execution)
(4, 'Inbound', 'Approved', 2, 1, '2025-01-25 14:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2025-02-01', 'Tiles and flooring materials', NULL, '2025-01-24 11:00:00'),
(5, 'Inbound', 'Approved', 2, 1, '2025-01-28 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, '2025-02-05', 'South warehouse restocking', NULL, '2025-01-27 09:00:00'),

-- InProgress Inbound
(6, 'Inbound', 'InProgress', 2, 1, '2025-01-29 15:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2025-01-31', 'Electrical supplies shipment - being received', NULL, '2025-01-28 14:00:00'),

-- Created Inbound (pending approval)
(7, 'Inbound', 'Created', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2025-02-10', 'Paint and coating materials from new supplier', NULL, '2025-01-30 10:00:00'),
(8, 'Inbound', 'Created', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4, '2025-02-15', 'Construction site materials', NULL, '2025-01-30 16:00:00'),

-- OUTBOUND REQUESTS (Sales-driven)
-- Completed Outbound (linked to completed sales orders)
(9, 'Outbound', 'Completed', 2, 1, '2025-01-05 15:00:00', NULL, NULL, NULL, 3, '2025-01-06 11:00:00', 1, 1, NULL, '2025-01-06', 'Delivery for SO-2025-0001', NULL, '2025-01-05 14:30:00'),
(10, 'Outbound', 'Completed', 2, 1, '2025-01-08 17:00:00', NULL, NULL, NULL, 3, '2025-01-09 10:00:00', 2, 1, NULL, '2025-01-09', 'Delivery for SO-2025-0002', NULL, '2025-01-08 16:30:00'),
(11, 'Outbound', 'Completed', 2, 1, '2025-01-10 16:00:00', NULL, NULL, NULL, 3, '2025-01-11 09:30:00', 3, 1, NULL, '2025-01-11', 'Delivery for SO-2025-0003', NULL, '2025-01-10 15:45:00'),

-- Approved Outbound (waiting execution)
(12, 'Outbound', 'Approved', 2, 1, '2025-01-22 15:00:00', NULL, NULL, NULL, NULL, NULL, 7, 1, NULL, '2025-01-24', 'Plumbing delivery for Delta Engineering', NULL, '2025-01-22 14:45:00'),
(13, 'Outbound', 'Approved', 2, 1, '2025-01-25 15:30:00', NULL, NULL, NULL, NULL, NULL, 8, 1, NULL, '2025-01-27', 'Interior materials for Harmony', NULL, '2025-01-25 15:15:00'),

-- Created Outbound (pending approval)
(14, 'Outbound', 'Created', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, '2025-02-02', 'Pending sales order fulfillment', NULL, '2025-01-30 11:00:00'),

-- INTERNAL OUTBOUND (Non-sales)
-- Completed Internal Outbound
(15, 'Outbound', 'Completed', 2, 1, '2025-01-15 10:00:00', NULL, NULL, NULL, 3, '2025-01-15 14:00:00', NULL, 1, NULL, NULL, 'Damaged materials disposal - water damaged cement bags', 'Damage/Disposal', '2025-01-14 16:00:00'),

-- Approved Internal Outbound
(16, 'Outbound', 'Approved', 2, 1, '2025-01-29 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, 'Sample materials for trade show', 'Sample/Demo', '2025-01-28 15:00:00'),

-- Created Internal Outbound
(17, 'Outbound', 'Created', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, 'Return defective switches to supplier', 'Return to Supplier', '2025-01-30 09:00:00'),

-- TRANSFER REQUESTS (Inter-warehouse)
-- Completed Transfer
(18, 'Transfer', 'Completed', 2, 1, '2025-01-12 10:00:00', NULL, NULL, NULL, 3, '2025-01-13 16:00:00', NULL, 1, 2, '2025-01-13', 'Stock transfer to North warehouse', NULL, '2025-01-11 14:00:00'),

-- InProgress Transfer
(19, 'Transfer', 'InProgress', 2, 1, '2025-01-27 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, 1, 3, '2025-01-30', 'Emergency stock to South warehouse', NULL, '2025-01-26 11:00:00'),

-- Approved Transfer
(20, 'Transfer', 'Approved', 2, 1, '2025-01-30 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, 1, 4, '2025-02-05', 'Materials for construction site', NULL, '2025-01-29 14:00:00'),

-- Created Transfer (pending approval)
(21, 'Transfer', 'Created', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, 3, '2025-02-10', 'Rebalancing stock between regional warehouses', NULL, '2025-01-30 15:00:00'),

-- REJECTED REQUEST (example)
(22, 'Inbound', 'Rejected', 2, NULL, NULL, 1, '2025-01-20 11:00:00', 'Supplier not approved. Please use authorized vendor list.', NULL, NULL, NULL, NULL, 1, '2025-01-25', 'Attempt to order from non-approved supplier', NULL, '2025-01-19 10:00:00'),

-- INTERNAL MOVEMENT (within same warehouse)
(23, 'Internal', 'Completed', 3, 2, '2025-01-17 09:00:00', NULL, NULL, NULL, 3, '2025-01-17 11:00:00', NULL, NULL, NULL, NULL, 'Reorganizing cement storage from A to C zone', NULL, '2025-01-16 16:00:00'),
(24, 'Internal', 'Created', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Moving overflow tiles to new location', NULL, '2025-01-30 14:00:00');

SET IDENTITY_INSERT Requests OFF;

-- =====================================================
-- 10. REQUEST ITEMS
-- =====================================================
PRINT 'Inserting Request Items...';

-- Request 1: Completed Inbound - Cement restocking
INSERT INTO RequestItems (RequestId, ProductId, Quantity, LocationId, SourceLocationId, DestinationLocationId, ReceivedQuantity, PickedQuantity) VALUES
(1, 1, 200, 1, NULL, NULL, 200, NULL),  -- OPC Cement -> A-01-01
(1, 2, 150, 2, NULL, NULL, 150, NULL);  -- PPC Cement -> A-01-02

-- Request 2: Completed Inbound - Steel delivery
INSERT INTO RequestItems (RequestId, ProductId, Quantity, LocationId, SourceLocationId, DestinationLocationId, ReceivedQuantity, PickedQuantity) VALUES
(2, 14, 500, 4, NULL, NULL, 500, NULL),  -- Rebar 10mm -> A-02-01
(2, 16, 300, 5, NULL, NULL, 300, NULL),  -- Rebar 16mm -> A-02-02
(2, 20, 50, 6, NULL, NULL, 50, NULL);    -- Wire Mesh -> A-02-03

-- Request 3: Completed Inbound - North warehouse stock
INSERT INTO RequestItems (RequestId, ProductId, Quantity, LocationId, SourceLocationId, DestinationLocationId, ReceivedQuantity, PickedQuantity) VALUES
(3, 1, 100, 23, NULL, NULL, 100, NULL),  -- OPC Cement
(3, 7, 1000, 24, NULL, NULL, 1000, NULL), -- Red Brick
(3, 14, 400, 25, NULL, NULL, 400, NULL); -- Rebar 10mm

-- Request 4: Approved Inbound - Tiles (waiting execution)
INSERT INTO RequestItems (RequestId, ProductId, Quantity, LocationId, SourceLocationId, DestinationLocationId, ReceivedQuantity, PickedQuantity) VALUES
(4, 21, 100, 10, NULL, NULL, NULL, NULL),  -- Floor Tile 300
(4, 22, 80, 10, NULL, NULL, NULL, NULL),   -- Floor Tile 600
(4, 23, 100, 10, NULL, NULL, NULL, NULL),  -- Wall Tile 250
(4, 26, 50, 10, NULL, NULL, NULL, NULL);   -- Grout

-- Request 5: Approved Inbound - South warehouse
INSERT INTO RequestItems (RequestId, ProductId, Quantity, LocationId, SourceLocationId, DestinationLocationId, ReceivedQuantity, PickedQuantity) VALUES
(5, 1, 150, 33, NULL, NULL, NULL, NULL),  -- OPC Cement
(5, 7, 2000, 34, NULL, NULL, NULL, NULL), -- Red Brick
(5, 14, 500, 35, NULL, NULL, NULL, NULL); -- Rebar 10mm

-- Request 6: InProgress Inbound - Electrical supplies
INSERT INTO RequestItems (RequestId, ProductId, Quantity, LocationId, SourceLocationId, DestinationLocationId, ReceivedQuantity, PickedQuantity) VALUES
(6, 54, 20, 18, NULL, NULL, 15, NULL),  -- Cable 1C-2.5 (partial received)
(6, 55, 15, 18, NULL, NULL, 10, NULL),  -- Cable 3C-2.5 (partial received)
(6, 59, 100, 19, NULL, NULL, 100, NULL); -- Switch 1G (complete)

-- Request 7: Created Inbound - Paint materials
INSERT INTO RequestItems (RequestId, ProductId, Quantity, LocationId, SourceLocationId, DestinationLocationId, ReceivedQuantity, PickedQuantity) VALUES
(7, 33, 100, 14, NULL, NULL, NULL, NULL),  -- Paint White 5L
(7, 34, 50, 14, NULL, NULL, NULL, NULL),   -- Paint White 20L
(7, 37, 150, 15, NULL, NULL, NULL, NULL),  -- Primer 1L
(7, 39, 30, 15, NULL, NULL, NULL, NULL);   -- Wood Varnish

-- Request 8: Created Inbound - Construction site
INSERT INTO RequestItems (RequestId, ProductId, Quantity, LocationId, SourceLocationId, DestinationLocationId, ReceivedQuantity, PickedQuantity) VALUES
(8, 1, 100, 41, NULL, NULL, NULL, NULL),   -- OPC Cement
(8, 14, 200, 42, NULL, NULL, NULL, NULL),  -- Rebar 10mm
(8, 28, 30, 42, NULL, NULL, NULL, NULL);   -- Plywood 18mm

-- Request 9: Completed Outbound - SO-2025-0001
INSERT INTO RequestItems (RequestId, ProductId, Quantity, LocationId, SourceLocationId, DestinationLocationId, ReceivedQuantity, PickedQuantity) VALUES
(9, 1, 100, NULL, 1, NULL, NULL, 100),   -- OPC Cement
(9, 7, 1000, NULL, 7, NULL, NULL, 1000), -- Red Brick
(9, 14, 200, NULL, 4, NULL, NULL, 200);  -- Rebar 10mm

-- Request 10: Completed Outbound - SO-2025-0002
INSERT INTO RequestItems (RequestId, ProductId, Quantity, LocationId, SourceLocationId, DestinationLocationId, ReceivedQuantity, PickedQuantity) VALUES
(10, 21, 50, NULL, 10, NULL, NULL, 50),  -- Floor Tile 300
(10, 23, 40, NULL, 10, NULL, NULL, 40),  -- Wall Tile 250
(10, 26, 20, NULL, 10, NULL, NULL, 20);  -- Grout

-- Request 11: Completed Outbound - SO-2025-0003
INSERT INTO RequestItems (RequestId, ProductId, Quantity, LocationId, SourceLocationId, DestinationLocationId, ReceivedQuantity, PickedQuantity) VALUES
(11, 33, 30, NULL, 14, NULL, NULL, 30),  -- Paint White 5L
(11, 37, 50, NULL, 15, NULL, NULL, 50),  -- Primer 1L
(11, 28, 25, NULL, 11, NULL, NULL, 25);  -- Plywood 18mm

-- Request 12: Approved Outbound - SO-2025-0007 (Delta Engineering)
INSERT INTO RequestItems (RequestId, ProductId, Quantity, LocationId, SourceLocationId, DestinationLocationId, ReceivedQuantity, PickedQuantity) VALUES
(12, 46, 200, NULL, 17, NULL, NULL, NULL),  -- PVC 50mm
(12, 48, 150, NULL, 17, NULL, NULL, NULL),  -- PVC 110mm
(12, 49, 100, NULL, 17, NULL, NULL, NULL),  -- PVC Elbow 50
(12, 50, 80, NULL, 17, NULL, NULL, NULL),   -- PVC Elbow 110
(12, 53, 20, NULL, 17, NULL, NULL, NULL);   -- Gate Valve

-- Request 13: Approved Outbound - SO-2025-0008 (Harmony)
INSERT INTO RequestItems (RequestId, ProductId, Quantity, LocationId, SourceLocationId, DestinationLocationId, ReceivedQuantity, PickedQuantity) VALUES
(13, 21, 80, NULL, 10, NULL, NULL, NULL),   -- Floor Tile 300
(13, 22, 60, NULL, 10, NULL, NULL, NULL),   -- Floor Tile 600
(13, 25, 40, NULL, 10, NULL, NULL, NULL),   -- Vinyl Plank
(13, 33, 50, NULL, 14, NULL, NULL, NULL),   -- Paint White 5L
(13, 39, 30, NULL, 15, NULL, NULL, NULL);   -- Wood Varnish

-- Request 14: Created Outbound
INSERT INTO RequestItems (RequestId, ProductId, Quantity, LocationId, SourceLocationId, DestinationLocationId, ReceivedQuantity, PickedQuantity) VALUES
(14, 1, 50, NULL, 1, NULL, NULL, NULL),    -- OPC Cement
(14, 11, 100, NULL, 9, NULL, NULL, NULL);  -- Block 200

-- Request 15: Completed Internal Outbound - Damage disposal
INSERT INTO RequestItems (RequestId, ProductId, Quantity, LocationId, SourceLocationId, DestinationLocationId, ReceivedQuantity, PickedQuantity) VALUES
(15, 1, 20, NULL, 1, NULL, NULL, 20);  -- Damaged OPC Cement bags

-- Request 16: Approved Internal Outbound - Sample/Demo
INSERT INTO RequestItems (RequestId, ProductId, Quantity, LocationId, SourceLocationId, DestinationLocationId, ReceivedQuantity, PickedQuantity) VALUES
(16, 21, 5, NULL, 10, NULL, NULL, NULL),   -- Floor Tile sample
(16, 22, 5, NULL, 10, NULL, NULL, NULL),   -- Floor Tile 600 sample
(16, 33, 2, NULL, 14, NULL, NULL, NULL);   -- Paint sample

-- Request 17: Created Internal Outbound - Return to Supplier
INSERT INTO RequestItems (RequestId, ProductId, Quantity, LocationId, SourceLocationId, DestinationLocationId, ReceivedQuantity, PickedQuantity) VALUES
(17, 59, 50, NULL, 19, NULL, NULL, NULL);  -- Defective Switch 1G

-- Request 18: Completed Transfer - Central to North
INSERT INTO RequestItems (RequestId, ProductId, Quantity, LocationId, SourceLocationId, DestinationLocationId, ReceivedQuantity, PickedQuantity) VALUES
(18, 1, 100, NULL, 1, 23, 100, 100),    -- OPC Cement
(18, 7, 1000, NULL, 7, 24, 1000, 1000), -- Red Brick
(18, 14, 400, NULL, 4, 25, 400, 400);   -- Rebar 10mm

-- Request 19: InProgress Transfer - Central to South
INSERT INTO RequestItems (RequestId, ProductId, Quantity, LocationId, SourceLocationId, DestinationLocationId, ReceivedQuantity, PickedQuantity) VALUES
(19, 1, 80, NULL, 1, 33, NULL, 80),    -- OPC Cement (picked, not received)
(19, 14, 200, NULL, 4, 35, NULL, 200), -- Rebar 10mm (picked, not received)
(19, 33, 50, NULL, 14, 38, NULL, 50);  -- Paint White 5L (picked, not received)

-- Request 20: Approved Transfer - Central to Site
INSERT INTO RequestItems (RequestId, ProductId, Quantity, LocationId, SourceLocationId, DestinationLocationId, ReceivedQuantity, PickedQuantity) VALUES
(20, 1, 100, NULL, 1, 41, NULL, NULL),   -- OPC Cement
(20, 7, 500, NULL, 7, 41, NULL, NULL),   -- Red Brick
(20, 14, 300, NULL, 4, 42, NULL, NULL),  -- Rebar 10mm
(20, 28, 30, NULL, 11, 42, NULL, NULL);  -- Plywood 18mm

-- Request 21: Created Transfer - North to South
INSERT INTO RequestItems (RequestId, ProductId, Quantity, LocationId, SourceLocationId, DestinationLocationId, ReceivedQuantity, PickedQuantity) VALUES
(21, 1, 50, NULL, 23, 33, NULL, NULL),   -- OPC Cement
(21, 7, 500, NULL, 24, 34, NULL, NULL);  -- Red Brick

-- Request 22: Rejected Inbound (no items needed, but adding for completeness)
INSERT INTO RequestItems (RequestId, ProductId, Quantity, LocationId, SourceLocationId, DestinationLocationId, ReceivedQuantity, PickedQuantity) VALUES
(22, 33, 200, 14, NULL, NULL, NULL, NULL),  -- Paint (from unapproved supplier)
(22, 35, 100, 14, NULL, NULL, NULL, NULL);  -- Exterior Paint

-- Request 23: Completed Internal Movement
INSERT INTO RequestItems (RequestId, ProductId, Quantity, LocationId, SourceLocationId, DestinationLocationId, ReceivedQuantity, PickedQuantity) VALUES
(23, 1, 50, NULL, 1, 11, 50, 50);  -- Moved cement from A-01-01 to C-01-01

-- Request 24: Created Internal Movement
INSERT INTO RequestItems (RequestId, ProductId, Quantity, LocationId, SourceLocationId, DestinationLocationId, ReceivedQuantity, PickedQuantity) VALUES
(24, 21, 30, NULL, 10, 7, NULL, NULL);  -- Move Floor Tiles from B-02-02 to B-01-01

COMMIT TRANSACTION;
GO

PRINT 'Seed data insertion completed successfully!';
PRINT '';
PRINT 'Summary:';
PRINT '  - Categories: 10';
PRINT '  - Products: 75';
PRINT '  - Warehouses: 4';
PRINT '  - Locations: 44';
PRINT '  - Customers: 10';
PRINT '  - Inventory records: 100+';
PRINT '  - Sales Orders: 11';
PRINT '  - Requests: 24 (various types and statuses)';
PRINT '';
PRINT 'Note: This seed data requires Users to exist with IDs 1-4';
PRINT '      Run user_seed.sql before this script.';
GO
