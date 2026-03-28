-- =====================================================
-- Smart WMS - Full Seed Data (Vietnamese)
-- BuildMS: Hệ thống quản lý kho vật liệu xây dựng
-- =====================================================
-- Bao gồm dữ liệu cho toàn bộ bảng, giữ nguyên Role: Admin/Manager/Staff/Sales
-- Script có thể chạy lại nhiều lần
-- =====================================================

USE smartwms_db;
GO

BEGIN TRANSACTION;

PRINT N'Xóa dữ liệu cũ...';

-- Xóa theo thứ tự phụ thuộc khóa ngoại
DELETE FROM RequestItems;
DELETE FROM Requests;
DELETE FROM SalesOrderItems;
DELETE FROM SalesOrders;
DELETE FROM Inventory;
DELETE FROM Locations;
DELETE FROM Products;
DELETE FROM Categories;
DELETE FROM Customers;
DELETE FROM Providers;
DELETE FROM Warehouses;

PRINT N'Thêm kho hàng...';

SET IDENTITY_INSERT Warehouses ON;

INSERT INTO Warehouses (Id, Name, Location, CreatedAt)
VALUES
    (1, N'Kho trung tâm TP.HCM', N'Khu công nghiệp Tân Bình, Quận Tân Phú, TP.HCM', GETDATE()),
    (2, N'Kho miền Bắc Hà Nội', N'KCN Sài Đồng, Long Biên, Hà Nội', GETDATE()),
    (3, N'Kho miền Trung Đà Nẵng', N'Đường số 5, KCN Hòa Khánh, Đà Nẵng', GETDATE()),
    (4, N'Kho vệ tinh Bình Dương', N'VSIP 1, Thuận An, Bình Dương', GETDATE());

SET IDENTITY_INSERT Warehouses OFF;

PRINT N'Thêm danh mục...';

SET IDENTITY_INSERT Categories ON;

INSERT INTO Categories (Id, Name, Description)
VALUES
    (1, N'Xi măng & phụ gia', N'Xi măng PCB/PC và các phụ gia trộn bê tông'),
    (2, N'Gạch & block', N'Gạch đất nung, gạch không nung, block bê tông'),
    (3, N'Thép xây dựng', N'Thép cuộn, thép cây vằn và lưới thép'),
    (4, N'Ốp lát', N'Gạch men, gạch granite, keo và ke ron'),
    (5, N'Ống nước & phụ kiện', N'Ống PVC/PPR và phụ kiện cấp thoát nước'),
    (6, N'Sơn & chống thấm', N'Sơn nội ngoại thất và vật tư chống thấm');

SET IDENTITY_INSERT Categories OFF;

PRINT N'Thêm sản phẩm...';

SET IDENTITY_INSERT Products ON;

INSERT INTO Products (Id, SKU, Name, Unit, CategoryId, IsActive, CreatedAt)
VALUES
    (1, N'XM-PCB40-50', N'Xi măng PCB40 bao 50kg', N'bao', 1, 1, GETDATE()),
    (2, N'XM-PC40-50', N'Xi măng PC40 bao 50kg', N'bao', 1, 1, GETDATE()),
    (3, N'PG-SIEUDEO-10', N'Phụ gia siêu dẻo can 10L', N'can', 1, 1, GETDATE()),
    (4, N'GACH-TUYNEN-2L', N'Gạch tuynel 2 lỗ', N'vien', 2, 1, GETDATE()),
    (5, N'GACH-BLOCK-100', N'Block bê tông 100x200x400', N'vien', 2, 1, GETDATE()),
    (6, N'GACH-AAC-600', N'Gạch AAC 600x200x100', N'vien', 2, 1, GETDATE()),
    (7, N'THEP-CB400-D10', N'Thép cây CB400 D10', N'cay', 3, 1, GETDATE()),
    (8, N'THEP-CB400-D12', N'Thép cây CB400 D12', N'cay', 3, 1, GETDATE()),
    (9, N'THEP-CUON-D6', N'Thép cuộn D6', N'kg', 3, 1, GETDATE()),
    (10, N'LUOITHEP-D4A100', N'Lưới thép hàn D4 a100', N'tam', 3, 1, GETDATE()),
    (11, N'GM-300-300', N'Gạch men 300x300', N'thung', 4, 1, GETDATE()),
    (12, N'GM-600-600', N'Gạch granite 600x600', N'thung', 4, 1, GETDATE()),
    (13, N'KEO-OPLAT-25', N'Keo ốp lát bao 25kg', N'bao', 4, 1, GETDATE()),
    (14, N'KERON-5', N'Ke ron bao 5kg', N'bao', 4, 1, GETDATE()),
    (15, N'ONG-PVC-27', N'Ống PVC phi 27', N'cay', 5, 1, GETDATE()),
    (16, N'ONG-PVC-60', N'Ống PVC phi 60', N'cay', 5, 1, GETDATE()),
    (17, N'ONG-PPR-25', N'Ống PPR phi 25', N'cay', 5, 1, GETDATE()),
    (18, N'CO-PVC-27', N'Co PVC phi 27', N'cai', 5, 1, GETDATE()),
    (19, N'TE-PVC-60', N'Tê PVC phi 60', N'cai', 5, 1, GETDATE()),
    (20, N'SON-NT-18L', N'Sơn nội thất trắng 18L', N'thung', 6, 1, GETDATE()),
    (21, N'SON-NG-18L', N'Sơn ngoại thất trắng 18L', N'thung', 6, 1, GETDATE()),
    (22, N'CHONGTHAM-20KG', N'Màng chống thấm 20kg', N'thung', 6, 1, GETDATE()),
    (23, N'SON-LOT-5L', N'Sơn lót kháng kiềm 5L', N'thung', 6, 1, GETDATE()),
    (24, N'XI-TRANG-40', N'Xi măng trắng bao 40kg', N'bao', 1, 1, GETDATE());

SET IDENTITY_INSERT Products OFF;

PRINT N'Thêm vị trí kho...';

SET IDENTITY_INSERT Locations ON;

INSERT INTO Locations (Id, WarehouseId, Code, Type, IsActive)
VALUES
    (1, 1, N'HCM-A1', N'Storage', 1),
    (2, 1, N'HCM-A2', N'Storage', 1),
    (3, 1, N'HCM-B1', N'Storage', 1),
    (4, 1, N'HCM-B2', N'Storage', 1),
    (5, 1, N'HCM-PICK-01', N'Picking', 1),
    (6, 1, N'HCM-STAGE-IN', N'Staging', 1),
    (7, 1, N'HCM-STAGE-OUT', N'Staging', 1),

    (8, 2, N'HN-A1', N'Storage', 1),
    (9, 2, N'HN-A2', N'Storage', 1),
    (10, 2, N'HN-B1', N'Storage', 1),
    (11, 2, N'HN-PICK-01', N'Picking', 1),
    (12, 2, N'HN-STAGE', N'Staging', 1),

    (13, 3, N'DN-A1', N'Storage', 1),
    (14, 3, N'DN-A2', N'Storage', 1),
    (15, 3, N'DN-PICK-01', N'Picking', 1),
    (16, 3, N'DN-STAGE', N'Staging', 1),

    (17, 4, N'BD-A1', N'Storage', 1),
    (18, 4, N'BD-A2', N'Storage', 1),
    (19, 4, N'BD-PICK-01', N'Picking', 1),
    (20, 4, N'BD-STAGE', N'Staging', 1);

SET IDENTITY_INSERT Locations OFF;

PRINT N'Thêm khách hàng...';

SET IDENTITY_INSERT Customers ON;

INSERT INTO Customers (Id, Code, Name, ContactInfo, Status)
VALUES
    (1, N'CUS-BDS-001', N'Công ty TNHH Xây dựng Bình Minh', N'Điện thoại: 028-3822-1001 | Email: muahang@binhminhcons.vn | Địa chỉ: Quận 7, TP.HCM', N'Active'),
    (2, N'CUS-NHA-002', N'Công ty Cổ phần Nhà Việt', N'Điện thoại: 024-3747-2002 | Email: procurement@nhaviet.vn | Địa chỉ: Cầu Giấy, Hà Nội', N'Active'),
    (3, N'CUS-DA-003', N'Công ty Đầu tư Đà Thành', N'Điện thoại: 0236-357-3003 | Email: vatlieu@datthanh.vn | Địa chỉ: Hải Châu, Đà Nẵng', N'Active'),
    (4, N'CUS-HP-004', N'Công ty Hoàng Phát', N'Điện thoại: 028-3999-4004 | Email: donhang@hoangphat.vn | Địa chỉ: Thủ Đức, TP.HCM', N'Active'),
    (5, N'CUS-KT-005', N'Tập đoàn Khang Thịnh', N'Điện thoại: 024-3555-5005 | Email: order@khangthinh.vn | Địa chỉ: Nam Từ Liêm, Hà Nội', N'Active'),
    (6, N'CUS-PQ-006', N'Công ty Phú Quý Interior', N'Điện thoại: 028-3777-6006 | Email: noithat@phuquy.vn | Địa chỉ: Bình Thạnh, TP.HCM', N'Inactive');

SET IDENTITY_INSERT Customers OFF;

PRINT N'Thêm nhà cung cấp...';

SET IDENTITY_INSERT Providers ON;

INSERT INTO Providers (Id, Code, Name, ContactInfo, Status)
VALUES
    (1, N'NCC-001', N'Tập đoàn Xi Măng Sao Mai', N'Điện thoại: 028-1111-2001 | Email: sales@saomai.vn | Địa chỉ: Quận 1, TP.HCM', N'Active'),
    (2, N'NCC-002', N'Công ty Thép Việt', N'Điện thoại: 028-2222-3002 | Email: vietsteel@vietsteel.vn | Địa chỉ: Bình Dương', N'Active'),
    (3, N'NCC-003', N'Gốm Sứ Đồng Tâm', N'Điện thoại: 072-3333-4003 | Email: lienhe@dongtam.vn | Địa chỉ: Long An', N'Active'),
    (4, N'NCC-004', N'Sơn Nippon', N'Điện thoại: 028-4444-5004 | Email: info@nippon.vn | Địa chỉ: Đồng Nai', N'Inactive');

SET IDENTITY_INSERT Providers OFF;

PRINT N'Thêm tồn kho...';

INSERT INTO Inventory (ProductId, WarehouseId, LocationId, Quantity)
VALUES
    (1, 1, 1, 1200), (2, 1, 1, 900), (24, 1, 2, 260),
    (4, 1, 3, 18000), (5, 1, 3, 4200), (6, 1, 3, 2600),
    (7, 1, 2, 750), (8, 1, 2, 620), (9, 1, 2, 4800), (10, 1, 4, 420),
    (11, 1, 4, 500), (12, 1, 4, 380), (13, 1, 4, 650), (14, 1, 5, 400),
    (15, 1, 5, 980), (16, 1, 5, 610), (17, 1, 5, 520), (18, 1, 5, 1200), (19, 1, 5, 700),
    (20, 1, 1, 360), (21, 1, 1, 250), (22, 1, 6, 180), (23, 1, 6, 320),

    (1, 2, 8, 650), (2, 2, 8, 420), (4, 2, 9, 8500), (7, 2, 9, 390),
    (11, 2, 10, 230), (12, 2, 10, 170), (15, 2, 11, 340), (16, 2, 11, 250),
    (20, 2, 8, 120), (23, 2, 12, 110),

    (1, 3, 13, 500), (4, 3, 13, 7200), (7, 3, 14, 310), (8, 3, 14, 260),
    (11, 3, 14, 180), (15, 3, 15, 280), (17, 3, 15, 210), (21, 3, 13, 95),

    (1, 4, 17, 420), (5, 4, 17, 1500), (7, 4, 18, 210), (13, 4, 18, 260),
    (16, 4, 19, 180), (20, 4, 17, 90), (22, 4, 20, 70);

PRINT N'Thêm đơn hàng bán...';

SET IDENTITY_INSERT SalesOrders ON;

INSERT INTO SalesOrders
    (Id, OrderNo, CustomerId, Status, CreatedBy, CreatedAt, OrderDate, RequiredDeliveryDate, Notes, ConfirmedBy, ConfirmedDate, CancelledBy, CancelledDate, CancellationReason)
VALUES
    (1, N'SO-2026-0001', 1, N'Draft', 4, GETDATE(), DATEADD(DAY, -1, GETDATE()), DATEADD(DAY, 3, GETDATE()), N'Đơn dự án nhà ở quận 9', NULL, NULL, NULL, NULL, NULL),
    (2, N'SO-2026-0002', 2, N'Confirmed', 4, GETDATE(), DATEADD(DAY, -4, GETDATE()), DATEADD(DAY, 2, GETDATE()), N'Đơn hàng công trình văn phòng', 2, DATEADD(DAY, -3, GETDATE()), NULL, NULL, NULL),
    (3, N'SO-2026-0003', 3, N'FulfillmentRequested', 4, GETDATE(), DATEADD(DAY, -7, GETDATE()), DATEADD(DAY, 1, GETDATE()), N'Cấp vật tư cho công trình khách sạn', 2, DATEADD(DAY, -6, GETDATE()), NULL, NULL, NULL),
    (4, N'SO-2026-0004', 6, N'Cancelled', 4, GETDATE(), DATEADD(DAY, -9, GETDATE()), DATEADD(DAY, -2, GETDATE()), N'Khách tạm hoãn dự án', 2, DATEADD(DAY, -8, GETDATE()), 4, DATEADD(DAY, -5, GETDATE()), N'Khách hàng dừng thi công trong quý này');

SET IDENTITY_INSERT SalesOrders OFF;

INSERT INTO SalesOrderItems (SalesOrderId, ProductId, Quantity, FulfilledQuantity)
VALUES
    (1, 1, 120, 0),
    (1, 4, 3000, 0),
    (1, 7, 150, 0),
    (2, 11, 80, 0),
    (2, 13, 100, 0),
    (2, 15, 120, 0),
    (3, 1, 200, 120),
    (3, 8, 100, 80),
    (3, 20, 40, 20),
    (4, 12, 60, 0),
    (4, 14, 50, 0);

PRINT N'Thêm yêu cầu kho...';

SET IDENTITY_INSERT Requests ON;

INSERT INTO Requests
    (Id, Type, Status, CreatedBy, ApprovedBy, ApprovedDate, RejectedBy, RejectedDate, RejectionReason,
     CompletedBy, CompletedDate, SalesOrderId, SourceWarehouseId, DestinationWarehouseId, ProviderId, ExpectedDate, Notes, Reason, CreatedAt)
VALUES
    (1, N'Inbound', N'Approved', 2, 2, DATEADD(DAY, -1, GETDATE()), NULL, NULL, NULL,
     NULL, NULL, NULL, NULL, 1, 1, DATEADD(DAY, 2, GETDATE()), N'Nhập lô xi măng tháng 3 từ nhà cung cấp miền Nam', NULL, DATEADD(DAY, -2, GETDATE())),

    (2, N'Outbound', N'Created', 2, NULL, NULL, NULL, NULL, NULL,
     NULL, NULL, 1, 1, NULL, NULL, DATEADD(DAY, 1, GETDATE()), N'Xuất hàng theo SO-2026-0001', N'Cấp cho công trình dân dụng', DATEADD(HOUR, -8, GETDATE())),

    (3, N'Outbound', N'InProgress', 2, 2, DATEADD(DAY, -1, GETDATE()), NULL, NULL, NULL,
     3, DATEADD(HOUR, -6, GETDATE()), 3, 1, NULL, NULL, DATEADD(HOUR, 12, GETDATE()), N'Xuất hàng theo SO-2026-0003', N'Ưu tiên giao trong ngày', DATEADD(DAY, -2, GETDATE())),

    (4, N'Transfer', N'Approved', 2, 5, DATEADD(HOUR, -10, GETDATE()), NULL, NULL, NULL,
     NULL, NULL, NULL, 1, 2, NULL, DATEADD(DAY, 2, GETDATE()), N'Điều chuyển thép cho kho Hà Nội', NULL, DATEADD(DAY, -1, GETDATE())),

    (5, N'Internal', N'Created', 2, NULL, NULL, NULL, NULL, NULL,
     NULL, NULL, NULL, 1, NULL, NULL, DATEADD(DAY, 1, GETDATE()), N'Chuyển gạch từ khu lưu trữ ra khu picking', N'Bổ sung khu soạn hàng', DATEADD(HOUR, -3, GETDATE())),

    (6, N'Inbound', N'Rejected', 5, NULL, NULL, 5, DATEADD(HOUR, -2, GETDATE()), N'Số lượng đề nghị vượt sức chứa khu staging',
     NULL, NULL, NULL, NULL, 2, 4, DATEADD(DAY, 3, GETDATE()), N'Đề nghị nhập hàng sơn từ kho trung tâm', NULL, DATEADD(HOUR, -12, GETDATE()));

SET IDENTITY_INSERT Requests OFF;

INSERT INTO RequestItems
    (RequestId, ProductId, Quantity, LocationId, SourceLocationId, DestinationLocationId, ReceivedQuantity, PickedQuantity)
VALUES
    (1, 1, 300, 6, NULL, NULL, NULL, NULL),
    (1, 24, 120, 6, NULL, NULL, NULL, NULL),
    (1, 3, 40, 6, NULL, NULL, NULL, NULL),

    (2, 1, 120, NULL, NULL, NULL, NULL, NULL),
    (2, 4, 3000, NULL, NULL, NULL, NULL, NULL),
    (2, 7, 150, NULL, NULL, NULL, NULL, NULL),

    (3, 1, 200, NULL, NULL, NULL, NULL, 120),
    (3, 8, 100, NULL, NULL, NULL, NULL, 80),
    (3, 20, 40, NULL, NULL, NULL, NULL, 20),

    (4, 7, 120, NULL, NULL, NULL, NULL, NULL),
    (4, 8, 80, NULL, NULL, NULL, NULL, NULL),

    (5, 4, 1500, NULL, 3, 5, NULL, NULL),
    (5, 5, 300, NULL, 3, 5, NULL, NULL),

    (6, 20, 100, 12, NULL, NULL, NULL, NULL),
    (6, 23, 60, 12, NULL, NULL, NULL, NULL);

COMMIT TRANSACTION;

DECLARE @Count INT;

PRINT N'';
PRINT N'=================================================';
PRINT N'ĐÃ TẠO DỮ LIỆU MẪU TIẾNG VIỆT CHO BuildMS THÀNH CÔNG';
PRINT N'=================================================';

SELECT @Count = COUNT(*) FROM Warehouses;
PRINT N'Số kho: ' + CAST(@Count AS NVARCHAR(20));

SELECT @Count = COUNT(*) FROM Users;
PRINT N'Số người dùng: ' + CAST(@Count AS NVARCHAR(20));

SELECT @Count = COUNT(*) FROM Categories;
PRINT N'Số danh mục: ' + CAST(@Count AS NVARCHAR(20));

SELECT @Count = COUNT(*) FROM Products;
PRINT N'Số sản phẩm: ' + CAST(@Count AS NVARCHAR(20));

SELECT @Count = COUNT(*) FROM Locations;
PRINT N'Số vị trí: ' + CAST(@Count AS NVARCHAR(20));

SELECT @Count = COUNT(*) FROM Inventory;
PRINT N'Số tồn kho: ' + CAST(@Count AS NVARCHAR(20));

SELECT @Count = COUNT(*) FROM Customers;
PRINT N'Số khách hàng: ' + CAST(@Count AS NVARCHAR(20));

SELECT @Count = COUNT(*) FROM Providers;
PRINT N'Số nhà cung cấp: ' + CAST(@Count AS NVARCHAR(20));

SELECT @Count = COUNT(*) FROM SalesOrders;
PRINT N'Số đơn bán: ' + CAST(@Count AS NVARCHAR(20));

SELECT @Count = COUNT(*) FROM Requests;
PRINT N'Số yêu cầu: ' + CAST(@Count AS NVARCHAR(20));
PRINT N'=================================================';

SELECT Id, Username, Name, Role, WarehouseId, Status
FROM Users
ORDER BY Id;

SELECT TOP 10 Id, Type, Status, CreatedBy, SourceWarehouseId, DestinationWarehouseId, SalesOrderId
FROM Requests
ORDER BY Id;
