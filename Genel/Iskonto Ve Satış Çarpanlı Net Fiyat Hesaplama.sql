Create FUNCTION [dbo].[fn_NetFiyat_HEsaplam]
(
    @Miktar int,
	@LiteFiyat float,
	@IStTur int,
	@�skonto float,
	@Sat�sCarpan� float
--	@SatisTipi int
)
/*
@IStTur=1 Fiyat

@IStTur=0 Fiyat

*/

RETURNS decimal(8,2)
AS
BEGIN
declare @Sonuc decimal(8,2)
DEclare @BirimFiyat float

IF @IStTur=0
SET @BirimFiyat=@LiteFiyat-((@LiteFiyat*@�skonto)/100)
ELSE IF  @IStTur=1
BEGIN
SET @BirimFiyat=@LiteFiyat-@�skonto
END

Declare @Sat�sFiyat float
IF @Sat�sCarpan�=0 
SET @Sat�sFiyat=@BirimFiyat
ELSE 
BEGIN
SET @Sat�sFiyat=@BirimFiyat*@Sat�sCarpan�
end

IF @Miktar=0
SET @Sonuc=@Sat�sFiyat
else 
begin
SET @Sonuc=(SeLECT @Sat�sFiyat *@Miktar)
end
    RETURN @Sonuc
END


