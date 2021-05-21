CREATE FUNCTION [dbo].[fn_NK_BARKOD]()				
RETURNS nvarchar(500)
AS
BEGIN
Declare @SNumara nvarchar(13)

SELECT TOP 1
	@SNumara = MAX(bar_kodu)  
FROM [MikroDB_V16_2020_NIKEL].[dbo].[BARKOD_TANIMLARI] WITH (NOLOCK) 
WHERE LEN(bar_kodu)=13 AND  
		ISNUMERIC(bar_kodu)=1 AND
		bar_kodu LIKE '9%'

IF ISNULL(@SNumara,N'')=N'' SET @SNumara='9300000000000'

SET @SNumara=LEFT(@SNumara,12)
SET @SNumara=CAST(@SNumara AS BIGINT)+1

SET @SNumara=dbo.fn_GetEAN(@SNumara)

RETURN @SNumara
END