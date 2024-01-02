USE dcBooking
GO

CREATE PROCEDURE sp_DangNhap
	@SDT PHONE READONLY,
	@MK MTEXT READONLY,
	@MATK INT OUTPUT,
	@MAVT INT OUTPUT
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
        IF NOT EXISTS (
            SELECT SDT = @SDT, MK = @MK
            FROM TAIKHOAN
        )
        BEGIN
            PRINT N'Sai mật khẩu'
            ROLLBACK TRANSACTION
            RETURN 0
        END
        IF NOT EXISTS (
            SELECT SDT = @SDT, MK = @MK
            FROM TAIKHOAN
            WHERE HOATDONG = 0
        )
        BEGIN
            PRINT N'Tài khoản đã bị khoá'
            ROLLBACK TRANSACTION
            RETURN 0
        END
        
        SELECT @MATK = MATK, @MAVT = MAVT
        FROM TAIKHOAN
        WHERE SDT = @SDT AND MK = @MK
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
    @SDT INT READONLY,
    @HOATDONG BIT READONLY
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