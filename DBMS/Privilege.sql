USE dcBooking
GO

CREATE ROLE QUANTRI_ROLE

GRANT SELECT, INSERT, UPDATE, DELETE ON VAITRO TO QUANTRI_ROLE
GRANT SELECT, INSERT, UPDATE, DELETE ON TAIKHOAN TO QUANTRI_ROLE
GRANT SELECT, INSERT, UPDATE, DELETE ON NHASI TO QUANTRI_ROLE
GRANT SELECT, INSERT, UPDATE, DELETE ON NHANVIEN TO QUANTRI_ROLE
GRANT SELECT, INSERT, UPDATE, DELETE ON DICHVU TO QUANTRI_ROLE
GRANT SELECT, INSERT, UPDATE, DELETE ON THUOC TO QUANTRI_ROLE
GRANT SELECT, INSERT, UPDATE ON KHACHHANG TO QUANTRI_ROLE
GRANT SELECT ON QUANTRIVIEN TO QUANTRI_ROLE
GRANT SELECT ON LICHSUKHAM TO QUANTRI_ROLE
GRANT SELECT ON DICHVUSD TO QUANTRI_ROLE
GRANT SELECT ON DONTHUOC TO QUANTRI_ROLE
GRANT SELECT ON LICHHEN TO QUANTRI_ROLE
GRANT SELECT ON LICHLAMVIEC TO QUANTRI_ROLE
GO

CREATE ROLE NHASI_ROLE

GRANT SELECT, INSERT, UPDATE, DELETE ON DICHVUSD TO NHASI_ROLE
GRANT SELECT, INSERT, UPDATE, DELETE ON DONTHUOC TO NHASI_ROLE
GRANT SELECT, INSERT, UPDATE, DELETE ON LICHLAMVIEC TO NHASI_ROLE
GRANT SELECT, INSERT, UPDATE, DELETE ON LICHSUKHAM TO NHASI_ROLE
GRANT SELECT, UPDATE ON TAIKHOAN TO NHASI_ROLE
GRANT SELECT, UPDATE ON NHASI TO NHASI_ROLE
GRANT SELECT ON KHACHHANG TO NHASI_ROLE
GRANT SELECT ON DICHVU TO NHASI_ROLE
GRANT SELECT ON THUOC TO NHASI_ROLE
GRANT SELECT ON LICHHEN TO NHASI_ROLE
GO

CREATE ROLE NHANVIEN_ROLE

GRANT SELECT, INSERT, UPDATE, DELETE ON LICHHEN TO NHANVIEN_ROLE
GRANT SELECT, INSERT, UPDATE ON TAIKHOAN TO NHANVIEN_ROLE
GRANT SELECT, INSERT, UPDATE ON KHACHHANG TO NHANVIEN_ROLE
GRANT SELECT, UPDATE ON NHANVIEN TO NHANVIEN_ROLE
GRANT SELECT ON NHASI TO NHANVIEN_ROLE
GRANT SELECT ON LICHSUKHAM TO NHANVIEN_ROLE
GRANT SELECT ON DICHVU TO NHANVIEN_ROLE
GRANT SELECT ON THUOC TO NHANVIEN_ROLE
GRANT SELECT ON DICHVUSD TO NHANVIEN_ROLE
GRANT SELECT ON DONTHUOC TO NHANVIEN_ROLE
GO

CREATE ROLE KHACHHANG_ROLE

GRANT SELECT, INSERT, UPDATE, DELETE ON LICHHEN TO KHACHHANG_ROLE
GRANT SELECT, UPDATE ON TAIKHOAN TO KHACHHANG_ROLE
GRANT SELECT, UPDATE ON KHACHHANG TO KHACHHANG_ROLE
GRANT SELECT ON NHASI TO NHANVIEN_ROLE
GRANT SELECT ON LICHSUKHAM TO KHACHHANG_ROLE
GRANT SELECT ON DICHVU TO KHACHHANG_ROLE
GRANT SELECT ON THUOC TO KHACHHANG_ROLE
GRANT SELECT ON DICHVUSD TO KHACHHANG_ROLE
GRANT SELECT ON DONTHUOC TO KHACHHANG_ROLE
GO

EXEC sp_addlogin 'dcBooking_QT', '123', 'dcBooking'
CREATE USER [dcBooking_QT] FOR LOGIN [dcBooking_QT]
EXEC sp_addrolemember 'QUANTRI_ROLE', [dcBooking_QT]

EXEC sp_addlogin 'dcBooking_NS', '123', 'dcBooking'
CREATE USER [dcBooking_NS] FOR LOGIN [dcBooking_NS]
EXEC sp_addrolemember 'NHASI_ROLE', [dcBooking_NS]

EXEC sp_addlogin 'dcBooking_NV', '123', 'dcBooking'
CREATE USER [dcBooking_NV] FOR LOGIN [dcBooking_NV]
EXEC sp_addrolemember 'NHANVIEN_ROLE', [dcBooking_NV]

EXEC sp_addlogin 'dcBooking_KH', '123', 'dcBooking'
CREATE USER [dcBooking_KH] FOR LOGIN [dcBooking_KH]
EXEC sp_addrolemember 'KHACHHANG_ROLE', [dcBooking_KH]

GO