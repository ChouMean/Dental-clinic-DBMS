USE dcBooking
GO

-- Kiểm tra nếu khách hàng đã đặt lịch sẽ không thể đổi lịch làm việc
-- Kiểm tra tình trạng hoạt động của tk
-- CHECK KETTHUC > BATDAU (LICHLAMVIEC)

Đăng nhập
Đăng ký
Xem thuốc
Xem lịch sử khám

QTV - Thêm / xoá tài khoản
QTV - Sửa tài khoản
QTV - Xem thuốc
QTV - Tìm thuốc hết hạn
QTV - Xoá thuốc
QTV - Xoá thuốc hết hạn
QTV - Cập nhật thuốc
QTV 

Khách hàng - Đăng ký
Khách hàng - Đặt lịch hẹn
Khách hàng - Xem lịch hẹn
Khách hàng - Xem lịch sử khám




DROP PROC sp_DangNhap
GO



DECLARE @SDT PHONE = '0975463191'
DECLARE @MK MTEXT = '21126073'
DECLARE @MATK INT
DECLARE @MAVT INT

EXEC sp_DangNhap @SDT, @MK, @MATK OUTPUT, @MAVT OUTPUT
PRINT N'Mã tài khoản: ' + CAST (@MATK AS VARCHAR(10))
PRINT N'Vai trò: ' + CAST (@MAVT AS VARCHAR(10))