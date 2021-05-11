USE [EMS_OCTOPOD]
GO
/****** Object:  StoredProcedure [dbo].[sp_M_MeyerSicilInsert]    Script Date: 1.10.2020 11:38:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Furkan Camcı
-- Create date: 16/03/2020
-- Description: Meyer'e sicil ve userlist tablolarına kayıt atan sorgu. Mikro personel insert tablosunun içine eklenebilir.
--DUTY insert hazırlandı. 06.05.2020
-- Change History:
--   12/08/2020 Gökhan Yılmaz: Sicil tablosunda insert alanında FotoImage, ExpireDate, KanGrubu, SicilKilit, DogumTarihi, KidemTarihi, PictureID, GorevID, GlobalSicilID, TerminalGrubu, Telefon1, Telefon2, CepTelefın, Adres, IL, Ilce, Bilgi, OKod1, OKod2, OKod3, OKod4, OKod5, OKod6, OKod7, OKod8, OKod9, OKod10, AltFirma, Cinsiyet, Email, Direktorluk, Yaka, Puantaj alanlarının değerleri değiştirildi.
--   12/08/2020 Gökhan Yılmaz: UserList tablosunda insert alanında FacilityCode, FingerID1, FingerID2, FPData alanlarının değerleri değiştirildi.
-- =============================================
ALTER PROCEDURE [dbo].[sp_M_MeyerSicilInsert]
    @UserTableID INT  
AS
BEGIN

DECLARE @SicilID INT =0, @UserListID INT=0, @DefaultDateTime DATETIME,
@UserID nvarchar(8)

set @UserID = (select [dbo].[fn_M_YeniMeyerSicilUserID]())

SET @DefaultDateTime = (SELECT '1900-01-01')
--select @DefaultDateTime
SET @SicilID = (SELECT ISNULL(MAX([ID]),0)+1 FROM [CIFTAY_MEYER].[CIFTAY_MEYER].[dbo].[Sicil] WITH (NOLOCK))

SET @UserListID = (SELECT ISNULL(MAX([ID]),0)+1 FROM [CIFTAY_MEYER].[CIFTAY_MEYER].[dbo].[UserList] WITH (NOLOCK))

--eğer sicil tablosunda kayıt yoksa insert yapılır. varsa update yapılır.
IF NOT EXISTS (SELECT * FROM CIFTAY_MEYER.CIFTAY_MEYER.dbo.Sicil WITH (NOLOCK) WHERE [PersonelNo] = (SELECT PersSicilNo FROM CY_M_PERSONELLER WITH (NOLOCK) WHERE UserTableID = @UserTableID))
BEGIN

INSERT INTO [CIFTAY_MEYER].[CIFTAY_MEYER].[dbo].[UserList]
           ([ID]
           ,[UserID]
           ,[CardType]
           ,[CardID]
           ,[CardAttribute]
           ,[FacilityCode]
           ,[FingerID1]
           ,[FingerID2]
           ,[FPData]
           ,[UserDef]
           ,[Function]
           ,[Master]
           ,[BypassCard]
           ,[startdate]
           ,[enddate]
           ,[CardID26]
           ,[IsTimezone]
           ,[Deleted]
           ,[zyrt]
           ,[isAPB]
           ,[Aciklama])
     SELECT
           @UserListID--(<ID, int,>
           ,@UserID--,<UserID, nvarchar(8),>
           ,0--,<CardType, int,>
           ,''--,<CardID, nvarchar(15),>
           ,0--,<CardAttribute, int,>
           ,'000000'--,<FacilityCode, nvarchar(8),>
           ,null--,<FingerID1, nvarchar(4),>
           ,null--,<FingerID2, nvarchar(4),>
           ,null--,<FPData, ntext,>
           ,1--,<UserDef, int,>
           ,0--,<Function, int,>
           ,0--,<Master, int,>
           ,0--,<BypassCard, int,>
           ,null--@DefaultDateTime--,<startdate, datetime,>
           ,null--@DefaultDateTime--,<enddate, datetime,>
           ,''--,<CardID26, nvarchar(50),>
           ,0--,<IsTimezone, int,>
           ,null--,<Deleted, bit,>
           ,0--,<zyrt, int,>
           ,0--,<isAPB, int,>
           ,null--,<Aciklama, nvarchar(500),>)
	FROM CY_M_PERSONELLER as P WITH (NOLOCK) 
	LEFT OUTER JOIN CY_M_YETKI_TANIMLARI as YT WITH (NOLOCK)  ON YT.Personel=P.KimlikNo
	WHERE P.UserTableID = @UserTableID

	INSERT INTO [CIFTAY_MEYER].[CIFTAY_MEYER].[dbo].[Sicil]
           ([ID]
		   ,[UserID]
           ,[Firma]
           ,[TerminalGrubu]
           ,[Ad]
           ,[Soyad]
           ,[PersonelNo]
           ,[GirisTarih]
           ,[CikisTarih]
           ,[SicilNo]
           ,[Pozisyon]
           ,[Bolum]
           ,[Telefon1]
           ,[Telefon2]
           ,[CepTelefon]
           ,[Adres]
           ,[IL]
           ,[Ilce]
           ,[KanGrubu]
           ,[FotoImage]
           ,[Bilgi]
           ,[MesaiPeriyodu]
           ,[PeriyodBaslangici]
           ,[SonDurum]
           ,[ExpireDate]
           ,[FazlaMesai]
           ,[EksikMesai]
           ,[EksikMesai_FM]
           ,[ErkenMesai]
           ,[EksikGun]
           ,[MaasTipi]
           ,[Maas]
           ,[AylikCalismaSaati]
           ,[SonTasnifID]
           ,[SicilKilit]
           ,[DogumTarih]
           ,[OKod1]
           ,[OKod2]
           ,[OKod3]
           ,[OKod4]
           ,[OKod5]
           ,[OKod6]
           ,[OKod7]
           ,[OKod8]
           ,[OKod9]
           ,[OKod10]
           ,[GeceZammi]
           ,[FM_EM]
           ,[Gorev]
           ,[bitistarih]
           ,[AltFirma]
           ,[Cinsiyet]
           ,[EMail]
           ,[Direktorluk]
           ,[Yaka]
           ,[Puantaj]
           ,[KidemTarih]
           ,[BirimId]
           ,[PictureId]
           ,[ZiyaretciKabulDurum]
           ,[GorevId]
           ,[Deleted]
           ,[AmirId]
           ,[GlobalSicilID])
     SELECT
			@SicilID
           ,@UserID--(<UserID, nvarchar(8),>
           ,1--,<Firma, int,>
           ,null--,<TerminalGrubu, int,>
           ,Adi--,<Ad, nvarchar(50),>
           ,Soyadi--,<Soyad, nvarchar(50),>
           ,PersSicilNo--,<PersonelNo, nvarchar(20),>
           ,case when GirisTarihi='1899-12-31 00:00:00.000' then NULL ELSE GirisTarihi end--,<GirisTarih, smalldatetime,>
           ,case when CikisTarihi='1899-12-31 00:00:00.000' then NULL ELSE CikisTarihi end--,<CikisTarih, smalldatetime,>
           ,PersonelSicilNo--,<SicilNo, nvarchar(20),>
           ,0--,<Pozisyon, int,>
           ,0--,<Bolum, int,>
           ,null--,<Telefon1, nvarchar(20),>
           ,null--,<Telefon2, nvarchar(20),>
           ,null--,<CepTelefon, nvarchar(20),>
           ,null--,<Adres, nvarchar(100),>
           ,null--,<IL, nvarchar(20),>
           ,null--,<Ilce, nvarchar(20),>
           ,null--,<KanGrubu, int,>
           ,null--,<FotoImage, image,>
           ,null--,<Bilgi, ntext,>
           ,0--,<MesaiPeriyodu, int,>
           ,null--CONVERT(smalldatetime,@DefaultDateTime)--,<PeriyodBaslangici, smalldatetime,>
           ,0--,<SonDurum, bit,>
           ,'2039-07-08 15:46:58.747'--@DefaultDateTime--,<ExpireDate, datetime,>
           ,0--,<FazlaMesai, bit,>
           ,0--,<EksikMesai, bit,>
           ,0--,<EksikMesai_FM, bit,>
           ,0--,<ErkenMesai, bit,>
           ,0--,<EksikGun, bit,>
           ,0--,<MaasTipi, int,>
           ,0--,<Maas, int,>
           ,0--,<AylikCalismaSaati, real,>
           ,0--,<SonTasnifID, int,>
           ,null--,<SicilKilit, tinyint,>
           ,'2019-07-01 00:00:00'--CONVERT(smalldatetime,@DefaultDateTime)--,<DogumTarih, smalldatetime,>
           ,null--,<OKod1, nvarchar(50),>
           ,null--,<OKod2, nvarchar(50),>
           ,null--,<OKod3, nvarchar(50),>
           ,null--,<OKod4, nvarchar(50),>
           ,null--,<OKod5, nvarchar(50),>
           ,null--,<OKod6, nvarchar(50),>
           ,null--,<OKod7, nvarchar(50),>
           ,null--,<OKod8, nvarchar(50),>
           ,null--,<OKod9, nvarchar(50),>
           ,null--,<OKod10, nvarchar(50),>
           ,0--,<GeceZammi, bit,>
           ,0--,<FM_EM, bit,>
           ,0--,<Gorev, int,>
           ,null--@DefaultDateTime--,<bitistarih, datetime,>
           ,null--,<AltFirma, int,>
           ,null--,<Cinsiyet, int,>
           ,null--,<EMail, nvarchar(100),>
           ,null--,<Direktorluk, int,>
           ,null--,<Yaka, int,>
           ,null--,<Puantaj, int,>
           ,'2019-07-01 00:00:00'--CONVERT(smalldatetime,@DefaultDateTime)--,<KidemTarih, smalldatetime,>
           ,1--,<BirimId, int,>
           ,null--,<PictureId, nvarchar(500),>
           ,0--,<ZiyaretciKabulDurum, bit,>
           ,null--,<GorevId, int,>
           ,0--,<Deleted, bit,>
           ,0--,<AmirId, int,>
           ,null--,<GlobalSicilID, int,>)

	FROM CY_M_PERSONELLER WITH (NOLOCK) 
	WHERE UserTableID=@UserTableID

	INSERT INTO [CIFTAY_MEYER].[CIFTAY_MEYER].[dbo].[UserFinger]
           ([UserID]
           ,[FPData1]
           ,[FPData2]
           ,[FPData3]
           ,[FPData4]
           ,[FPData5]
           ,[FPData6]
           ,[FPData7]
           ,[FPData8]
           ,[FPData9]
           ,[FPData10]
           ,[FaceData]
           ,[FPQ1]
           ,[FPQ2]
           ,[FPQ3]
           ,[FPQ4]
           ,[FPQ5]
           ,[FPQ6]
           ,[FPQ7]
           ,[FPQ8]
           ,[FPQ9]
           ,[FPQ10]
           ,[FaceData1]
           ,[FaceData2]
           ,[FaceData3]
           ,[FaceData4]
           ,[FaceData5]
           ,[FaceData6]
           ,[FaceData7]
           ,[FaceData8]
           ,[FaceData9]
           ,[FaceData10]
           ,[FaceData11]
           ,[FaceData12]
           ,[FaceData13]
           ,[FaceData14]
           ,[FaceData15]
           ,[FaceData16]
           ,[FaceData17]
           ,[FaceData18]
           ,[FaceData19]
           ,[FaceData20]
           ,[FaceData21]
           ,[FaceData22]
           ,[FaceData23]
           ,[FaceData24]
           ,[FaceData25])
     VALUES
           (@UserID--<UserID, nvarchar,>
           ,null--<FPData1, text,>
           ,null--<FPData2, text,>
           ,null--<FPData3, text,>
           ,null--<FPData4, text,>
           ,null--<FPData5, text,>
           ,null--<FPData6, text,>
           ,null--<FPData7, text,>
           ,null--<FPData8, text,>
           ,null--<FPData9, text,>
           ,null--<FPData10, text,>
           ,null--<FaceData, image,>
           ,0--<FPQ1, int,>
           ,0--<FPQ2, int,>
           ,0--<FPQ3, int,>
           ,0--<FPQ4, int,>
           ,0--<FPQ5, int,>
           ,0--<FPQ6, int,>
           ,0--<FPQ7, int,>
           ,0--<FPQ8, int,>
           ,0--<FPQ9, int,>
           ,0--<FPQ10, int,>
           ,null--<FaceData1, text,>
           ,null--<FaceData2, text,>
           ,null--<FaceData3, text,>
           ,null--<FaceData4, text,>
           ,null--<FaceData5, text,>
           ,null--<FaceData6, text,>
           ,null--<FaceData7, text,>
           ,null--<FaceData8, text,>
           ,null--<FaceData9, text,>
           ,null--<FaceData10, text,>
           ,null--<FaceData11, text,>
           ,null--<FaceData12, text,>
           ,null--<FaceData13, text,>
           ,null--<FaceData14, text,>
           ,null--<FaceData15, text,>
           ,null--<FaceData16, text,>
           ,null--<FaceData17, text,>
           ,null--<FaceData18, text,>
           ,null--<FaceData19, text,>
           ,null--<FaceData20, text,>
           ,null--<FaceData21, text,>
           ,null--<FaceData22, text,>
           ,null--<FaceData23, text,>
           ,null--<FaceData24, text,>
           ,null--<FaceData25, text,>
		   )

--Tanımlanan kullanıcının kart numarasını da aşağıdaki tabloya gönderiyoruz.
	
END

ELSE --update

BEGIN

UPDATE [CIFTAY_MEYER].[CIFTAY_MEYER].[dbo].[Sicil]
	SET 
		[Ad] = Adi--<Ad, nvarchar(50),>
      ,[Soyad] = Soyadi--<Soyad, nvarchar(50),>
      ,[PersonelNo] = PersSicilNo--<PersonelNo, nvarchar(20),>
	  ,[SicilNo] = PersonelSicilNo
      ,[GirisTarih] = case when GirisTarihi='1899-12-31 00:00:00.000' then NULL ELSE GirisTarihi end--<GirisTarih, smalldatetime,>
      ,[CikisTarih] = case when CikisTarihi='1899-12-31 00:00:00.000' then NULL ELSE CikisTarihi end--<CikisTarih, smalldatetime,>

	FROM CY_M_PERSONELLER WITH (NOLOCK) 
	LEFT OUTER JOIN [CIFTAY_MEYER].[CIFTAY_MEYER].[dbo].[Sicil] WITH (NOLOCK) ON PersonelNo = PersSicilNo
	WHERE UserTableID = @UserTableID

--UserList update
UPDATE [CIFTAY_MEYER].[CIFTAY_MEYER].[dbo].[UserList]
	SET 
		[CardID] = (select YT.KartNo
	FROM CY_M_PERSONELLER as P WITH (NOLOCK)
	LEFT OUTER JOIN CY_M_YETKI_TANIMLARI as YT WITH (NOLOCK) ON YT.Personel=P.KimlikNo
	WHERE P.UserTableID = @UserTableID)
	WHERE UserID=(select UserID FROM CIFTAY_MEYER.CIFTAY_MEYER.dbo.Sicil WITH (NOLOCK)
	LEFT OUTER JOIN CY_M_PERSONELLER WITH (NOLOCK) ON PersonelNo = PersSicilNo
	WHERE UserTableID = @UserTableID)

END

END


