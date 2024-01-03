USE dcBooking
GO

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