USE dcBooking
GO

CREATE PROC sp_xemLSK
    @MAKH INT
AS
BEGIN TRANSACTION
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
        IF NOT EXISTS (
            SELECT * FROM KHACHHANG
            WHERE MAKH = @MAKH
        )
        BEGIN
            PRINT N'Không tìm thấy khách hàng ' + CAST(@MAKH AS VARCHAR(10))
            ROLLBACK
            RETURN 0
        END
        
        IF NOT EXISTS (
            SELECT * FROM LICHSUKHAM
            WHERE MAKH = @MAKH
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
    @DVSD AS DVSD READONLY,
    @THSD AS THSD READONLY
AS
BEGIN TRANSACTION
    BEGIN TRY
        IF NOT EXISTS (
            SELECT * FROM KHACHHANG
            WHERE MAKH = @MAKH
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
        SELECT @MALSK, MATH, SOLUONG, GHICHU
        FROM @THSD

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