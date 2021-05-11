USE [EMS_OCTOPOD]
GO
/****** Object:  StoredProcedure [dbo].[sp_M_CariPersonelInsert]    Script Date: 1.10.2020 11:38:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Change History:
--   19/08/2020 Ömer Kafaoğlu: Cari personel kodu Substring edilerek atılıyor.
-- =============================================
ALTER PROCEDURE [dbo].[sp_M_CariPersonelInsert]
    @ID INT
AS
BEGIN

DECLARE  @Guid uniqueidentifier = NEWID(),
		@DefaultTarih DATETIME='1899-12-31 00:00:00.000',
		@PerKod NVARCHAR(25)='Kimlikno/versiyon',
		@UpdatePerKod NVARCHAR(30),
		@CariPerKod INT

SET @UpdatePerKod = (SELECT KULLANICI_NO FROM MikroDB_V16_ÇİFTAY.dbo.KULLANICILAR_VIEW where KULLANICI_UZUN_ADI = (SELECT per_adi+' '+per_soyadi FROM MikroDB_V16_ÇİFTAY.dbo.PERSONELLER WITH (NOLOCK) WHERE per_caripers_kodu = (SELECT MikroKullanici FROM CY_M_KULLANICI_PARAMETRELERI WITH (NOLOCK) WHERE OctopodKullanici = (SELECT UpdateUser FROM CY_M_PERSONELLER WITH (NOLOCK) WHERE UserTableID=@ID))))

SET @CariPerKod = (SELECT CONVERT(INT,(SUBSTRING(KimlikNo,1,3) +SUBSTRING(KimlikNo,6,1)+SUBSTRING(KimlikNo,9,3)))
 FROM CY_M_PERSONELLER WITH (NOLOCK) WHERE UserTableID=@ID)


INSERT INTO MikroDB_V16_ÇİFTAY.[dbo].[CARI_PERSONEL_TANIMLARI]
           ([cari_per_Guid]
           ,[cari_per_DBCno]
           ,[cari_per_SpecRECno]
           ,[cari_per_iptal]
           ,[cari_per_fileid]
           ,[cari_per_hidden]
           ,[cari_per_kilitli]
           ,[cari_per_degisti]
           ,[cari_per_checksum]
           ,[cari_per_create_user]
           ,[cari_per_create_date]
           ,[cari_per_lastup_user]
           ,[cari_per_lastup_date]
           ,[cari_per_special1]
           ,[cari_per_special2]
           ,[cari_per_special3]
           ,[cari_per_kod]
           ,[cari_per_adi]
           ,[cari_per_soyadi]
           ,[cari_per_tip]
           ,[cari_per_doviz_cinsi]
           ,[cari_per_muhkod0]
           ,[cari_per_muhkod1]
           ,[cari_per_muhkod2]
           ,[cari_per_muhkod3]
           ,[cari_per_muhkod4]
           ,[cari_per_banka_tcmb_kod]
           ,[cari_per_banka_tcmb_subekod]
           ,[cari_per_banka_tcmb_ilkod]
           ,[cari_per_banka_hesapno]
           ,[cari_per_banka_swiftkodu]
           ,[cari_per_prim_adet]
           ,[cari_per_prim_yuzde]
           ,[cari_per_prim_carpani]
           ,[cari_per_basmprimcirotav1]
           ,[cari_per_basmprimyuz1]
           ,[cari_per_basmprimcirotav2]
           ,[cari_per_basmprimyuz2]
           ,[cari_per_basmprimcirotav3]
           ,[cari_per_basmprimyuz3]
           ,[cari_per_basmprimcirotav4]
           ,[cari_per_basmprimyuz4]
           ,[cari_per_basmprimcirotav5]
           ,[cari_per_basmprimyuz5]
           ,[cari_per_kasiyerkodu]
           ,[cari_per_kasiyersifresi]
           ,[cari_per_kasiyerAmiri]
           ,[cari_per_userno]
           ,[cari_per_depono]
           ,[cari_per_cepno]
           ,[cari_per_mail]
           ,[cari_takvim_kodu]
           ,[cari_per_kasiyerfirmaid]
           ,[cari_per_KEP_adresi])
    SELECT
			 @Guid--<cari_per_Guid, uniqueidentifier,>
			 ,0--      ,<cari_per_DBCno, smallint,>
			 ,0--      ,<cari_per_SpecRECno, int,>
			 ,0--      ,<cari_per_iptal, bit,>
			 ,104--      ,<cari_per_fileid, smallint,>
			 ,0--      ,<cari_per_hidden, bit,>
			 ,0--      ,<cari_per_kilitli, bit,>
			 ,0--      ,<cari_per_degisti, bit,>
			 ,0--      ,<cari_per_checksum, int,>
			 ,@UpdatePerKod--      ,<cari_per_create_user, smallint,>
			 ,CreateDate--      ,<cari_per_create_date, datetime,>
			 ,@UpdatePerKod--      ,<cari_per_lastup_user, smallint,>
			 ,UpdateDate--      ,<cari_per_lastup_date, datetime,>
			 ,'OCT'--      ,<cari_per_special1, nvarchar(4),>
			 ,''--      ,<cari_per_special2, nvarchar(4),>
			 ,''--      ,<cari_per_special3, nvarchar(4),>
			 ,@CariPerKod--      ,<cari_per_kod, nvarchar(25),>
			 ,Adi--      ,<cari_per_adi, nvarchar(50),>
			 ,Soyadi--      ,<cari_per_soyadi, nvarchar(50),>
			 ,0--      ,<cari_per_tip, tinyint,>
			 ,0--      ,<cari_per_doviz_cinsi, tinyint,>
			 ,'195.01.01.01'--      ,<cari_per_muhkod0, nvarchar(40),>
			 ,'135.01.01'--      ,<cari_per_muhkod1, nvarchar(40),>
			 ,''--      ,<cari_per_muhkod2, nvarchar(40),>
			 ,''--      ,<cari_per_muhkod3, nvarchar(40),>
			 ,''--      ,<cari_per_muhkod4, nvarchar(40),>
			 ,''--      ,<cari_per_banka_tcmb_kod, nvarchar(4),>
			 ,''--      ,<cari_per_banka_tcmb_subekod, nvarchar(8),>
			 ,''--      ,<cari_per_banka_tcmb_ilkod, nvarchar(3),>
			 ,HesapNo--      ,<cari_per_banka_hesapno, nvarchar(30),>
			 ,''--      ,<cari_per_banka_swiftkodu, nvarchar(25),>
			 ,0--      ,<cari_per_prim_adet, float,>
			 ,0--      ,<cari_per_prim_yuzde, float,>
			 ,0--      ,<cari_per_prim_carpani, float,>
			 ,0--      ,<cari_per_basmprimcirotav1, float,>
			 ,0--      ,<cari_per_basmprimyuz1, float,>
			 ,0--      ,<cari_per_basmprimcirotav2, float,>
			 ,0--      ,<cari_per_basmprimyuz2, float,>
			 ,0--      ,<cari_per_basmprimcirotav3, float,>
			 ,0--      ,<cari_per_basmprimyuz3, float,>
			 ,0--      ,<cari_per_basmprimcirotav4, float,>
			 ,0--      ,<cari_per_basmprimyuz4, float,>
			 ,0--      ,<cari_per_basmprimcirotav5, float,>
			 ,0--      ,<cari_per_basmprimyuz5, float,>
			 ,''--      ,<cari_per_kasiyerkodu, nvarchar(25),>
			 ,''--      ,<cari_per_kasiyersifresi, nvarchar(127),>
			 ,''--      ,<cari_per_kasiyerAmiri, nvarchar(25),>
			 ,0--      ,<cari_per_userno, int,>
			 ,0--      ,<cari_per_depono, int,>
			 ,''--      ,<cari_per_cepno, nvarchar(15),>
			 ,''--      ,<cari_per_mail, nvarchar(50),>
			 ,''--      ,<cari_takvim_kodu, nvarchar(4),>
			 ,''--      ,<cari_per_kasiyerfirmaid, nvarchar(15),>
			 ,''--      ,<cari_per_KEP_adresi, nvarchar(80),>
		   
	FROM CY_M_PERSONELLER WITH (NOLOCK) WHERE UserTableID = @ID

END

