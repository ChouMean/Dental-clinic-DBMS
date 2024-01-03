USE dcBooking
GO

CREATE PROCEDURE sp_xuatHoaDon
    @MAKH INT READONLY,
    @MALSK INT READONLY
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
    @MATH INT READONLY,
    @TENTHUOC STEXT,
    @DONVITINH XSTEXT,
    @CHIDINH STEXT,
    @NGAYHETHAN DATE READONLY,
    @SLKHO INT READONLY,
    @DONGIA FLOAT READONLY
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