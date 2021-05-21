CREATE FUNCTION [dbo].[fn_DakikadanSaateCevirme] (@Second INT)
RETURNS FLOAT AS
BEGIN
DECLARE @Result FLOAT



select @Result=( CAST(@Second AS FLOAT)/CAST(3600 AS FLOAT))



Return @Result
END
