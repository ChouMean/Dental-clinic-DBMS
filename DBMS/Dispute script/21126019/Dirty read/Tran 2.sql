USE dcBooking
GO

DECLARE @MAKH INT = 1
DECLARE @HD_chuaTT INT = (
    SELECT MALSK
    FROM LICHSUKHAM
    WHERE MAKH = @MAKH AND THANHTOAN = 0
)

EXEC sp_xuatHoaDon @MAKH, @HD_chuaTT
GO