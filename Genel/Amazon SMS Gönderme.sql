ALTER PROCEDURE [dbo].[SendtoSMS]
    @PhoneNumber nvarchar(50),
	@UserName nvarchar(50),
	@CountryFl int
AS
	
 DECLARE @CMDSQL VARCHAR(1000),@SmsContent nvarchar(500)

	IF @CountryFl=1  /*usa*/
	BEGIN


 set @SmsContent = 'Hi! Your username and password have been added to Xpoda application.You can access the application from the links below. UserName: '+@UserName+'   Password: Training2020  Iphone Application: https://apps.apple.com/us/app/xpoda/id1453166269	   Web Link: http://24.171.173.250:8084'
 --select @SmsContent

SET @CMDSQL = 'cd  C:\inetpub\wwwroot\XpodaSMS\ &&  Xpoda.SMS.exe "1'+@PhoneNumber+'" "'+@SmsContent+'"'

EXEC master..xp_cmdshell @CMDSQL

END

IF @CountryFl=2 /*TR*/ 
BEGIN
	set @SmsContent = 'Hi! Your username and password have been added to Xpoda application.You can access the application from the links below. UserName: '+@UserName+'   Password: Training2020  Iphone Application: https://apps.apple.com/us/app/xpoda/id1453166269	   Web Link: http://24.171.173.250:8084'
 --select @SmsContent

SET @CMDSQL = 'cd  C:\inetpub\wwwroot\XpodaSMS\ &&  Xpoda.SMS.exe "90'+@PhoneNumber+'" "'+@SmsContent+'"'

EXEC master..xp_cmdshell @CMDSQL

END

GO

