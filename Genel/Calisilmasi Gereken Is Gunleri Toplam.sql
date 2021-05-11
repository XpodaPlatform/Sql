

create FUNCTION fn_CalisilanIsgunleriToplami
(
    @baslangictarihi Datetime,
    @bitistarihi Datetime
)
RETURNS FLOAT
AS
BEGIN
 
return (SELECT
   (DATEDIFF(dd, @baslangictarihi, @bitistarihi) + 1)
  -(DATEDIFF(wk, @baslangictarihi, @bitistarihi) * 2)
  -(CASE WHEN DATENAME(dw, @baslangictarihi) = 'Sunday' THEN 1 ELSE 0 END)
  -(CASE WHEN DATENAME(dw, @bitistarihi) = 'Saturday' THEN 1 ELSE 0 END)
)
  
 
END



