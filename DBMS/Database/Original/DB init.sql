USE dcBooking
GO

INSERT INTO VAITRO (MAVT, TENVT)
VALUES
	('QT', N'Quản trị viên'),
	('NS', N'Nha sĩ'),
	('NV', N'Nhân viên'),
	('KH', N'Khách hàng')
GO

INSERT INTO TAIKHOAN (MATK, SDT, MK, MAVT)
VALUES
	('QT000000', '0338540248', '21126030', 'QT'),
	('NS000000', '0916702097', '21126019', 'NS'),
	('NS000001', '0916702098', '19125089', 'NS'),
	('NS000002', '0916702099', '20125124', 'NS'),
	('NV000000', '0931858601', '21126071', 'NV'),
	('KH000000', '0975463191', '21126073', 'KH'),
	('KH000001', '0975463192', '21125006', 'KH'),
	('KH000002', '0975463193', '21125007', 'KH'),
	('KH000003', '0975463194', '21125011', 'KH'),
	('KH000004', '0975463195', '21125013', 'KH'),
	('KH000005', '0975463196', '21125017', 'KH'),
	('KH000006', '0975463197', '21125018', 'KH'),
	('KH000007', '0975463198', '21125019', 'KH'),
	('KH000008', '0975463199', '21125020', 'KH'),
	('KH000009', '0975463200', '21125027', 'KH')
GO

INSERT INTO QUANTRIVIEN (MATK, HOTEN)
VALUES
	('QT000000', N'Nguyễn Trần Châu Minh')
GO

INSERT INTO NHASI (MATK, HOTEN)
VALUES
	('NS000000', N'Nguyễn Thái Huyền'),
	('NS000001', N'Phạm Thị Ngọc Hà'),
	('NS000002', N'Nguyễn Minh Uyên')
GO

INSERT INTO NHANVIEN (MATK, HOTEN)
VALUES
	('NV000000', N'Thái Hoàng Bảo Khanh')
GO

INSERT INTO KHACHHANG (MATK, HOTEN, NGAYSINH, DIACHI)
VALUES
	('KH000000', N'Phạm Nguyễn Gia Khiêm', '2003-01-01', N'TP.HCM'),
	('KH000001', N'Hồ Khánh Duy', '2003-01-02', N'TP.HCM'),
	('KH000002', N'Phạm Vũ Minh Giang', '2003-01-03', N'TP.HCM'),
	('KH000003', N'Nguyễn Vũ Đăng Huy', '2003-01-04', N'TP.HCM'),
	('KH000004', N'Võ Hoàng Phúc Khang', '2003-01-05', N'TP.HCM'),
	('KH000005', N'Nguyễn Thanh Thảo Ly', '2003-01-06', N'TP.HCM'),
	('KH000006', N'Nguyễn Hoàng Minh', '2003-01-07', N'TP.HCM'),
	('KH000007', N'Từ Cảnh Minh', '2003-01-08', N'TP.HCM'),
	('KH000008', N'Đặng Trung Nghĩa', '2003-01-09', N'TP.HCM'),
	('KH000009', N'Hoàng Nghĩa Việt', '2003-01-10', N'TP.HCM')
GO

INSERT INTO DICHVU (TENDV, PHIKHAM)
VALUES
	(N'Khám bệnh', 100000),
	(N'Chụp X-Quang', 100000),
	(N'Trám răng', 100000),
	(N'Cạo vôi', 100000)
GO

INSERT INTO THUOC (TENTHUOC, DONVITINH, CHIDINH, NGAYHETHAN, SLKHO, DONGIA)
VALUES
	(N'0', N'Viên', N'Uống', '2023-12-31', 100, 10),
	(N'1', N'Viên', N'Uống', '2023-12-31', 100, 10),
	(N'2', N'Viên', N'Uống', '2023-12-31', 100, 10)
GO

INSERT INTO LICHSUKHAM (MAKH, MANS, THOIGIAN, THANHTOAN)
VALUES
	(0, 0, '2023-11-11 13:23:11', 0)
GO

INSERT INTO DICHVUSD (MALSK, MADV)
VALUES
	(0, 0),
	(0, 1),
	(0, 2)
GO

INSERT INTO DONTHUOC (MALSK, MATH, SOLUONG)
VALUES
	(0, 0, 10),
	(0, 1, 5),
	(0, 2, 1)
GO

/*
INSERT INTO LICHHEN
VALUES
	('', '', '', '')
GO

INSERT INTO LICHRANH
VALUES
	('', '', '')
GO
*/
USE master
GO