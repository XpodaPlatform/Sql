ALTER FUNCTION [dbo].[fn_CokluSecimKullaniciIsimleri]
(
    @UserIDs NVARCHAR(1000)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @Sonuc NVARCHAR(MAX)=''

	SELECT @Sonuc += UserFullName+', ' FROM XPODA_CLIENT_USERS WITH(NOLOCK) WHERE UserID IN (SELECT items FROM dbo.Ayrac(@UserIDs,','))

	IF CHARINDEX(',',@Sonuc) != 0
		SET @Sonuc = LEFT (@Sonuc,LEN(@Sonuc)-1)

    RETURN ISNULL(@Sonuc,'')

END