USE dcBooking
GO

INSERT INTO VAITRO (MAVT, TENVT)
VALUES
	('QT', N'Quản trị viên'),
	('NS', N'Nha sĩ'),
	('NV', N'Nhân viên'),
	('KH', N'Khách hàng')
GO

INSERT INTO TAIKHOAN (SDT, MK, MAVT)
VALUES
	('0338540248', '21126030', 'QT'),
	('0916702097', '21126019', 'NS'),
	('0931858601', '21126071', 'NV'),
	('0975463191', '21126073', 'KH'),
	('0975463192', '21126074', 'KH')
GO

INSERT INTO QUANTRIVIEN (MATK, HOTEN)
VALUES
	(1, N'Nguyễn Trần Châu Minh')
GO

INSERT INTO NHASI (MATK, HOTEN)
VALUES
	(2, N'Nguyễn Thái Huyền')
GO

INSERT INTO NHANVIEN (MATK, HOTEN)
VALUES
	(3, N'Thái Hoàng Bảo Khanh')
GO

INSERT INTO KHACHHANG (MATK, HOTEN, NGAYSINH, DIACHI)
VALUES
	(4, N'Phạm Nguyễn Gia Khiêm', '2003-01-01', N'TP.HCM'),
	(5, N'Đinh Hồ Bảo Châu', '2008-12-07', N'Đà Lạt')
GO

INSERT INTO DICHVU (TENDV, PHIKHAM)
VALUES
	(N'Khám bệnh', 80000),
	(N'Chụp X-Quang', 100000),
	(N'Trám răng', 200000),
	(N'Cạo vôi', 50000)
GO

INSERT INTO THUOC (TENTHUOC, DONVITINH, CHIDINH, NGAYHETHAN, SLKHO, DONGIA)
VALUES
	(N'0', N'Viên', N'Uống', '2023-12-31', 100, 10),
	(N'1', N'Tuýp', N'Bôi', '2023-12-31', 100, 10),
	(N'2', N'Viên', N'Uống', '2023-12-31', 100, 10)
GO

INSERT INTO LICHSUKHAM (MAKH, MANS, GHICHU)
VALUES
	(1, 1, N'Bất thường'),
	(2, 1, N'Khoẻ')
GO

INSERT INTO DICHVUSD (MALSK, MADV)
VALUES
	(1, 1),
	(1, 2),
	(1, 3),
	(1, 4),
	(2, 1),
	(2, 2),
	(2, 3),
	(2, 4)
GO

INSERT INTO DONTHUOC (MALSK, MATH, SOLUONG, GHICHU)
VALUES
	(1, 1, 1, N''),
	(1, 2, 1, N''),
	(1, 3, 1, N''),
	(2, 1, 1, N''),
	(2, 2, 1, N''),
	(2, 3, 1, N'')
GO