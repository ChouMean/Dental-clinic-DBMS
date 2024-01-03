﻿USE dcBooking
GO

-- 21126019
-- Dirty read
CREATE PROCEDURE sp_xuatHoaDon
    @MAKH INT,
    @MALSK INT
AS
BEGIN TRANSACTION
    BEGIN TRY
        IF NOT EXISTS (
            SELECT * FROM KHACHHANG
            WHERE MAKH = @MAKH
        )
        BEGIN
            PRINT N'Không tìm thấy khách hàng'
            ROLLBACK TRANSACTION
            RETURN 0
        END
        IF NOT EXISTS (
            SELECT * FROM LICHSUKHAM
            WHERE MAKH = @MAKH AND MALSK = @MALSK
        )
        BEGIN
            PRINT N'Không tìm thấy lịch sử khám phù hợp'
            ROLLBACK TRANSACTION
            RETURN 0
        END
        
        UPDATE LICHSUKHAM
        SET THANHTOAN = 1
        WHERE MAKH = @MAKH AND MALSK = @MALSK

        SELECT DV.TENDICHVU AS 'Tên dv', DV.PHIKHAM AS 'Phí dv'
        FROM DICVUSD DVSD, DICHVU DV
        WHERE DVSD.MALSK = @MALSK AND DV.MADV = DVSD.MADV
        
        DECLARE @TONG FLOAT = (
            SELECT SUM(DV.PHIKHAM)
            FROM DICVUSD DVSD, DICHVU DV
            WHERE DVSD.MALSK = @MALSK AND DV.MADV = DVSD.MADV
        )
        
        SELECT TH.TENTHUOC AS 'Tên thuốc', DT.SOLUONG AS 'Số lượng'
        FROM DONTHUOC DT, THUOC TH
        WHERE DT.MALSK = @MALSK AND TH.MATH = DT.MATH

        SET @TONG += (
            SELECT SUM(TH.DONGIA * DT.SOLUONG)
            FROM DONTHUOC DT, THUOC TH
            WHERE DT.MALSK = @MALSK AND TH.MATH = DT.MATH
        )
        PRINT N'Tổng chi phí: ' + CAST(@TONG AS VARCHAR(10))
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi hệ thống'
        ROLLBACK TRANSACTION
        RETURN 0
    END CATCH
COMMIT TRANSACTION
RETURN 1
GO

CREATE PROCEDURE sp_doiTTThuoc
    @MATH INT,
    @TENTHUOC AS STEXT,
    @DONVITINH AS XSTEXT,
    @CHIDINH AS STEXT,
    @NGAYHETHAN DATE,
    @SLKHO INT,
    @DONGIA FLOAT
AS
BEGIN TRANSACTION
    BEGIN TRY
        UPDATE THUOC WITH (XLOCK)
        SET
            TENTHUOC = @TENTHUOC,
            DONVITINH = @DONVITINH,
            CHIDINH = @CHIDINH,
            NGAYHETHAN = @NGAYHETHAN,
            SLKHO = @SLKHO,
            DONGIA = @DONGIA
        WHERE MATH = @MATH
        IF @NGAYHETHAN <= GETDATE()
        BEGIN
            PRINT N'Không thể thêm thuốc hết hạn'
            WAITFOR DELAY '00:00:10'
            ROLLBACK TRANSACTION
            RETURN 0
        END
        PRINT N'Đổi thông tin thuốc thành công'
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi hệ thống'
        ROLLBACK TRANSACTION
        RETURN 0
    END CATCH
COMMIT TRANSACTION
RETURN 1
GO

-- Lost update
CREATE PROCEDURE sp_datLichHen
    @MAKH INT,
    @MANS INT,
    @THOIGIAN DATETIME
AS
BEGIN TRANSACTION
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL READ COMMITTED
        IF NOT EXISTS (
            SELECT *
            FROM NHASI NS, TAIKHOAN TK
            WHERE NS.MANS = @MANS AND NS.MATK = TK.MATK AND TK.HOATDONG = 1
        )
        BEGIN
            PRINT N'Không tìm thấy nha sĩ'
            ROLLBACK TRANSACTION
            RETURN 0
        END
        IF NOT EXISTS (
            SELECT *
            FROM LICHLAMVIEC LLV
            WHERE LLV.MANS = @MANS AND LLV.BATDAU <= @THOIGIAN AND LLV.KETTHUC >= @THOIGIAN + '00:00:15'
        )
        BEGIN
            PRINT N'Không có lịch Làm việc phù hợp'
            ROLLBACK TRANSACTION
            RETURN 0
        END
        IF EXISTS (
            SELECT *
            FROM LICHHEN LH
            WHERE LH.MANS = @MANS AND LH.THOIGIAN > @THOIGIAN - '00:00:15' AND LH.THOIGIAN < @THOIGIAN + '00:00:15'
        )
        BEGIN
            PRINT N'Lịch hẹn đã được đặt'
            ROLLBACK TRANSACTION
            RETURN 0
        END

        INSERT INTO LICHHEN (MAKH, MANS, THOIGIAN)
        VALUES (@MAKH, @MANS, THOIGIAN)
        
        PRINT N'Đã thêm lịch hẹn thành công'
        WAITFOR DELAY '00:00:10'
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi hệ thống'
        ROLLBACK TRANSACTION
        RETURN 0
    END CATCH
COMMIT TRANSACTION
RETURN 1
GO

-- 21126030
-- Phantom read
CREATE PROCEDURE sp_xemThuoc
AS
BEGIN TRANSACTION
    BEGIN TRY
        SELECT * FROM THUOC WITH (READCOMMITTED)
        WAITFOR DELAY '00:00:10'
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi hệ thống'
        ROLLBACK TRANSACTION
        RETURN 0
    END CATCH
COMMIT TRANSACTION
RETURN 1
GO

CREATE PROCEDURE sp_xoaThuoc
    @MATH INT
AS
BEGIN TRANSACTION
    BEGIN TRY
        DELETE FROM THUOC WITH (XLOCK)
        WHERE MATH = @MATH
        WAITFOR DELAY '00:00:10'
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi hệ thống'
        ROLLBACK TRANSACTION
        RETURN 0
    END CATCH
COMMIT TRANSACTION
RETURN 1
GO

-- Unrepeatable read
CREATE PROCEDURE sp_DangNhap
	@SDT AS PHONE,
	@MK AS MTEXT,
	@MATK INT OUTPUT,
	@MAVT INT OUTPUT
AS
BEGIN TRANSACTION
    BEGIN TRY
        SET TRAN ISOLATION LEVEL REPEATABLE READ
        IF NOT EXISTS (
            SELECT * FROM TAIKHOAN
            WHERE SDT = @SDT
        )
        BEGIN
            PRINT N'Không tìm thấy tài khoản'
            ROLLBACK TRANSACTION
            RETURN 0
        END
        IF NOT EXISTS (
            SELECT * FROM TAIKHOAN
            WHERE SDT = @SDT AND MK = @MK
        )
        BEGIN
            PRINT N'Sai mật khẩu'
            ROLLBACK TRANSACTION
            RETURN 0
        END
        IF EXISTS (
            SELECT * FROM TAIKHOAN
            WHERE SDT = @SDT AND MK = @MK AND HOATDONG = 0
        )
        BEGIN
            PRINT N'Tài khoản đã bị khoá'
            ROLLBACK TRANSACTION
            RETURN 0
        END
        WAITFOR DELAY '00:00:10'
        
        SELECT @MATK = MATK, @MAVT = MAVT
        FROM TAIKHOAN
        WHERE SDT = @SDT AND MK = @MK AND HOATDONG = 1
        PRINT N'Đăng nhập thành công'
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi hệ thống'
        ROLLBACK TRANSACTION
        RETURN 0
    END CATCH
COMMIT TRANSACTION
RETURN 1
GO

CREATE PROCEDURE sp_doiTrangThai
    @SDT INT,
    @HOATDONG BIT
AS
BEGIN TRANSACTION
    BEGIN TRY
        IF NOT EXISTS (
            SELECT * FROM TAIKHOAN
            WHERE SDT = @SDT
        )
        BEGIN
            PRINT N'Không tìm thấy tài khoản'
            ROLLBACK TRANSACTION
            RETURN 0
        END
        
        UPDATE TAIKHOAN
        SET HOATDONG = @HOATDONG
        WHERE SDT = @SDT
        PRINT N'Thay đổi trạng thái tài khoản thành công'
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi hệ thống'
        ROLLBACK TRANSACTION
        RETURN 0
    END CATCH
COMMIT TRANSACTION
RETURN 1
GO

-- 21126071
-- 

-- Phantom read
CREATE TYPE DVSD AS TABLE (
    MADV INT NOT NULL UNIQUE
)
GO
CREATE TYPE THSD AS TABLE (
    MATH INT NOT NULL UNIQUE,
    SOLUONG INT NOT NULL,
    GHICHU LTEXT
)
GO

CREATE PROC sp_xemLSK
    @MAKH INT
AS
BEGIN TRANSACTION
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
        IF NOT EXISTS (
            SELECT MAKH = @MAKH
            FROM KHACHHANG
        )
        BEGIN
            PRINT N'Không tìm thấy khách hàng ' + CAST(@MAKH AS VARCHAR(10))
            ROLLBACK
            RETURN 0
        END
        
        IF NOT EXISTS (
            SELECT MAKH = @MAKH
            FROM LICHSUKHAM
        )
        BEGIN
            PRINT N'Không thấy lịch sử khám của ' + CAST(@MAKH AS VARCHAR(10))
            ROLLBACK
            RETURN 0
        END
        SELECT *
        FROM LICHSUKHAM
        WHERE MAKH = @MAKH
        WAITFOR DELAY '00:00:10'
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi hệ thống'
        ROLLBACK TRANSACTION
        RETURN 0
    END CATCH
COMMIT TRANSACTION
RETURN 1
GO

CREATE PROCEDURE sp_themLSK
    @MAKH INT,
    @MANS INT,
    @GHICHU AS LTEXT,
    @DVSD AS DVSD,
    @THSD AS THSD
AS
BEGIN TRANSACTION
    BEGIN TRY
        IF NOT EXISTS (
            SELECT SDT = @SDT
            FROM TAIKHOAN
        )
        BEGIN
            PRINT N'Không tìm thấy tài khoản'
            ROLLBACK TRANSACTION
            RETURN 0
        END
        INSERT INTO LICHSUKHAM (MAKH, MANS, GHICHU)
        VALUES (@MAKH, @MANS, @GHICHU)
        
        DECLARE @MALSK INT = (
            SELECT MALSK
            FROM LICHSUKHAM
            WHERE MAKH = @MAKH AND MANS = @MANS
        )

        INSERT INTO DICHVUSU (MALSK, MADV)
        SELECT @MALSK, MADV
        FROM @DVSD

        INSERT INTO DONTHUOC (MALSK, MATH, SOLUONG, GHICHU)
        SELECT @MALSK, MADV, SOLUONG, GHICHU
        FROM @DVSD

        PRINT N'Thêm lịch sử khám thành công'
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi hệ thống'
        ROLLBACK TRANSACTION
        RETURN 0
    END CATCH
COMMIT TRANSACTION
RETURN 1
GO