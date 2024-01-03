USE dcBooking
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
        WAITFOR DELAY '00:00:10'
		
		IF @NGAYHETHAN <= GETDATE()
        BEGIN
            PRINT N'Không thể thêm thuốc hết hạn'
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

CREATE PROCEDURE sp_xuatHoaDon
    @MAKH INT,
    @MALSK INT
AS
BEGIN TRANSACTION
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL READ COMMITTED
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

        SELECT DV.TENDV AS 'Tên dv', DV.PHIKHAM AS 'Phí dv'
        FROM DICHVUSD DVSD, DICHVU DV
        WHERE DVSD.MALSK = @MALSK AND DV.MADV = DVSD.MADV
        
        DECLARE @TONG FLOAT = (
            SELECT SUM(DV.PHIKHAM)
            FROM DICHVUSD DVSD, DICHVU DV
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