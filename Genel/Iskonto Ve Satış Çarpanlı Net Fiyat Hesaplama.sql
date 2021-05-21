Create FUNCTION [dbo].[fn_NetFiyat_HEsaplam]
(
    @Miktar int,
	@LiteFiyat float,
	@IStTur int,
	@Ýskonto float,
	@SatýsCarpaný float
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
SET @BirimFiyat=@LiteFiyat-((@LiteFiyat*@Ýskonto)/100)
ELSE IF  @IStTur=1
BEGIN
SET @BirimFiyat=@LiteFiyat-@Ýskonto
END

Declare @SatýsFiyat float
IF @SatýsCarpaný=0 
SET @SatýsFiyat=@BirimFiyat
ELSE 
BEGIN
SET @SatýsFiyat=@BirimFiyat*@SatýsCarpaný
end

IF @Miktar=0
SET @Sonuc=@SatýsFiyat
else 
begin
SET @Sonuc=(SeLECT @SatýsFiyat *@Miktar)
end
    RETURN @Sonuc
END


