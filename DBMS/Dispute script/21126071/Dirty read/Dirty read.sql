USE dcBooking
GO

CREATE PROCEDURE sp_suaLichLamViec
    @MANS INT,
    @BATDAU DATETIME,
    @KETTHUC DATETIME
AS
BEGIN TRANSACTION
    BEGIN TRY
        IF EXISTS (
            SELECT * FROM LICHHEN
            WHERE MANS = @MANS AND THOIGIAN >= @BATDAU AND THOIGIAN <= @KETTHUC
        )
        BEGIN
            PRINT N'Lịch đã được hẹn, không thể thay đổi'
            WAITFOR DELAY '00:00:10'
            ROLLBACK TRANSACTION
            RETURN 0
        END

        
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi hệ thống'
        ROLLBACK TRANSACTION
        RETURN 0
    END CATCH
COMMIT TRANSACTION
RETURN 1
GO

CREATE PROCEDURE sp_xemLichLamViec
    @MANS INT
AS
BEGIN TRANSACTION
    BEGIN TRY
        IF NOT EXISTS (
            
        )
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi hệ thống'
        ROLLBACK TRANSACTION
        RETURN 0
    END CATCH
COMMIT TRANSACTION
RETURN 1
GO