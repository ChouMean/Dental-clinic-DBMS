﻿USE dcBooking
GO

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
            FROM NHASI NS, TAIKHOAN TK WITH (XLOCK)
            WHERE NS.MANS = @MANS AND NS.MATK = TK.MATK AND TK.HOATDONG = 1
        )
        BEGIN
            PRINT N'Không tìm thấy nha sĩ'
            ROLLBACK TRANSACTION
            RETURN 0
        END
        IF NOT EXISTS (
            SELECT *
            FROM LICHLAMVIEC LLV WITH (XLOCK)
            WHERE LLV.MANS = @MANS AND LLV.BATDAU <= @THOIGIAN AND LLV.KETTHUC >= DATEADD(MINUTE, 15, @THOIGIAN)
        )
        BEGIN
            PRINT N'Không có lịch Làm việc phù hợp'
            ROLLBACK TRANSACTION
            RETURN 0
        END
        IF EXISTS (
            SELECT *
            FROM LICHHEN LH WITH (XLOCK)
            WHERE LH.MANS = @MANS AND LH.THOIGIAN > DATEADD(MINUTE, -15, @THOIGIAN) AND LH.THOIGIAN < DATEADD(MINUTE, 15, @THOIGIAN)
        )
        BEGIN
            PRINT N'Lịch hẹn đã được đặt'
            ROLLBACK TRANSACTION
            RETURN 0
        END
        WAITFOR DELAY '00:00:10'

        INSERT INTO LICHHEN (MAKH, MANS, THOIGIAN)
        VALUES (@MAKH, @MANS, @THOIGIAN)
        
        PRINT N'Đã thêm lịch hẹn thành công'
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi hệ thống'
        ROLLBACK TRANSACTION
        RETURN 0
    END CATCH
COMMIT TRANSACTION
RETURN 1
GO