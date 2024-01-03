USE dcBooking
GO

CREATE PROCEDURE sp_truyvanThuoc
AS
BEGIN TRANSACTION
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL READ COMMITTED
        SELECT * FROM THUOC
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

CREATE PROCEDURE sp_suaThuoc
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
        IF @NGAYHETHAN <= GETDATE()
        BEGIN
            PRINT N'Không thể thêm thuốc hết hạn'
            ROLLBACK TRANSACTION
            RETURN 0
        END
        IF @SLKHO < 0
        BEGIN
            PRINT N'Không thể thêm số lượng ít hơn 0'
            ROLLBACK TRANSACTION
            RETURN 0
        END
        UPDATE THUOC WITH (XLOCK)
        SET
            TENTHUOC = @TENTHUOC,
            DONVITINH = @DONVITINH,
            CHIDINH = @CHIDINH,
            NGAYHETHAN = @NGAYHETHAN,
            SLKHO = @SLKHO,
            DONGIA = @DONGIA
        WHERE MATH = @MATH
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