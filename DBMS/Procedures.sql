CREATE DATABASE dcBooking
GO
USE dcBooking
GO

-- Kiểm tra thông tin ngày sinh khách hàng
-- Kiểm tra nếu khách hàng đã đặt lịch sẽ không thể đổi lịch làm việc

CREATE PROC sp_DangNhap
	@SDT PHONE,
	@MK MTEXT,
	@MATK INT OUTPUT,
	@MAVT INT OUTPUT
AS
BEGIN
	SET @MATK = NULL
	SET @MAVT = NULL

	IF NOT EXISTS (
		SELECT SDT = @SDT
		FROM TAIKHOAN
	)
		BEGIN
			PRINT N'Không tìm thấy tài khoản'
			RETURN 0
		END
	ELSE
	IF NOT EXISTS (
		SELECT SDT = @SDT, MK = @MK
		FROM TAIKHOAN
	)
		BEGIN
			PRINT N'Sai mật khẩu'
			RETURN 0
		END
    
	SELECT @MATK = MATK, @MAVT = MAVT
	FROM TAIKHOAN
    WHERE SDT = @SDT AND MK = @MK

    PRINT N'Đăng nhập thành công'
    RETURN 1
END
GO

DECLARE @SDT PHONE = '0338540248'
DECLARE @MK MTEXT = '21126030'
DECLARE @MATK INT
DECLARE @MAVT INT

EXEC sp_DangNhap @SDT, @MK, @MATK OUTPUT, @MAVT OUTPUT
PRINT N'Mã tài khoản: ' + CAST(@MATK AS INT)
PRINT N'Vai trò: ' + CAST(@MAVT AS INT)