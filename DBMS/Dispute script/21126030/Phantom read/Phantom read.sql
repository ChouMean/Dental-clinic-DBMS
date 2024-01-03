﻿USE dcBooking
GO

CREATE PROCEDURE sp_xemThuoc
AS
BEGIN TRANSACTION
    BEGIN TRY
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

CREATE PROCEDURE sp_xoaThuoc
    @MATH INT READONLY
AS
BEGIN TRANSACTION
    BEGIN TRY
        DELETE FROM THUOC
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