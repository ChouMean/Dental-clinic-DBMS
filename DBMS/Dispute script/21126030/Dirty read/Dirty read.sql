USE dcBooking
GO

CREATE PROC sp_xemLSK
    @MAKH INT READONLY
AS
BEGIN TRANSACTION
    BEGIN TRY
        IF NOT EXISTS (
            SELECT MAKH = @MAKH
            FROM KHACHHANG
        )
        BEGIN
            PRINT N'Không tìm thấy khách hàng ' + CAST (@MAKH AS VARCHAR(10))
            ROLLBACK
            RETURN 0
        END
        
        IF NOT EXISTS (
            SELECT MAKH = @MAKH
            FROM LICHSUKHAM
        )
        BEGIN
            PRINT N'Không thấy lịch sử khám của ' + CAST (@MAKH AS VARCHAR(10))
            ROLLBACK
            RETURN 0
        END

        SELECT *
        FROM LICHSUKHAM
        WHERE MAKH = @MAKH
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
    @MAKH INT READONLY,
    @MANS INT READONLY,
    @GHICHU LTEXT READONLY,
    @DVSD DVSD READONLY,
    @THSD THSD READONLY
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
        
        DECLARE @MALSK INT
        SELECT @MALSK = MALSK
        FROM LICHSUKHAM
        WHERE MAKH = @MAKH AND MANS = @MANS
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