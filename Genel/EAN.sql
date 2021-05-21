USE [EMS_OCTOPOD]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetEAN]    Script Date: 21.05.2021 12:43:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[fn_GetEAN]            /** V16 **/
(
    @EAN VARCHAR(12)
)
RETURNS VARCHAR(13)
AS
BEGIN

IF LEN(@EAN)<>12
    RETURN N''

    DECLARE    @Index TINYINT,
        @Multiplier TINYINT,
        @Sum TINYINT

    SELECT    @Index = LEN(@EAN),
        @Multiplier = 3,
        @Sum = 0

    WHILE @Index > 0
        SELECT    @Sum = @Sum + @Multiplier * CAST(SUBSTRING(@EAN, @Index, 1) AS TINYINT),
            @Multiplier = 4 - @Multiplier,
            @Index = @Index - 1

    RETURN    CASE @Sum % 10
            WHEN 0 THEN @EAN + '0'
            ELSE @EAN + CAST(10 - @Sum % 10 AS CHAR(1))
        END
END
