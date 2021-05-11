CREATE FUNCTION [dbo].[Ayrac] (@Kelime varchar(8000), @Sinirlayici char(1))
 
RETURNS @tempTable TABLE (items varchar(8000)) --max 8000 uzunluðunda karakter olabilir
 
AS
 
BEGIN
 
DECLARE @Sayi int
 
DECLARE @Ayrilmis varchar(8000)
 
SELECT @Sayi = 1
 
IF LEN(@Kelime)<1 OR @Kelime IS NULL RETURN
 
WHILE @Sayi != 0
 
BEGIN
 
SET @Sayi = CHARINDEX(@Sinirlayici, @Kelime)
 
IF @Sayi !=0
 
SET @Ayrilmis = LEFT(@Kelime, @Sayi-1 )
 
ELSE
 
SET @Ayrilmis = @Kelime
 
IF (LEN(@Ayrilmis) > 0)
 
INSERT INTO @tempTable (items) VALUES (@Ayrilmis)
 
SET @Kelime = RIGHT(@Kelime, LEN(@Kelime) - @Sayi)
 
IF LEN(@Kelime) = 0 BREAK
 
END
 
RETURN
 
END
GO


