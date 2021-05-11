ALTER FUNCTION [dbo].[fn_str_ok] (@StrValue as nvarchar(50), @InpStr as nvarchar(MAX))
RETURNS bit
BEGIN
IF @InpStr   IS NOT NULL BEGIN SET @InpStr   = Replace(@InpStr,'''','') END
IF @StrValue IS NOT NULL BEGIN SET @StrValue = Replace(@StrValue,'''','') END
RETURN ( CASE
WHEN (@InpStr='') THEN 1
WHEN (@InpStr IS NULL) THEN 1
WHEN (@StrValue <> '') AND
(0<>CHARINDEX(','+LTRIM(@StrValue)+',',+','+@InpStr+',')) THEN 1
ELSE 0
END
)
END