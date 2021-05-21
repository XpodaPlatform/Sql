Create FUNCTION [dbo].[fn_NetFiyat_Hesaplama]
(
    @Miktar int,
	@LiteFiyat float,
	@IStTur int,
	@iskonto float,
	@SatisCarpani float
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
SET @BirimFiyat=@LiteFiyat-((@LiteFiyat*@iskonto)/100)
ELSE IF  @IStTur=1
BEGIN
SET @BirimFiyat=@LiteFiyat-@iskonto
END

Declare @SatisFiyat float
IF @SatisCarpani=0 
SET @SatisFiyat=@BirimFiyat
ELSE 
BEGIN
SET @SatisFiyat=@BirimFiyat*@SatisCarpan�
end

IF @Miktar=0
SET @Sonuc=@SatisFiyat
else 
begin
SET @Sonuc=(SeLECT @SatisFiyat *@Miktar)
end
    RETURN @Sonuc
END


