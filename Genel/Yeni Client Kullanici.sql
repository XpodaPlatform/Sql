
create PROCEDURE [dbo].[PM001_AddNewUser]
(
@UserTableID int
)
AS
BEGIN
--select * from XPODA_CLIENT_USERS where UserID=14 (referenceUser)
DECLARE @RefUserId INT=14/* ReferenceProject kullanıcısı refUser (açılış formu ve default şifre için) */,@UserManager bit=0,@UserName NVARCHAR (50),
@UserFullName NVARCHAR (50),
@EPosta NVARCHAR (50),
@UserPhone NVARCHAR (250),
@Img VARBINARY(MAX) ,
@Xpoda_User INT

SET @Xpoda_User = (Select case when Xpoda_User='' then 0 else Xpoda_User end From PM001_PersonEnrollment WITH (NOLOCK) WHERE UserTableID = @UserTableID )

SELECT @UserName=SUBSTRING(FirstName+LastName,1,50),@UserFullName=SUBSTRING(FirstName+' '+LastName,1,50),@EPosta=Email,@UserPhone=Telephone,@Img=Img_1 FROM PM001_PersonEnrollment WITH (NOLOCK) WHERE UserTableID = @UserTableID

IF @Xpoda_User = 0
BEGIN

INSERT INTO [dbo].[XPODA_CLIENT_USERS]
   ([CreateDate]
   ,[UpdateDate]
   ,[UserName]
   ,[UserFullName]
   ,[UserPassword]
   ,[UserEmail]
   ,[UserManager]
   ,[UserActive]
   ,[UserMenu]
   ,[UserOpenProjectID]
   ,[UserOpenForm]
   ,[UserColor]
   ,[UserImage]
   ,[UserOnline]
   ,[UserAuthTicket]
   ,[UserType]
   ,[UserChatState]
   ,[UserChatUsers]
   ,[UserHiddenMenu]
   ,[UserPhone]
   ,[SmsLogin])
SELECT 
	GETDATE()
   ,GETDATE()
   ,@UserName
   ,@UserFullName
   ,[UserPassword]
   ,@EPosta
   ,@UserManager
   ,[UserActive]
   ,[UserMenu]
   ,[UserOpenProjectID]
   ,[UserOpenForm]
   ,[UserColor]
   ,@Img
   ,[UserOnline]
   ,[UserAuthTicket]
   ,[UserType]
   ,[UserChatState]
   ,[UserChatUsers]
   ,[UserHiddenMenu]
   ,@UserPhone
   ,[SmsLogin]
FROM XPODA_CLIENT_USERS WITH (NOLOCK)
WHERE UserID=@RefUserId

END
ELSE 
BEGIN

	UPDATE [dbo].[XPODA_CLIENT_USERS]
   SET [UpdateDate] = GETDATE()
      ,[UserName] = @UserName
      ,[UserFullName] = @UserFullName
      ,[UserEmail] = @EPosta
      ,[UserImage] = @Img
      ,[UserPhone] = @UserPhone
  WHERE UserID = @Xpoda_User

END





END
